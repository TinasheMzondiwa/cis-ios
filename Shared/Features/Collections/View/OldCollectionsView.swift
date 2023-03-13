//
//  CollectionsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct OldCollectionsView: View {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @ObservedObject private var viewModel = OldCollectionsViewModel()
    @State private var searchQuery: String = ""
    
    @FetchRequest(
        entity: Collection.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Collection.title, ascending: true),
        ]
    ) var collections: FetchedResults<Collection>
    
    @State private var navTitle: String = NSLocalizedString("Collections", comment: "Title")
    
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
                OldEmptyCollectionsView(caption: NSLocalizedString("Collections.Organise.Prompt", comment: "Empty prompt"))
            } else {
                
                FilteredList(sortKey: "title", queryKey: "title", query: searchQuery, canDelete: true) { (item: Collection) in
                    NavigationLink(
                        destination: OldCollectionHymnsView(collectionId: item.id!),
                        label: {
                            OldCollectionItemView(title: item.wrappedTitle, description: item.wrappedDescription, date: item.created, hymns: item.allHymns.count)
                        })
                }
                .searchable(text: $searchQuery)
                .onChange(of: searchQuery) { query in
                    searchQuery = query
                }
                .resignKeyboardOnDragGesture()
            }
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        OldCollectionsView()
    }
}
