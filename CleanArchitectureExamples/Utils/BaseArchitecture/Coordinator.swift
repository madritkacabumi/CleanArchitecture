//
//  Coordinator.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import UIKit

public protocol Coordinator: AnyObject {
    
    associatedtype ChildCoordinator
    var rootViewController: UIViewController? { get }
    var childCoordinators: ChildCoordinator { get set }
    var parentCoordinator: (any Coordinator)? { get }
    
    func start()
}
