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
            .navigationTitle("Something")
            .navigationBarTitleDisplayMode(.inline)
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

