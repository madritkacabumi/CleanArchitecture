//
//  TransactionsViewModelTests.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

@testable import CleanArchitectureExamples
import XCTest
import Combine

final class TransactionsViewModelTests: XCTestCase {
    
    private var coordinator: TransactionCoordinatorMock!
    private var viewModel: TransactionListViewModel!
    private var gateway: TransactionGatewayMock!
    private var useCase: TransactionsListUseCaseMock!
    let networkMonitorMock = NetworkMonitorMock()
    
    private var input: TransactionListViewModel.Input!
    private var output: TransactionListViewModel.Output!
    private var loadTrigger = VoidTrigger()
    
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        gateway = TransactionGatewayMock()
        useCase = TransactionsListUseCaseMock(gateway: gateway)
        coordinator = TransactionCoordinatorMock(assembler: DefaultRootAssembler())
        coordinator.start()
        self.input = .init(initialTrigger: loadTrigger)
    }
    
    func test_Counters() {
        viewModel = TransactionListViewModel(coordinator: coordinator, transactionsUseCase: useCase, networkMonitor: networkMonitorMock)
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
        do {
            _ = try triggeredPublisher(self.output.$sections.dropFirst(), expectValue: true, trigger: { [weak self] in
                self?.loadTrigger.fire()
            })
            XCTAssertTrue(useCase.counter.count == 1)
            XCTAssertTrue(gateway.counter.count == 1)
            XCTAssertTrue(coordinator.startCounter.count == 1)
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
    
    func test_SectionsCreatePublisher() {
        useCase.isFailure = false
        viewModel = TransactionListViewModel(coordinator: coordinator, transactionsUseCase: useCase, networkMonitor: networkMonitorMock)
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
        do {
            let sections = try awaitPublisher(self.output.$sections.dropFirst(), expectValue: true, trigger: { [weak self] in
                self?.loadTrigger.fire()
            })
            XCTAssertFalse(sections.isEmpty)
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
    
    func test_ErrorPublisher() {
        useCase.isFailure = true
        viewModel = TransactionListViewModel(coordinator: coordinator, transactionsUseCase: useCase, networkMonitor: networkMonitorMock)
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
        do {
            let alert = try awaitPublisher(self.output.$alert.filter { $0.isShowing }, expectValue: true, trigger: { [weak self] in
                self?.loadTrigger.fire()
            })
            XCTAssertTrue(alert.isShowing)
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
    
    func test_Loading() {
        useCase.isFailure = false
        viewModel = TransactionListViewModel(coordinator: coordinator, transactionsUseCase: useCase, networkMonitor: networkMonitorMock)
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
        do {
            let isLoading = try awaitPublisher(self.output.$isLoading.dropFirst(), expectValue: true, trigger: { [weak self] in
                self?.networkMonitorMock.isConnected.send(true)
                self?.loadTrigger.fire()
            })
            XCTAssertTrue(isLoading)
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
}
