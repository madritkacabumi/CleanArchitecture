//
//  MockTransactionGateway.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine
import Foundation
struct MockTransactionGateway: TransactionGatewayType {
    
    let networkService: SampleNetworkServiceType
    
    func getTransactionsList() -> APIResponseObservable<[Transaction]> {
        
//        let randomError = Bool.random()
//        guard !randomError else {
//            return Fail(error: NSError(domain: "Some Random error", code: -10001, userInfo: nil))
//                .eraseToAnyPublisher()
//        }
        return networkService
            .loadMock(with: "SampleTransactions")
            .eraseToAnyPublisher()
    }
}
