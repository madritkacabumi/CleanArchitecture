//
//  TransactionGatewayMock.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

@testable import CleanArchitectureExamples
import Combine

struct TransactionGatewayMock: TransactionGatewayType {
    
    let counter = TestCounter()
    
    func getTransactionsList() -> APIResponseObservable<[Transaction]> {
        counter.increment()
        let transactionsContainer = MockProvider.transactionListProvider!
        return Future<[Transaction], Error> { promise in
            promise(.success(transactionsContainer))
        }.eraseToAnyPublisher()
    }
    
    func reset() {
        counter.reset()
    }
}
