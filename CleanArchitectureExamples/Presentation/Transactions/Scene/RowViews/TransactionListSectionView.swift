//
//  TransactionListSectionView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import SwiftUI
import Combine

class StateObjectWrapper: ObservableObject {
    
    var selectedCategory: Int?
    
    init(selectedCategory: Int?) {
        self.selectedCategory = selectedCategory
    }
    
    func updateSelectedCategory(category: Int?) {
        self.selectedCategory = category
        self.objectWillChange.send()
    }
}

struct TransactionListSectionView: View {
    
    // MARK: - Properties
    private var viewModel: TransactionSectionViewModel
    
    // MARK: - States
    @ObservedObject var selectedCategoryWrapper: StateObjectWrapper = StateObjectWrapper(selectedCategory: nil)
    
    // MARK: - Construct
    init(viewModel: TransactionSectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // Main Picker Body
            
            HStack(alignment: .center) {
                Text("key.transactions.list.category.label".localized)
                    .foregroundColor(AppColor.titleTextColor)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .bold()
                    .frame(alignment: .leading)
                
                VStack(spacing: .zero) {
                    
                    CustomPickerViewRepresentable(dataSet: viewModel.pickerCategories, text: self.viewModel.selectedCategoryDescription, onSelectedValue: { selectedValue in
                        
                        if let index = self.viewModel.categoriesValuesPicker.firstIndex(of: selectedValue) {
                            
                            self.selectedCategoryWrapper.updateSelectedCategory(category: viewModel.categories[index])
                            
                        } else {
                            
                            self.selectedCategoryWrapper.updateSelectedCategory(category: nil)
                        }
                        
                        self.viewModel.currentCategory.send(selectedCategoryWrapper.selectedCategory)
                    })
                    Divider()
                }
                
                Image(systemName: "chevron.down")
                    .frame(width: 10, height: 10)
                    .foregroundColor(AppColor.bodyTextColor)
                
            }.padding(EdgeInsets(top: 10, leading: .zero, bottom: 10, trailing: .zero))
            
            Text(viewModel.totalAmountDescription)
                .foregroundColor(AppColor.titleTextColor)
                .font(.callout)
                .fontDesign(.rounded)
                .bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct TransactionListSectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = TransactionSectionViewModel(categories: [1, 2, 3, 4, 5], currentCategorySubject: CurrentValueSubject(nil), total: "25 $")
        return TransactionListSectionView(viewModel: viewModel)
    }
}
