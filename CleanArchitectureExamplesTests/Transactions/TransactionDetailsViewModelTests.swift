//
//  TransactionDetailsViewModelTests.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

@testable import CleanArchitectureExamples
import XCTest
import Combine

final class TransactionDetailsViewModelTests: XCTestCase {
    
    private var viewModel: TransactionDetailViewModel!
    
    private var input: TransactionDetailViewModel.Input!
    private var output: TransactionDetailViewModel.Output!
    private var loadTrigger = VoidTrigger()
    
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        self.input = .init(initialTrigger: loadTrigger)
        viewModel = TransactionDetailViewModel(transaction: MockProvider.transactionListProvider!.first!)
    }
    
    func test_Output() {
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
        do {
            _ = try awaitPublisher(self.output.$loaded.dropFirst(), trigger: { [weak self] in
                self?.loadTrigger.fire()
            })
            XCTAssertFalse(output.category.isEmpty)
            XCTAssertFalse(output.merchantDisplayName.isEmpty)
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
}
