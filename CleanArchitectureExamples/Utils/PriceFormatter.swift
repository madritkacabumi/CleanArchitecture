//
//  PriceFormatter.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

struct PriceFormatter {
    
    static func convertPrice(amount: NSNumber, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: amount)!
    }
}
