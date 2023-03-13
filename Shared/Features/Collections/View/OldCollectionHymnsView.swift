//
//  CollectionHymnsView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct OldCollectionHymnsView: View {
    
    @ObservedObject private var viewModel = OldCollectionsViewModel()
    
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
                OldEmptyCollectionsView(caption: NSLocalizedString("Collection.Empty.Prompt", comment: "Empty prompt"))
            } else {
                List {
                    ForEach(viewModel.collectionHymns, id: \.self) { item in
                        NavigationLink(
                            destination: OldHymnView(hymn: item),
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
        OldCollectionHymnsView(collectionId: UUID())
    }
}
