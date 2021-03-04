//
//  CollectionHymnsView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct CollectionHymnsView: View {
    
    @ObservedObject private var viewModel = CollectionsViewModel()
    
    let collectionId: UUID
    
    var body: some View {
        listContent
        .navigationTitle(viewModel.collectionTitle)
        .onAppear {
            viewModel.loadCollectionHymns(collectionId: collectionId)
        }
    }
    
    private var listContent: some View {
        VStack {
            if viewModel.collectionHymns.isEmpty {
                EmptyCollectionsView(caption: "Add hymns to your collection")
            } else {
                List(viewModel.collectionHymns, id: \.self) { item in
                    NavigationLink(
                        destination: HymnView(hymn: item),
                        label: {
                            Text(item.title)
                                .headLineStyle()
                                .lineLimit(1)
                        })
                }
            }
        }
    }
}

struct CollectionHymnsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionHymnsView(collectionId: UUID())
    }
}
