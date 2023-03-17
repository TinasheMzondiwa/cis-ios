//
//  CollectionsHymnsView.swift
//  iOS
//
//  Created by George Nyakundi on 17/03/2023.
//

import SwiftUI

struct CollectionHymnsView: View {
    let collection: StoreCollection
    var body: some View {
        VStack {
            if let hymns = collection.hymns, !hymns.isEmpty {
                List(hymns) { hymn in
                    /*@START_MENU_TOKEN@*/Text(hymn.title)/*@END_MENU_TOKEN@*/
                }
            } else {
                EmptyCollectionView(caption: NSLocalizedString("Collection.Empty.Prompt", comment: "Empty prompt"))
            }
        }.navigationTitle(collection.title)
            .navigationBarTitleDisplayMode(.inline)
        
        
    }
}
