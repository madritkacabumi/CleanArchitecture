//
//  RootAssembler.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

// Assemble all the pieces
protocol Assembler {
    
    // Application Resolver
    func resolve() -> any AppContextType
    func resolve() -> SampleNetworkServiceType
}

extension Assembler {
    
    func resolve() -> any AppContextType {
        return AppContext.shared
    }
    
    func resolve() -> SampleNetworkServiceType {
        return AppContext.shared.apiService
    }
}

protocol RootAssembler: TransactionAssembler {
    func resolve(assembler: RootAssembler) -> any TransactionCoordinatorType
    
    func resolve() -> NoConnectionInternetView
    
    func resolve(message: String, onRetryButton: @escaping (() -> Void)) -> ErrorView
}

extension RootAssembler {
    
    func resolve(assembler: RootAssembler) -> any TransactionCoordinatorType {
        return TransactionCoordinator(assembler: self)
    }
    
    func resolve() -> NoConnectionInternetView {
        return NoConnectionInternetView()
    }
    
    func resolve(message: String, onRetryButton: @escaping (() -> Void)) -> ErrorView {
        return ErrorView(message: message, onRetryButton: onRetryButton)
    }
}

final class DefaultRootAssembler: RootAssembler {

    
    // do nothing
}
