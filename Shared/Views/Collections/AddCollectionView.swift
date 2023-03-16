//
//  AddCollectionView.swift
//  iOS
//
//  Created by George Nyakundi on 16/03/2023.
//

import SwiftUI

struct AddCollectionView: View {
    @EnvironmentObject var vm: CISAppViewModel
    
    @State private var state: ViewState = .add
    
    @State private var collectionTitle: String = ""
    @State private var collectionAbout: String = ""
    @FocusState private var titleFocussed: Bool
    @FocusState private var aboutFocussed: Bool
    
    private func leadingButtonAction() {
        switch state {
        case .add:
            vm.toggleCollectionSheetVisibility()
        case .create:
            state = .add
        }
    }
    
    private func clearForm() {
        collectionTitle = ""
        collectionAbout = ""
        state = .add
    }
    
    private func trailingButtonAction() {
        switch state {
        case .add:
            state = .create
        case .create:
            if !collectionTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                vm.addCollection(with: collectionTitle, and: collectionAbout)
                clearForm()
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                switch state {
                case .create:
                    createCollection
                default:
                    VStack {
                        if vm.allCollections.isEmpty {
                            EmptyCollectionView(caption: NSLocalizedString("Collections.Organise.Prompt", comment: "Empty prompt"))
                        } else {
                            List {
                                ForEach(vm.allCollections, id: \.id) { collection in
                                        CollectionItemView(item: collection)
                                    
                                }
                            }
                            
                        }
                    }
                    .transition(.moveAndFade)
                }
            }
            .navigationTitle(Text(state.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            leadingButtonAction()
                        }
                    } label: {
                        state.navigation
                            .navButtonStyle()
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            trailingButtonAction()
                        }
                    } label: {
                        Label(
                            title: { Text(state.actionTitle) },
                            icon: { state.actionIcon }
                        )
                    }
                }
            }
        }
    }
    
    private var createCollection: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                FocusTextField(text: $collectionTitle, hint: NSLocalizedString("Common.Title", comment: "hint"))
                FocusTextField(text: $collectionAbout, hint: NSLocalizedString("Collection.Description", comment: "hint"))
            }
            .padding()
            
            Spacer()
        }
        .resignKeyboardOnDragGesture()
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
    }
    
}

