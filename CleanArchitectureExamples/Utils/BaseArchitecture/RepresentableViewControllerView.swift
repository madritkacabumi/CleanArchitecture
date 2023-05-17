//
//  RepresentableViewControllerView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import UIKit
import SwiftUI

struct RepresentableViewControllerView: UIViewControllerRepresentable {
    
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
}
