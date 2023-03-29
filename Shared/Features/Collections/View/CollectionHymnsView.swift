//
//  CollectionHymnsView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct CollectionHymnsView: View {
    
    let collection: StoreCollection
    @EnvironmentObject var vm: CISAppViewModel
    
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
            if let collectionHymns = collection.hymns, collectionHymns.count != 0 {
                List {
                    ForEach(collectionHymns, id: \.id) { hymn in
                        NavigationLink {
                            HymnView(displayedHymn: hymn)
                        } label: {
                            Text(hymn.title)
                                .headLineStyle()
                                .lineLimit(1)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let id = collectionHymns[index].id
                            vm.removeHymn(with: id, fromCollectionId: collection.id)
                        }
                    }
                }
            } else {
                EmptyCollectionsView(caption: NSLocalizedString("Collection.Empty.Prompt", comment: "Empty prompt"))
            }
        }
    }
}

//struct OldCollectionHymnsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OldCollectionHymnsView(collectionId: UUID())
//    }
//}
