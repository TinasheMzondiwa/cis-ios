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
    
    @ObservedObject private var viewModel = CollectionsViewModel()
    
    let hymnId: UUID
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                switch state {
                case .add: addContent
                case .create: createContent
                }
            }
            .navigationBarTitle(Text(state.title), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        withAnimation {
                            switch state {
                            case .add: onDismiss()
                            case .create: state = .add
                            }
                        }
                    }, label: {
                        state.navigation
                            .navButtonStyle()
                    }),
                trailing:
                    Button(action: {
                        withAnimation {
                            switch state {
                            case .add: state = .create
                            case .create:
                                viewModel.saveCollection(title: collectionTitle, about: collectionAbout)
                                state = .add
                                collectionTitle = ""
                                collectionAbout = ""
                            }
                        }
                    }, label: {
                        Label(
                            title: { Text(state.actionTitle) },
                            icon: { state.actionIcon }
                        )
                    })
            )
        }
        .onAppear {
            viewModel.subscribeToCollections()
        }
    }
    
    private var addContent: some View {
        VStack {
            if viewModel.emptyCollections {
                EmptyCollectionsView(caption: "Create your first Hymn collection")
            } else {
                FilteredList(sortKey: "title") { (item: Collection) in
                    let added = item.containsHymn(id: hymnId)
                    Button(action: {
                        withAnimation {
                            viewModel.toggleCollection(hymnId: hymnId, collection: item)
                        }
                    }, label: {
                        CollectionRowView(title: item.wrappedTitle, description: item.wrappedDescription, selected: added)
                    })
                }
                .transition(.moveAndFade)
            }
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
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct AddToCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCollectionView(hymnId: UUID(), onDismiss: {})
    }
}
