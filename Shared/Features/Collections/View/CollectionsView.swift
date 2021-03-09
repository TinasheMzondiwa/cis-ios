//
//  CollectionsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct CollectionsView: View {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @ObservedObject private var viewModel = CollectionsViewModel()
    @ObservedObject private var searchBar: SearchBar = SearchBar()
    
    @FetchRequest(
        entity: Collection.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Collection.title, ascending: true),
        ]
    ) var collections: FetchedResults<Collection>
    
    @State private var navTitle: String = "Collections"
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
                    .navigationTitle(navTitle)
                    .toolbar {
                        if !collections.isEmpty {
                            EditButton()
                        }
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            #if os(iOS)
                content
                    .navigationTitle(navTitle)
                    .toolbar {
                        if !collections.isEmpty {
                            EditButton()
                        }
                    }
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
            #endif
            
        }
    }
    
    var content: some View {
        ZStack {
            if collections.isEmpty {
                EmptyCollectionsView(caption: "Organise your Collection of Hymns here")
            } else {
                
                FilteredList(sortKey: "title", queryKey: "title", query: searchBar.text, canDelete: true) { (item: Collection) in
                    NavigationLink(
                        destination: CollectionHymnsView(collectionId: item.id!),
                        label: {
                            CollectionItemView(title: item.wrappedTitle, description: item.wrappedDescription, date: item.created, hymns: item.allHymns.count)
                        })
                }
                .add(self.searchBar)
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
