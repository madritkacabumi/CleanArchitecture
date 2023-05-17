//
//  TransactionCoordinator.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation
import SwiftUI

enum TransactionCoordinatorPage {
    case transactionList
    case transactionDetail(transaction: Transaction)
    case noInternetConnection
}

protocol TransactionCoordinatorType: Coordinator where ChildCoordinator == Array<any Coordinator> {
    
    init(assembler: RootAssembler)
    func pushPage(_ page: TransactionCoordinatorPage, animated: Bool)
    func showError(message: String, trigger: VoidTrigger)
    func showNoInternetConnection()
}

class TransactionCoordinator: TransactionCoordinatorType {
    
    //MARK: - Properties
    private let assembler: RootAssembler
    private var networkMonitor: NetworkMonitorType { AppContext.shared.networkMonitor }
    private let disposeBag = DisposeBag()
    private var _navigationController: UINavigationController!
    
    // Coordinator
    var rootViewController: UIViewController? { return _navigationController }
    var childCoordinators: Array<any Coordinator> = []
    var parentCoordinator: (any Coordinator)?

    // MARK: - Construct
    required init(assembler: RootAssembler) {
        self.assembler = assembler
    }
    
    // MARK: - Start
    func start() {
        
        // create navigation controller with root view controller
        let navigationController = UINavigationController(rootViewController: viewController(for: buildView(page: .transactionList)))
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false // a crash occurs
        navigationController.navigationBar.tintColor = AppColor.titleTextColor.uiColor;
        self._navigationController = navigationController
        networkMonitorSubscription()
    }
    
    // MARK: - Subscriptions
    private func networkMonitorSubscription() {
        networkMonitor
            .isConnected
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                print(connected)
            if connected {
                self?.rootViewController?.presentedViewController?.dismiss(animated: true)
            } else {
                self?.showNoInternetConnection()
            }
        }.store(in: disposeBag)
    }
    
    // MARK: - Page
    @ViewBuilder
    func buildView(page: TransactionCoordinatorPage) -> some View {
        switch page {
            case .transactionList:
                assembler.resolve(viewModel: assembler.resolve(coordinator: self, networkMonitor: self.networkMonitor)) as TransactionListView
            case .transactionDetail(let transaction):
                assembler.resolve(viewModel: assembler.resolve(transaction: transaction)) as TransactionDetailView
            case .noInternetConnection:
                assembler.resolve() as NoConnectionInternetView
        }
    }
    
    // MARK: - Navigation
    func pushPage(_ page: TransactionCoordinatorPage, animated: Bool) {
        let hostingViewController = viewController(for: buildView(page: page))
        hostingViewController.navigationItem.largeTitleDisplayMode = .never
        self._navigationController.pushViewController(hostingViewController, animated: true)
    }
    
    func showError(message: String, trigger: VoidTrigger) {
        let errorView = assembler.resolve(message: message) { [weak self] in
            self?._navigationController.dismiss(animated: true, completion: {
                trigger.fire()
            })
        }
        
        let hostingViewController = viewController(for: errorView)
        hostingViewController.modalPresentationStyle = .fullScreen
        hostingViewController.modalTransitionStyle = .crossDissolve
        self._navigationController.present(hostingViewController, animated: true)
    }
    
    func showNoInternetConnection() {
        let noInternetConnectionViewController = viewController(for: buildView(page: .noInternetConnection))
        noInternetConnectionViewController.modalPresentationStyle = .fullScreen
        noInternetConnectionViewController.modalTransitionStyle = .crossDissolve
        
        if let presentedViewController = self.rootViewController?.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: {
                self._navigationController.present(noInternetConnectionViewController, animated: true)
            }) // dismiss any existing presented view controller
            
        } else {
            self._navigationController.present(noInternetConnectionViewController, animated: true)
        }
    }
    
    // MARK: - Utils
    private func viewController<Content: View>(for view: Content) -> UIHostingController<Content> {
        return UIHostingController(rootView: view)
    }
}
