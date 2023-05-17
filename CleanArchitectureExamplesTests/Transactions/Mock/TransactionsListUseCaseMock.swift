//
//  TransactionsListUseCaseMock.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import Combine
@testable import CleanArchitectureExamples
import Foundation

struct TransactionsListUseCaseMock: TransactionListUseCaseType {
    let counter = TestCounter()
    
    var isFailure = false
    var countPress: Int = .zero
    
    let gateway: TransactionGatewayMock
    
    func getTransactionsList(category: Int?) -> AnyPublisher<TransactionsWrapper, Error> {
        counter.increment()
        if isFailure {
            return Fail<TransactionsWrapper, Error>(error: NSError.init(domain: "Some Error triggered", code: -12345)).eraseToAnyPublisher()
        } else {
            return gateway
                .getTransactionsList()
                .map { TransactionsWrapper(selectedCategory: nil, transactionsList: $0) } // we ignore the result as we test this elsewhere
                .eraseToAnyPublisher()
        }
    }
    
    func reset() {
        counter.reset()
    }
}
