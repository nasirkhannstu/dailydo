//
//  PurchasedProduct.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData

@Model
class PurchasedProduct {
    @Attribute(.unique) var id: UUID
    var productID: String
    var productType: ProductType
    var purchaseDate: Date
    var transactionID: String?
    var receiptData: String?

    @Relationship(inverse: \User.purchasedProducts) var user: User?

    init(
        id: UUID = UUID(),
        productID: String,
        productType: ProductType,
        purchaseDate: Date = Date(),
        transactionID: String? = nil,
        receiptData: String? = nil,
        user: User? = nil
    ) {
        self.id = id
        self.productID = productID
        self.productType = productType
        self.purchaseDate = purchaseDate
        self.transactionID = transactionID
        self.receiptData = receiptData
        self.user = user
    }
}
