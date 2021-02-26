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
        List(viewModel.collectionHymns, id: \.self) { item in
            NavigationLink(
                destination: HymnView(hymn: item),
                label: {
                    Text(item.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                })
        }
        .navigationTitle(viewModel.collectionTitle)
        .onAppear {
            viewModel.loadCollectionHymns(collectionId: collectionId)
        }
    }
}

struct CollectionHymnsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionHymnsView(collectionId: UUID())
    }
}
