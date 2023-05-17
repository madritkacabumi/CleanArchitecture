//
//  ErrorView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import SwiftUI

struct ErrorView: View {
    
    // MARK: - Properties
    let message: String
    let onRetryButton: (() -> Void)
    
    // MARK: - Construct
    init(message: String, onRetryButton: @escaping (() -> Void)) {
        self.message = message
        self.onRetryButton = onRetryButton
    }
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .scaledToFit()
                .foregroundColor(AppColor.redColor)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppColor.bodyTextColor)
                .multilineTextAlignment(.center)
                .fontDesign(.serif)
            
            Button("key.button.retry".localized) {
                onRetryButton()
            }
            
        }.frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ErrorView_Previews: PreviewProvider {
    
    static var previews: some View {
        return ErrorView(message: "Ops... an error occurred, \n please retry again.", onRetryButton: {})
    }
}
