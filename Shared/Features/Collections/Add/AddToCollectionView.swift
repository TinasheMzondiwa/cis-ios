//
//  AddToCollectionView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct AddToCollectionView: View {
    
    @State private var state: ViewState = .add
    
    var onDismiss: () -> Void = {}
    
    var body: some View {
        NavigationView {
            ZStack {
                switch state {
                case .add: Text("Show List")
                case .create: Text("Show Two Input fields")
                }
            }
            .navigationBarTitle(Text(state.title))
            .navigationBarItems(
                leading:
                    Button(action: {
                        switch state {
                        case .add: onDismiss()
                        case .create: state = .add
                        }
                    }, label: {
                        state.navigation
                    }),
                trailing:
                    Button(action: {
                        switch state {
                        case .add: state = .create
                        case .create:
                            // save new collection
                            state = .add
                        }
                    }, label: {
                        Label(
                            title: { Text(state.actionTitle) },
                            icon: { state.actionIcon }
                        )
                    })
            )
        }
    }
}

struct AddToCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCollectionView()
    }
}
