//
//  TransactionAssembler.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

protocol TransactionAssembler: Assembler {
    
    func resolve() -> TransactionGatewayType
    func resolve() -> TransactionListUseCaseType
    
    // MARK: - List
    func resolve(coordinator: TransactionCoordinator, networkMonitor: NetworkMonitorType) -> TransactionListViewModel
    func resolve(viewModel: TransactionListViewModel) -> TransactionListView
    
    // MARK: - Detail
    func resolve(transaction: Transaction) -> TransactionDetailViewModel
    func resolve(viewModel: TransactionDetailViewModel) -> TransactionDetailView
}

extension TransactionAssembler {
        
    // FIXME: - Here we could have a "switch" for either using the mock gateway or the real gateway to switch between working gateways
    func resolve() -> TransactionGatewayType {
        //        return TransactionGateway(networkService: resolve())
        return MockTransactionGateway(networkService: resolve())
    }
    
    func resolve() -> TransactionListUseCaseType {
        return TransactionListUseCase(gateway: resolve())
    }
    
    // MARK: - List
    func resolve(coordinator: TransactionCoordinator, networkMonitor: NetworkMonitorType) -> TransactionListViewModel {
        return TransactionListViewModel(coordinator: coordinator, transactionsUseCase: resolve(), networkMonitor: networkMonitor)
    }
    
    func resolve(viewModel: TransactionListViewModel) -> TransactionListView {
        return TransactionListView(viewModel: viewModel)
    }
    
    // MARK: - Detail
    
    func resolve(transaction: Transaction) -> TransactionDetailViewModel {
        return TransactionDetailViewModel(transaction: transaction)
    }
    
    func resolve(viewModel: TransactionDetailViewModel) -> TransactionDetailView {
        return TransactionDetailView(viewModel: viewModel)
    }
}

