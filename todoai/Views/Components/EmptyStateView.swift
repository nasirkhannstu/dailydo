//
//  EmptyStateView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import SwiftUI

struct EmptyStateView<ActionContent: View>: View {
    let icon: String
    let title: String
    let message: String
    @ViewBuilder let actionContent: () -> ActionContent

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary.opacity(0.5))

            // Title & Message
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            // Action buttons
            actionContent()
                .padding(.horizontal, 32)
                .padding(.top, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "repeat.circle",
        title: "No habits yet",
        message: "Start building better habits today"
    ) {
        VStack(spacing: 12) {
            Button {
                // Action
            } label: {
                Label("Browse Templates", systemImage: "sparkles")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                // Action
            } label: {
                Label("Create Custom", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}
