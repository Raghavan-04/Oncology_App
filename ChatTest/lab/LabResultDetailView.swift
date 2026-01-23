//
//  LabResultDetailView.swift
//  ChatTest
//
//  Created by Raghavan on 29/09/24.
//

import Foundation
import SwiftUI
struct LabResultDetailView: View {
    let labResult: LabResult
    @State private var showingShareSheet = false

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

            Chart {
                ForEach(labResult.values.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Measurement", Double(index + 1)),
                        y: .value("Value", labResult.values[index])
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 300)
            .padding()

            Button(action: {
                showingShareSheet = true
            }) {
                Label("Share Results", systemImage: "square.and.arrow.up")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showingShareSheet, content: {
                ActivityView(activityItems: [labResult.result])
            })

            Spacer()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
