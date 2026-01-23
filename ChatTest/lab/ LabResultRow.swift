//
//   LabResultRow.swift
//  ChatTest
//
//  Created by Raghavan on 29/09/24.
//

import Foundation
struct LabResultRow: View {
    let result: LabResult
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(result.testName)
                .font(.headline)
            Text("Result: \(result.result)")
                .font(.subheadline)
                .foregroundColor(getResultColor(result.result))
            Text("Date: \(result.date)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    // Helper function to color-code results
    func getResultColor(_ result: String) -> Color {
        if result.contains("Pending") {
            return .orange
        } else if result.contains("Normal") {
            return .green
        } else {
            return .red
        }
    }
}
