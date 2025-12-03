//
//  User.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String?
    var isPremium: Bool
    var premiumExpiryDate: Date?
    var aiCreditBalance: Int
    var referralCode: String
    var createdDate: Date

    @Relationship(deleteRule: .cascade) var subtypes: [Subtype]
    @Relationship(deleteRule: .cascade) var purchasedProducts: [PurchasedProduct]

    init(
        id: UUID = UUID(),
        name: String = "",
        email: String? = nil,
        isPremium: Bool = false,
        premiumExpiryDate: Date? = nil,
        aiCreditBalance: Int = 5, // 5 free credits
        referralCode: String = "",
        createdDate: Date = Date(),
        subtypes: [Subtype] = [],
        purchasedProducts: [PurchasedProduct] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.isPremium = isPremium
        self.premiumExpiryDate = premiumExpiryDate
        self.aiCreditBalance = aiCreditBalance
        self.referralCode = referralCode.isEmpty ? User.generateReferralCode() : referralCode
        self.createdDate = createdDate
        self.subtypes = subtypes
        self.purchasedProducts = purchasedProducts
    }

    // Generate unique referral code
    static func generateReferralCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in characters.randomElement()! })
    }

    // Check if user has premium access
    var hasPremiumAccess: Bool {
        guard isPremium else { return false }
        if let expiryDate = premiumExpiryDate {
            return expiryDate > Date()
        }
        return false
    }

    // Check if user has AI credits
    var hasAICredits: Bool {
        return aiCreditBalance > 0
    }

    // Deduct AI credit
    func deductAICredit() -> Bool {
        guard aiCreditBalance > 0 else { return false }
        aiCreditBalance -= 1
        return true
    }

    // Add AI credits
    func addAICredits(_ amount: Int) {
        aiCreditBalance += amount
    }
}
