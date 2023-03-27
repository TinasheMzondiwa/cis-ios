//
//  CollectionHymnsView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct OldCollectionHymnsView: View {
    
    let collection: StoreCollection
    
    var body: some View {
        listContent
            .navigationBarTitle(collection.title, displayMode: .inline)
            .toolbar {
                if let hymns = collection.hymns, !hymns.isEmpty {
                    EditButton()
                }
            }
    }
    
    private var listContent: some View {
        VStack {
            if let collectionHymns = collection.hymns {
                List {
                    ForEach(collectionHymns, id: \.id) { hymn in
                        NavigationLink {
                            OldHymnView(displayedHymn: hymn)
                        } label: {
                            Text(hymn.title)
                                .headLineStyle()
                                .lineLimit(1)
                        }
                    }
                    // TODO: - onDelete
                    // .onDelete(perform: viewModel.removeHymnFromCollection)
                }
            } else {
                OldEmptyCollectionsView(caption: NSLocalizedString("Collection.Empty.Prompt", comment: "Empty prompt"))
            }
        }
    }
}

//struct OldCollectionHymnsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OldCollectionHymnsView(collectionId: UUID())
//    }
//}
