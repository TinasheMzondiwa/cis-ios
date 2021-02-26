//
//  CollectionsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct CollectionsView: View {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
                    .navigationTitle("Collections")
            }
        } else {
            #if os(iOS)
                content
                    .navigationTitle("Collections")
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
            #endif
            
        }
    }
    
    var content: some View {
        FilteredList(sortKey: "title") { (item: Collection) in
           // let added = item.containsHymn(id: hymnId)
            NavigationLink(
                destination: CollectionHymnsView(collectionId: item.id!),
                label: {
                    CollectionItemView(title: item.wrappedTitle, description: item.wrappedDescription, date: item.created, hymns: item.allHymns.count)
                })
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}
