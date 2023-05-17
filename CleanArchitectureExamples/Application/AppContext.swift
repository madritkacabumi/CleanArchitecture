//
//  AppContext.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation
import SwiftUI

protocol AppContextType: AnyObject, ObservableObject {
    
    var assembler: RootAssembler { get }
    var apiService: SampleNetworkServiceType { get }
    var networkMonitor: NetworkMonitorType { get }
    var coordinator: any Coordinator { get }
    func start()
}

final class AppContext: AppContextType {
    
    static var shared: (any AppContextType)! {
        didSet {
            if oldValue != nil {
                fatalError("AppContext Allready instatiated")
            }
        }
    }
    
    // MARK: - Properties
    let assembler: RootAssembler
    let apiService: SampleNetworkServiceType
    var networkMonitor: NetworkMonitorType
    var coordinator: any Coordinator
    
    // MARK: - Construct
    internal init(rootAssembler: RootAssembler) {
        self.assembler = rootAssembler
        self.apiService = SampleNetworkService()
        coordinator = assembler.resolve(assembler: assembler)
        networkMonitor = NetworkMonitor()
    }
    
    func start() {
        // start some libraries, services SDK or anything we would need in our cool app
        coordinator.start()
    }
}
