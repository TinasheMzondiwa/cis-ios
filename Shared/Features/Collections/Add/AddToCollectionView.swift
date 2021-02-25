//
//  AddToCollectionView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct AddToCollectionView: View {
    
    @State private var state: ViewState = .add
    
    @State private var collectionTitle: String = ""
    @State private var collectionAbout: String = ""
    
    private let viewModel = CollectionsViewModel()
    
    var onDismiss: () -> Void = {}
    
    var body: some View {
        NavigationView {
            ZStack {
                switch state {
                case .add: addContent
                case .create: createContent
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
                            viewModel.saveCollection(title: collectionTitle, about: collectionAbout)
                            state = .add
                            collectionTitle = ""
                            collectionAbout = ""
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
    
    private var addContent: some View {
        FilteredList(sortKey: "created") { (item: Collection) in
            Text(item.wrappedTitle)
                .lineLimit(1)
        }
    }
    
    private var createContent: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                FocusTextField(text: $collectionTitle, hint: "Title")
                FocusTextField(text: $collectionAbout, hint: "Description (Optional)")
            }
            .padding()
            
            Spacer()
        }
        .resignKeyboardOnDragGesture()
    }
}

struct AddToCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCollectionView()
    }
}
