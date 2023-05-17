//
//  TransactionItemView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import SwiftUI

struct TransactionItemView: View {
    
    // MARK: - Constant
    private static let leadingTrailingMargin = CGFloat(0)
    private static let separatorSpace = CGFloat(5)
    
    //MARK: - Properties
    let viewModel: TransactionItemViewModel
    
    //MARK: - Body
    var body: some View {
        
        HStack {
            
            VStack(spacing: Self.separatorSpace) {
                
                Text(viewModel.merchantDisplayName)
                    .foregroundColor(AppColor.titleTextColor)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.transactionDescription)
                    .font(.subheadline)
                    .foregroundColor(AppColor.bodyTextColor)
                    .fontDesign(.serif)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.transactionDate)
                    .font(.caption2)
                    .foregroundColor(AppColor.bodyTextColor)
                    .fontDesign(.monospaced)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(viewModel.formattedPrice)
                .font(.footnote)
                .foregroundColor(AppColor.priceColor)
                .bold()
                .frame(alignment: .trailing)
            
        }
    }
}

struct TransactionItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let product = TransactionItemViewModel(transaction: Transaction(merchantDisplayName: "Display Name", reference: "AABBCCDDEEFF123", categoryId: 1, transactionDetail: TransactionDetail(description: "Some description", transactionDate: Date(), amount: 10, currency: "$")))
        return TransactionItemView(viewModel: product)
    }
}



