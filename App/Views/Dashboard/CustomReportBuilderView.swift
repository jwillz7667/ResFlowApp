// App/Views/Dashboard/CustomReportBuilderView.swift

import SwiftUI

struct CustomReportBuilderView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedMetrics: Set<String> = []

    let metrics = ["Total Sales", "Total Orders", "Top Selling Items"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Report Builder")
                .font(.largeTitle)
                .fontWeight(.bold)

            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .padding()

            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                .padding()

            Text("Select Metrics")
                .font(.headline)
                .padding()

            ForEach(metrics, id: \.self) { metric in
                Toggle(metric, isOn: Binding(
                    get: { selectedMetrics.contains(metric) },
                    set: { isSelected in
                        if isSelected {
                            selectedMetrics.insert(metric)
                        } else {
                            selectedMetrics.remove(metric)
                        }
                    }
                ))
                .padding()
            }

            Button(action: generateReport) {
                Text("Generate Report")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 16)

            Spacer()
        }
        .padding()
    }

    private func generateReport() {
        // Logic to generate the report based on selected metrics and date range
    }
}
