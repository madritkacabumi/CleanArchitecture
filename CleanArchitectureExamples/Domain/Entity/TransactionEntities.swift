//
//  TransactionEntities.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

// MARK: - Transaction
struct Transaction: Codable {
    let merchantDisplayName: String
    let reference: String
    let categoryId: Int
    let transactionDetail: TransactionDetail
    
    enum CodingKeys: String, CodingKey {
        case merchantDisplayName = "merchant_display_name"
        case reference
        case categoryId = "category_id"
        case transactionDetail = "transaction_detail"
    }
}

// MARK: - TransactionDetail
struct TransactionDetail: Codable {
    let description: String
    let transactionDate: Date
    let amount: Int
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case description, amount, currency
        case transactionDate = "transaction_date"
    }
}

extension TransactionDetail {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .description)
        let dateString = try container.decode(String.self, forKey: .transactionDate)
        guard let parsedDate = CustomDateFormatter.dateFromString(dateFormat: .iso8601, dateString: dateString) else {
            throw DecodingError.invalidParsingDate
        }
        transactionDate = parsedDate
        
        amount = try container.decode(Int.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
    }
}
