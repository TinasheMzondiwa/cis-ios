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
            .navigationBarTitle(viewModel.collectionTitle, displayMode: .inline)
            .toolbar {
                if !viewModel.collectionHymns.isEmpty {
                    EditButton()
                }
            }
        .onAppear {
            viewModel.loadCollectionHymns(collectionId: collectionId)
        }
    }
    
    private var listContent: some View {
        VStack {
            if viewModel.collectionHymns.isEmpty {
                EmptyCollectionsView(caption: NSLocalizedString("Collection.Empty.Prompt", comment: "Empty prompt"))
            } else {
                List {
                    ForEach(viewModel.collectionHymns, id: \.self) { item in
                        NavigationLink(
                            destination: HymnView(hymn: item),
                            label: {
                                Text(item.title)
                                    .headLineStyle()
                                    .lineLimit(1)
                            })
                    }
                    .onDelete(perform: viewModel.removeHymnFromCollection)
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
