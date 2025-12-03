//
//  ProductType.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation

enum ProductType: String, Codable, CaseIterable {
    case color
    case texture
    case screen
    case credits
    case subscription

    var displayName: String {
        switch self {
        case .color:
            return "Color"
        case .texture:
            return "Texture"
        case .screen:
            return "Screen Theme"
        case .credits:
            return "AI Credits"
        case .subscription:
            return "Premium Subscription"
        }
    }

    var icon: String {
        switch self {
        case .color:
            return "paintpalette.fill"
        case .texture:
            return "square.grid.3x3.fill"
        case .screen:
            return "rectangle.fill"
        case .credits:
            return "sparkles"
        case .subscription:
            return "crown.fill"
        }
    }
}
