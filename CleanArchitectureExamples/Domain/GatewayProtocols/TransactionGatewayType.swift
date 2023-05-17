//
//  TransactionGatewayType.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

protocol TransactionGatewayType {
    func getTransactionsList() -> APIResponseObservable<[Transaction]>
}
