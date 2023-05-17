//
//  TransactionSectionViewModel.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import Combine
import Foundation

struct TransactionSectionViewModel: Identifiable {
    
    let id = UUID().uuidString
    
    // MARK: - Properties
    let categories: [Int]
    var currentCategory: CurrentValueSubject<Int?, Never>
    let total: String
    
    //MARK: - Construct
    init(categories: [Int], currentCategorySubject: CurrentValueSubject<Int?, Never>, total: String) {
        self.categories = categories
        self.total = total
        self.currentCategory = currentCategorySubject
    }
    
    var isSectionVisible: Bool {
        return !categories.isEmpty
    }
    
    var categoriesValuesPicker: [String] {
        return categories.map { return String(format: "key.transactions.list.categoryName".localized, $0) }
    }
    
    var pickerCategories: [String] {
        var categoriesItem: [String] = ["key.transactions.list.selectCategory".localized]
        categoriesItem.append(contentsOf: categoriesValuesPicker)
        return categoriesItem
    }
    
    var selectedCategoryDescription: String {
        if let currentCategory = currentCategory.value {
            return String(format: "key.transactions.list.categoryName".localized, currentCategory)
        }
        return pickerCategories.first ?? ""
    }
    
    var totalAmountDescription: String {
        String(format: "key.transactions.list.totalString".localized, total)
    }
}
