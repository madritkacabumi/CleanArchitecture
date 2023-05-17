//
//  ActivityIndicator.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import SwiftUI
import UIKit

struct ActivityIndicatorRepresentable: UIViewRepresentable {
    
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorRepresentable>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorRepresentable>) {
        uiView.startAnimating()
    }
}
