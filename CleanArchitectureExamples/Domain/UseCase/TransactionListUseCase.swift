//
//  TransactionListUseCase.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine

struct TransactionsWrapper {
    let categories: [Int]
    let currentCategory: Int?
    let transactions: [Transaction]
    
    init(selectedCategory: Int?, transactionsList: [Transaction]) {
        categories = Set(transactionsList.map { $0.categoryId }).sorted(by: {$0 < $1})
        self.currentCategory = selectedCategory
        var items = transactionsList
        
        if let category = selectedCategory {
            items = items.filter { $0.categoryId == category }
        }
        
        items = items.sorted(by: { transaction1, transaction2 in
            transaction1.transactionDetail.transactionDate > transaction2.transactionDetail.transactionDate
        })
        
        self.transactions = items
    }
    
    
    
    static var empty: TransactionsWrapper {
        return TransactionsWrapper(selectedCategory: nil, transactionsList: [])
    }
}

protocol TransactionListUseCaseType {
    func getTransactionsList(category: Int?) -> AnyPublisher<TransactionsWrapper, Error>
}

struct TransactionListUseCase: TransactionListUseCaseType {
    
    let gateway: TransactionGatewayType
    
    func getTransactionsList(category: Int?) -> AnyPublisher<TransactionsWrapper, Error> {
        gateway.getTransactionsList()
            .map {
                return TransactionsWrapper(selectedCategory: category, transactionsList: $0)
            }
            .eraseToAnyPublisher()
    }
}
