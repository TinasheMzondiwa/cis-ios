//
//  AddCollectionView.swift
//  iOS
//
//  Created by George Nyakundi on 16/03/2023.
//

import SwiftUI

struct AddCollectionView: View {
    @EnvironmentObject var vm: CISAppViewModel
    @State var isAddingNewCollection: Bool = false
    @State private var collectionTitle: String = ""
    @State private var collectionAbout: String = ""
    @FocusState private var titleFocussed: Bool
    @FocusState private var aboutFocussed: Bool
    
    private var navTitle: String {
        if isAddingNewCollection {
            return NSLocalizedString("Collections.New", comment: "New prompt")
        } else {
            return NSLocalizedString("Collections.Add", comment: "Add prompt")
        }
    }
    
    private var navigationSymbol: SFSymbol {
        if isAddingNewCollection {
            return SFSymbol.arrowBackward
        } else {
            return SFSymbol.close
        }
    }
    
    private var actionTitle: String {
        if isAddingNewCollection {
            return NSLocalizedString("Common.Save", comment: "Save")
        } else {
            return NSLocalizedString("Common.New", comment: "New")
        }
    }
    
    private var trailingButtonIcon: SFSymbol {
        if isAddingNewCollection {
            return SFSymbol.checkmark
        } else {
            return SFSymbol.plus
        }
    }
    
    private func trailingButtonAction() {
        if isAddingNewCollection {
            
        } else {
            isAddingNewCollection.toggle()
        }
    }
    
    private func leadingButtonAction() {
        if isAddingNewCollection {
            isAddingNewCollection.toggle()
        } else {
            vm.toggleCollectionSheetVisibility()
        }
        
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.allCollections.isEmpty {
                    EmptyCollectionView(caption: NSLocalizedString("Collections.Organise.Prompt", comment: "Empty prompt"))
                } else {
                    ForEach(vm.allCollections, id: \.id) { collection in
                        NavigationLink(destination: Text("He"), label: {
                            CollectionItemView(item: collection)
                        })
                    }
                }
            }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        leadingButtonAction()
                    } label: {
                        navigationSymbol.navButtonStyle()
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        trailingButtonAction()
                    } label: {
                        trailingButtonIcon
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

