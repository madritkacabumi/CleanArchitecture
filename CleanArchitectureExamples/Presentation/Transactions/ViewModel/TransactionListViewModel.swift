//
//  TransactionListViewModel.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine
import Foundation
import SwiftUI

struct TransactionSection: Identifiable {
    let id: String = UUID().uuidString
    let sectionType: TransactionsSectionType
    let transactionsViewModels: [TransactionItemViewModel]
    let transactionSectionViewModel: TransactionSectionViewModel
}

enum TransactionsSectionType {
    case apiTransactions
}

struct TransactionListViewModel: ViewModel {
    
    // MARK: - Properties
    unowned let coordinator: any TransactionCoordinatorType
    let transactionsUseCase: TransactionListUseCaseType
    let networkMonitor: NetworkMonitorType
    
    // MARK: - Construct
    init(coordinator: any TransactionCoordinatorType, transactionsUseCase: TransactionListUseCaseType, networkMonitor: NetworkMonitorType) {
        self.coordinator = coordinator
        self.transactionsUseCase = transactionsUseCase
        self.networkMonitor = networkMonitor
    }
    
    // MARK: - I/O
    struct Input {
        let initialTrigger: VoidTrigger
    }
    
    class Output: ObservableObject {
        @Published var sections: [TransactionSection] = []
        @Published var isLoading: Bool = true
        @Published var alert = AlertErrorMessage()
        fileprivate var selectedCategory: Int? = nil
        fileprivate var transactionWrapper: TransactionsWrapper?
    }
    
    // MARK: - Transform
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let selectedCategorySubject: CurrentValueSubject<Int?, Never> = CurrentValueSubject(nil)
        
        Publishers.CombineLatest(input.initialTrigger, networkMonitor.isConnected.removeDuplicates())
            .receive(on: DispatchQueue.main)
            .flatMap {(_, connected) -> AnyPublisher<TransactionsWrapper, Never> in
                
            output.alert = AlertErrorMessage() // clear error
            output.isLoading = true
            
                guard connected else {
                    return Just(.empty)
                        .eraseToAnyPublisher()
                }
                
            return self.transactionsUseCase
                .getTransactionsList(category: output.selectedCategory)
                .handleValue(callback: { data in
                    output.transactionWrapper = data
                })
                .receive(on: DispatchQueue.main)
                .handleError(callback: { error in
                    // Here or elsewhere we can detect the error type or use a general error handling for the entire app. We will limit in just an hardcoded error message
                    output.alert = AlertErrorMessage(message: "key.message.genericErrorMessage".localized, isShowing: true)
                    output.isLoading = false
                })
                .catch({ failure in
                    return Just(TransactionsWrapper.empty)
                })
                .eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .handleValue { data in
            let totalAmount = data.transactions.map { $0.transactionDetail.amount }.reduce(.zero, +)
            
            // Assume currency is always $
            let totalPrice = PriceFormatter.convertPrice(amount: NSNumber(value: totalAmount), currencyCode: "key.currency.dollar".localized)
            
            let transactionSectionViewModel = TransactionSectionViewModel(categories: data.categories,
                                                                          currentCategorySubject: selectedCategorySubject,
                                                                          total: totalPrice)
            let transactionsViewModels = data.transactions.map { TransactionItemViewModel(transaction: $0) }
            
            output.sections = [
                TransactionSection(sectionType: .apiTransactions,
                                   transactionsViewModels: transactionsViewModels,
                                   transactionSectionViewModel: transactionSectionViewModel)
            ]
            output.isLoading = false
            
        }
        .sink()
        .store(in: disposeBag)
        
        selectedCategorySubject
            .dropFirst()
            .sink { selectedCategory in
                output.selectedCategory = selectedCategory
                input.initialTrigger.fire()
            }.store(in: disposeBag)
        
        return output
    }
    
    // MARK: - Nvigation
    func openDetail(transactionItemViewModel: TransactionItemViewModel) {
        coordinator.pushPage(.transactionDetail(transaction: transactionItemViewModel._transaction), animated: true)
    }
    
    func showError(message: String, trigger: VoidTrigger) {
        self.coordinator.showError(message: message, trigger: trigger)
    }
}

