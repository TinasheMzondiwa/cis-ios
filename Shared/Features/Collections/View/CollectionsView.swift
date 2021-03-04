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
    
    @State private var navTitle: String = "Collections"
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
                    .navigationTitle(navTitle)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            #if os(iOS)
                content
                    .navigationTitle(navTitle)
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
            #endif
            
        }
    }
    
    var content: some View {
        ZStack {
            if viewModel.emptyCollections {
                EmptyCollectionsView(caption: "Organise your Collection of Hymns here")
            } else {
                FilteredList(sortKey: "title") { (item: Collection) in
                    NavigationLink(
                        destination: CollectionHymnsView(collectionId: item.id!),
                        label: {
                            CollectionItemView(title: item.wrappedTitle, description: item.wrappedDescription, date: item.created, hymns: item.allHymns.count)
                        })
                }
            }
        }
        .onAppear {
            viewModel.subscribeToCollections()
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}