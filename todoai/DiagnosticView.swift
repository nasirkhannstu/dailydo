//
//  DiagnosticView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import SwiftUI

struct DiagnosticView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("DailyDo App")
                .font(.largeTitle)
                .bold()

            Text("App is running correctly!")
                .font(.headline)

            Text("If you see this, the app file is working.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Label("Habits Tab", systemImage: "repeat.circle.fill")
                Label("Plans Tab", systemImage: "calendar.badge.checkmark")
                Label("Calendar Tab", systemImage: "calendar")
                Label("Lists Tab", systemImage: "list.bullet.circle.fill")
                Label("Settings Tab", systemImage: "gearshape.fill")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Text("These tabs should appear at the bottom")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    DiagnosticView()
}
