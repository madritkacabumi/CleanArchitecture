//
//  TransactionGateway.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine

struct TransactionGateway: TransactionGatewayType {
    
    let networkService: SampleNetworkServiceType
    
    func getTransactionsList() -> APIResponseObservable<[Transaction]> {
        let resource = TransactionListResource()
        return networkService
            .performRequest(with: resource)
            .eraseToAnyPublisher()
    }
}
