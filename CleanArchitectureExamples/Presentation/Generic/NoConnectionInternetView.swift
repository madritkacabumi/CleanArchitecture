//
//  NoConnectionInternetView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import SwiftUI

struct NoConnectionInternetView: View {
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .scaledToFit()
                .foregroundColor(AppColor.redColor)
            
            Text("key.message.noInternetConnection".localized)
                .font(.subheadline)
                .foregroundColor(AppColor.bodyTextColor)
                .multilineTextAlignment(.center)
                .fontDesign(.serif)
        }.frame(maxWidth: .infinity, alignment: .center)
    }
}

struct NoConnectionInternetView_Previews: PreviewProvider {
    
    static var previews: some View {
        return NoConnectionInternetView()
    }
}
