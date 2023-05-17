//
//  TransactionCoordinatorMock.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

@testable import CleanArchitectureExamples
import Foundation
import UIKit

class TransactionCoordinatorMock: TransactionCoordinatorType {

    let startCounter = TestCounter()
    let pushCounter = TestCounter()
    
    required init(assembler: RootAssembler) {
        // do nothing
    }
    
    func pushPage(_ page: TransactionCoordinatorPage, animated: Bool) {
        pushCounter.increment()
    }
    
    var rootViewController: UIViewController? = nil
    
    var childCoordinators: Array<any Coordinator> = []
    
    var parentCoordinator: (any Coordinator)? = nil
    
    func start() {
        startCounter.increment()
    }
    
    func showError(message: String, trigger: VoidTrigger) {
        
    }
    
    func showNoInternetConnection() {
        
    }

    
}

