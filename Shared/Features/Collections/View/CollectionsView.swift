//
//  CollectionsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct CollectionsView: View {
    
    @State private var filterQuery: String = ""
    
    @EnvironmentObject var vm: CISAppViewModel
    
    private var filteredCollections: [StoreCollection] {
        if filterQuery.trimmed.isEmpty {
            return vm.allCollections
        } else {
            return vm.allCollections.filter {
                $0.title.localizedCaseInsensitiveContains(filterQuery) ||
                ($0.about ?? "" ).localizedCaseInsensitiveContains(filterQuery)
            }
        }
    }
    
    
    var body: some View {
#if os(iOS)
        NavigationStack {
            content
                .navigationTitle(LocalizedStringKey("Collections"))
                .toolbar {
                    if !filteredCollections.isEmpty {
                        EditButton()
                    }
                }
        }
#else
        content
            .frame(minWidth: 300, idealWidth: 500)
#endif
    }
    
    var content: some View {
        ZStack {
            if filteredCollections.isEmpty && filterQuery.isEmpty {
                EmptyCollectionsView(caption: NSLocalizedString("Collections.Organise.Prompt", comment: "Empty prompt"))
            } else {
                List {
                    ForEach(filteredCollections, id: \.id) { collection in
                        NavigationLink {
                            CollectionHymnsView(collection: collection)
                        } label: {
                            CollectionItemView(item: collection)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let id = filteredCollections[index].id
                            vm.removeCollection(with: id)
                        }
                    }
                }
                .searchable(text: $filterQuery)
                .onChange(of: filterQuery) { oldValue, newValue in
                    filterQuery = newValue
                }
                .resignKeyboardOnDragGesture()
            }
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}
