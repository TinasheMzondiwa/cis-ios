//
//  AddToCollectionView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct OldAddToCollectionView: View {
    @EnvironmentObject var vm: CISAppViewModel
    
    let hymn: StoreHymn
    
    @State private var state: ViewState = .add
    
    @State private var collectionTitle: String = ""
    @State private var collectionAbout: String = ""
    
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
                case .create: createContent
                case .add: addContent
                }
            }
            .navigationBarTitle(Text(state.title), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        withAnimation {
                            leadingButtonAction()
                        }
                    }, label: {
                        state.navigation
                            .navButtonStyle()
                    }),
                trailing:
                    Button(action: {
                        withAnimation {
                            trailingButtonAction()
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
        VStack {
            if vm.allCollections.isEmpty {
                OldEmptyCollectionsView(caption: NSLocalizedString("Collections.Empty.Prompt", comment: "Empty state"))
            } else {
                List {
                    ForEach(vm.allCollections, id: \.id) { collection in
                        let added = collection.hymns?.contains(hymn)
                        Button {
                            withAnimation {
                                vm.toggle(hymn: hymn, collection: collection)
                            }
                        } label: {
                            OldCollectionRowView(item: collection, selected: added)
                        }
                    }
                }
                .transition(.moveAndFade)
            }
        }
    }
    
    private var createContent: some View {
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

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

//struct OldAddToCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        OldAddToCollectionView(hymnId: UUID(), onDismiss: {})
//    }
//}
