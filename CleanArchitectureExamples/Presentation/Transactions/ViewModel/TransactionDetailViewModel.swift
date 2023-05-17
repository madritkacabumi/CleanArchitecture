//
//  TransactionDetailViewModel.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import Foundation

struct TransactionDetailViewModel: ViewModel {
    
    let id = UUID().uuidString
    
    // MARK: - I/O
    struct Input {
        let initialTrigger: VoidTrigger
    }
    
    class Output: ObservableObject {
        var transactionDate: String = ""
        var merchantDisplayName: String = ""
        var transactionDescription: String = ""
        var formattedPrice: String = ""
        var reference: String = ""
        var category: String = ""
        @Published var loaded: Bool = false
    }
    
    // MARK: - Properties
    private var transaction: Transaction
    
    //MARK: - Construct
    init(transaction: Transaction){
        self.transaction = transaction
    }
    
    // MARK: - Binding
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        input.initialTrigger.handleValue { _ in
            
            output.transactionDate = CustomDateFormatter.dateToString(date: transaction.transactionDetail.transactionDate, formatOptions:
                                                                [.withSpaceBetweenDateAndTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTime, .withFullDate])
            output.merchantDisplayName = transaction.merchantDisplayName
            output.transactionDescription = transaction.transactionDetail.description
            let amount = NSNumber(value: transaction.transactionDetail.amount)
            output.formattedPrice = PriceFormatter.convertPrice(amount: amount, currencyCode: transaction.transactionDetail.currency)
            output.reference = transaction.reference
            output.category = String(format: "key.transactions.list.categoryName".localized, transaction.categoryId)
            output.loaded = true
            
        }.sink()
        .store(in: disposeBag)
        
        return output
    }
}

