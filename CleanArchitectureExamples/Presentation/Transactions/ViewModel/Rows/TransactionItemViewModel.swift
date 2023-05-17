//
//  TransactionItemViewModel.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import Foundation
struct TransactionItemViewModel: Identifiable {
    
    let id = UUID().uuidString
    
    // MARK: - Private properties
    let _transaction: Transaction
    
    // MARK: - Exposed Properties
    let transactionDate: String
    let merchantDisplayName: String
    let transactionDescription: String
    let formattedPrice: String
    
    // MARK: - Construct
    init(transaction: Transaction) {
        
        self._transaction = transaction
        self.transactionDate = CustomDateFormatter.dateToString(date: transaction.transactionDetail.transactionDate, formatOptions:
                                                            [.withSpaceBetweenDateAndTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTime, .withFullDate])
        self.merchantDisplayName = transaction.merchantDisplayName
        self.transactionDescription = transaction.transactionDetail.description
        
        let amount = NSNumber(value: transaction.transactionDetail.amount)
        self.formattedPrice = PriceFormatter.convertPrice(amount: amount, currencyCode: transaction.transactionDetail.currency)
    }
}
