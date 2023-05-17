//
//  TransactionDetailView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import SwiftUI
import Combine

struct TransactionDetailView: View {
    
    // MARK: - Constant
    private static let leadingTrailingMargin = CGFloat(20)
    private static let separatorSpace = CGFloat(5)
    
    //MARK: - Properties
    let viewModel: TransactionDetailViewModel
    let disposeBag = DisposeBag()
    @ObservedObject var output: TransactionDetailViewModel.Output
    
    // MARK: Triggers
    private let loadTrigger = PassthroughSubject<Void, Never>()
    
    init(viewModel: TransactionDetailViewModel) {
        self.viewModel = viewModel
        let input = TransactionDetailViewModel.Input(initialTrigger: loadTrigger)
        self.output = viewModel.transform(input, disposeBag: disposeBag)
        loadTrigger.fire()
    }
    
    //MARK: - Body
    var body: some View {
        
        ZStack(alignment: .top) {
            
            AppColor.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    
                    VStack(spacing: Self.separatorSpace) {
                        
                        container(label: "key.transactions.detail.label.partnerName".localized, value: output.merchantDisplayName, valueFont: .title2)
                        
                        container(label: "key.transactions.detail.label.reference".localized, value: output.reference, valueFont: .body)
                        
                        container(label: "key.transactions.detail.label.amount".localized, value: output.formattedPrice, valueFont: .title3)
                        
                        container(label: "key.transactions.detail.label.category".localized, value: output.category, valueFont: .body)
                        
                        container(label: "key.transactions.detail.label.description".localized, value: output.transactionDescription, valueFont: .body)
                        
                        container(label: "key.transactions.detail.label.transactionDate".localized, value: output.transactionDate, valueFont: .caption, bottomDivider: false)
                    }
                }
                .padding(10)
                .cornerRadius(15)
                .background(ContainerRelativeShape()
                    .fill(Color.white)
                    .cornerRadius(10))
                
            }.padding(EdgeInsets(top: .zero, leading: Self.leadingTrailingMargin, bottom: .zero, trailing: Self.leadingTrailingMargin))
        }.navigationTitle(output.merchantDisplayName)
    }
    
    
    /// Will generate A Row view for each of the fields needed to be shown in the detail
    /// - Parameters:
    ///   - label: top label
    ///   - value: value
    ///   - valueFont: font
    ///   - bottomDivider: divider if needed
    /// - Returns: row container view
    func container(label: String, value: String, valueFont: Font, bottomDivider: Bool = true) -> some View {
        
        VStack(spacing: 5) {
        
            Text(label)
                .foregroundColor(AppColor.bodyTextColor)
                .font(.caption)
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .foregroundColor(AppColor.titleTextColor)
                .font(valueFont)
                .fontDesign(.rounded)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            if bottomDivider {
                Divider()
            }
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        
        return TransactionDetailView(viewModel: TransactionDetailViewModel(transaction: Transaction(merchantDisplayName: "Display Name", reference: "AABBCCDDEEFF123", categoryId: 1, transactionDetail: TransactionDetail(description: "Some description", transactionDate: Date(), amount: 10, currency: "$"))))
    }
}



