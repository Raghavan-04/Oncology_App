import SwiftUI
import Charts

struct LabResultsView: View {
    @State private var searchText = ""
    @State private var sortAscending = true
    @State private var showSearchBar = false
    @State private var favoriteResults = Set<UUID>() // Track favorite lab results

    // Sample data for lab results
    let labResults: [LabResult] = [
        LabResult(testName: "Complete Blood Count (CBC)", result: "Normal", date: "2024-09-15", values: [5.0, 4.8, 5.2,5.9, 4.8, 5.0]), // Normal range
        LabResult(testName: "Lipid Panel", result: "Cholesterol Level: High", date: "2024-10-01", values: [245, 250, 260,230, 235, 260]), // High cholesterol
        LabResult(testName: "Liver Function Test", result: "Elevated Liver Enzymes", date: "2024-09-05", values: [52, 60, 58,55,53,65]), // Elevated enzymes
        LabResult(testName: "Thyroid Panel", result: "TSH Normal", date: "2024-10-05", values: [1.0, 1.2, 1.1]), // Normal TSH levels
        LabResult(testName: "Prostate-Specific Antigen (PSA)", result: "Elevated", date: "2024-09-20", values: [4.5, 5.1]), // Elevated PSA levels
        LabResult(testName: "CA-125", result: "Elevated", date: "2024-09-25", values: [50, 55]), // Elevated CA-125
        LabResult(testName: "AFP (Alpha-fetoprotein)", result: "Normal", date: "2024-09-18", values: [3.2, 3.1]), // Normal AFP
        LabResult(testName: "CEA (Carcinoembryonic Antigen)", result: "Slightly Elevated", date: "2024-09-12", values: [3.5]), // Slightly elevated CEA
        LabResult(testName: "Bone Marrow Biopsy", result: "Pending", date: "2024-10-10", values: []), // No values as it's pending
        LabResult(testName: "Genetic Testing for BRCA", result: "Negative", date: "2024-09-30", values: []) // No values as it's a negative test
    ]
   /* 1.    CBC: Normal white blood cell counts, indicating no immediate issues.
        2.    Lipid Panel: Cholesterol levels indicating high risk, useful in assessing cardiovascular health.
        3.    Liver Function Test: Elevated liver enzymes, suggesting potential liver issues.
        4.    Thyroid Panel: Normal TSH levels indicating proper thyroid function.
        5.    PSA: Elevated PSA levels, potentially indicating prostate issues.
        6.    CA-125: Elevated levels, often used to monitor ovarian cancer.
        7.    AFP: Normal values, typically indicating no liver cancer or germ cell tumors.
        8.    CEA: Slightly elevated levels, sometimes associated with colorectal cancer.
        9.    Bone Marrow Biopsy: Pending, indicating no results yet available.
        10.    Genetic Testing: Negative result, meaning no BRCA mutations detected.*/

    var filteredResults: [LabResult] {
        labResults.filter { result in
            searchText.isEmpty || result.testName.localizedCaseInsensitiveContains(searchText)
        }
        .sorted(by: { sortAscending ? $0.date < $1.date : $0.date > $1.date })
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { showSearchBar.toggle() }) {
                        Text(showSearchBar ? "Hide Search Bar" : "Show Search Bar")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.leading)

                    Spacer()

                    Button(action: { sortAscending.toggle() }) {
                        Text(sortAscending ? "Sort Descending" : "Sort Ascending")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                .padding(.top)

                if showSearchBar {
                    TextField("Search Results", text: $searchText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                List {
                    Section(header: Text("Upcoming Results")) {
                        ForEach(filteredResults.filter { $0.date > getCurrentDate() }) { result in
                            NavigationLink(destination: LabResultDetailView(labResult: result)) {
                                LabResultRow(result: result, favoriteResults: $favoriteResults, showStar: true)
                            }
                        }
                    }

                    Section(header: Text("Current Results")) {
                        ForEach(filteredResults.filter { $0.date == getCurrentDate() }) { result in
                            NavigationLink(destination: LabResultDetailView(labResult: result)) {
                                LabResultRow(result: result, favoriteResults: $favoriteResults, showStar: true)
                            }
                        }
                    }

                    Section(header: Text("Past Results")) {
                        ForEach(filteredResults.filter { $0.date < getCurrentDate() }) { result in
                            NavigationLink(destination: LabResultDetailView(labResult: result)) {
                                LabResultRow(result: result, favoriteResults: $favoriteResults, showStar: true)
                            }
                        }
                    }

                    // Section for favorite results
                    if !favoriteResults.isEmpty {
                        Section(header: Text("Favorite Results")) {
                            ForEach(filteredResults.filter { favoriteResults.contains($0.id) }) { result in
                                NavigationLink(destination: LabResultDetailView(labResult: result)) {
                                    LabResultRow(result: result, favoriteResults: $favoriteResults, showStar: true)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Lab Results")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

// Model for lab results
struct LabResult: Identifiable {
    let id = UUID()
    let testName: String
    let result: String
    let date: String
    let values: [Double]
}

// Row view for displaying each lab result with favorite feature
struct LabResultRow: View {
    let result: LabResult
    @Binding var favoriteResults: Set<UUID>
    var showStar: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(result.testName)
                    .font(.headline)
                Text("Result: \(result.result)")
                    .font(.subheadline)
                Text("Date: \(result.date)")
                    .font(.footnote)
                    .foregroundColor(.gray)

                if let firstValue = result.values.first {
                    Text("Latest Value: \(firstValue)")
                        .foregroundColor(getValueColor(value: firstValue))
                        .font(.footnote)
                }
            }
            .padding()

            Spacer()

            // Show the star button only if `showStar` is true
            if showStar {
                Button(action: {
                    if favoriteResults.contains(result.id) {
                        favoriteResults.remove(result.id)
                    } else {
                        favoriteResults.insert(result.id)
                    }
                }) {
                    Image(systemName: favoriteResults.contains(result.id) ? "star.fill" : "star")
                        .foregroundColor(favoriteResults.contains(result.id) ? .yellow : .gray)
                }
            }
        }
    }

    // Helper function to color-code values
    func getValueColor(value: Double) -> Color {
        if value > 200 {
            return .red
        } else if value < 100 {
            return .green
        } else {
            return .orange
        }
    }
}

// Detail view for showing graph
struct LabResultDetailView: View {
    let labResult: LabResult
    @State private var chartType = "Line"

    var body: some View {
        VStack {
            Text(labResult.testName)
                .font(.largeTitle)
                .padding()

            Text("Result: \(labResult.result)")
                .font(.title)
                .padding()

            Text("Date: \(labResult.date)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()

            Text("This chart shows the values over time. Please refer to your healthcare provider for further interpretation.")
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.top, 5)

            Picker("Chart Type", selection: $chartType) {
                Text("Line Chart").tag("Line")
                Text("Bar Chart").tag("Bar")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if chartType == "Line" {
                // Line chart representation
                Chart {
                    ForEach(labResult.values.indices, id: \.self) { index in
                        LineMark(
                            x: .value("Measurement", Double(index + 1)),
                            y: .value("Value", labResult.values[index])
                        )
                        .foregroundStyle(.blue)
                        .symbol(.circle)
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 300)
                .padding()
            } else {
                // Bar chart representation
                Chart {
                    ForEach(labResult.values.indices, id: \.self) { index in
                        BarMark(
                            x: .value("Measurement", Double(index + 1)),
                            y: .value("Value", labResult.values[index])
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 300)
                .padding()
            }

            Spacer()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LabResultsView_Previews: PreviewProvider {
    static var previews: some View {
        LabResultsView()
    }
}
