//
//  IconPickerView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""

    let iconCategories: [IconCategory] = [
        IconCategory(name: "Popular", icons: [
            "star.fill", "heart.fill", "checkmark.circle.fill", "flag.fill",
            "bookmark.fill", "tag.fill", "bell.fill", "calendar"
        ]),
        IconCategory(name: "Habits & Health", icons: [
            "figure.walk", "figure.run", "bicycle", "figure.yoga",
            "drop.fill", "heart.text.square.fill", "bed.double.fill", "moon.zzz.fill",
            "fork.knife", "cup.and.saucer.fill", "pill.fill", "cross.vial.fill"
        ]),
        IconCategory(name: "Plans & Goals", icons: [
            "target", "flag.checkered", "trophy.fill", "graduationcap.fill",
            "airplane", "suitcase.fill", "briefcase.fill", "building.2.fill",
            "lightbulb.fill", "chart.line.uptrend.xyaxis", "doc.text.fill", "list.bullet.clipboard.fill"
        ]),
        IconCategory(name: "Lists & Shopping", icons: [
            "cart.fill", "bag.fill", "basket.fill", "creditcard.fill",
            "list.bullet", "checklist", "square.and.pencil", "doc.plaintext.fill"
        ]),
        IconCategory(name: "Entertainment", icons: [
            "film.fill", "tv.fill", "music.note", "headphones",
            "book.fill", "books.vertical.fill", "gamecontroller.fill", "sportscourt.fill",
            "theatermasks.fill", "camera.fill", "photo.fill", "paintbrush.fill"
        ]),
        IconCategory(name: "Work & Productivity", icons: [
            "laptopcomputer", "desktopcomputer", "iphone", "keyboard",
            "pencil", "highlighter", "paperclip", "folder.fill",
            "tray.fill", "archivebox.fill", "shippingbox.fill", "envelope.fill"
        ]),
        IconCategory(name: "Nature & Weather", icons: [
            "leaf.fill", "tree.fill", "sun.max.fill", "moon.fill",
            "cloud.fill", "snowflake", "flame.fill", "drop.triangle.fill"
        ]),
        IconCategory(name: "Symbols", icons: [
            "circle.fill", "square.fill", "triangle.fill", "diamond.fill",
            "hexagon.fill", "seal.fill", "rosette", "shield.fill",
            "bolt.fill", "sparkles", "crown.fill", "gem.fill"
        ])
    ]

    var filteredCategories: [IconCategory] {
        if searchText.isEmpty {
            return iconCategories
        } else {
            return iconCategories.map { category in
                IconCategory(
                    name: category.name,
                    icons: category.icons.filter { $0.localizedCaseInsensitiveContains(searchText) }
                )
            }.filter { !$0.icons.isEmpty }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(filteredCategories) { category in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.name)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)

                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 60))
                            ], spacing: 12) {
                                ForEach(category.icons, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
                                        dismiss()
                                    } label: {
                                        VStack(spacing: 4) {
                                            Image(systemName: icon)
                                                .font(.system(size: 28))
                                                .frame(width: 60, height: 60)
                                                .background(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                                .cornerRadius(12)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search icons")
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct IconCategory: Identifiable {
    let id = UUID()
    let name: String
    let icons: [String]
}

#Preview {
    IconPickerView(selectedIcon: .constant("star.fill"))
}
