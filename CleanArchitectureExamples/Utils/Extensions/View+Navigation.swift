//
//  View+Navigation.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import SwiftUI
extension View {
    func navigation<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }
    
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink(destination: isActive.wrappedValue ? destination() : nil, label: { EmptyView() })
    }
}

