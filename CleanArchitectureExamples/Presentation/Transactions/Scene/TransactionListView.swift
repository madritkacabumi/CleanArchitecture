//
//  TransactionListView.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import SwiftUI
import Combine

struct TransactionListView: View {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private let viewModel: TransactionListViewModel
    @ObservedObject var output: TransactionListViewModel.Output
    
    // MARK: Triggers
    private let loadTrigger = VoidTrigger()
    
    // MARK: - Construct
    init(viewModel: TransactionListViewModel) {
        self.viewModel = viewModel
        let input = TransactionListViewModel.Input(initialTrigger: loadTrigger)
        self.output = viewModel.transform(input, disposeBag: disposeBag)
        loadTrigger.fire()
        setupSubscriptions()
    }
    
    // MARK: - Subscription
    private func setupSubscriptions() {
        output.$alert.filter { $0.isShowing }
            .sink { alert in
                viewModel.showError(message: alert.message, trigger: loadTrigger)
            }.store(in: disposeBag)
    }
    
    //MARK: - Body
    var body: some View {
        
        if output.sections.isEmpty && output.isLoading {
            
            ActivityIndicatorRepresentable(style: .large)
                .frame(maxWidth: .infinity, alignment: .center)
            
        } else {
            
            List {
                
                ForEach(output.sections) { section in
                    
                    switch section.sectionType {
                        case .apiTransactions:
                            
                            Section {
                                
                                if section.transactionSectionViewModel.isSectionVisible {
                                    TransactionListSectionView(viewModel: section.transactionSectionViewModel)
                                }
                                if output.isLoading {
                                    
                                    ActivityIndicatorRepresentable(style: .large)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                } else {
                                    
                                    ForEach(section.transactionsViewModels) { transactionViewModel in
                                        Button {
                                            viewModel.openDetail(transactionItemViewModel: transactionViewModel)
                                        } label: {
                                            TransactionItemView(viewModel: transactionViewModel)
                                        }
                                    }
                                }
                            }
                    }
                }
            }.listStyle(.insetGrouped)
                .navigationTitle("key.transactions.list.navBarTitle")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
