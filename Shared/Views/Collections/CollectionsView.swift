//
//  CollectionsView.swift
//  iOS
//
//  Created by George Nyakundi on 13/03/2023.
//

import SwiftUI

struct CollectionsView: View {
    // MARK: - Private
    private let navTitle: String = NSLocalizedString("Collections", comment: "Title")
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var filterQuery: String = ""
    
    
    @EnvironmentObject var vm: CISAppViewModel
    
    var filteredCollections: [StoreCollection] {
        if filterQuery.trimmed.isEmpty {
            return vm.allCollections
        } else {
            return vm.allCollections.filter { $0.title.localizedCaseInsensitiveContains(filterQuery) || (($0.about?.localizedCaseInsensitiveContains(filterQuery)) != nil)}
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredCollections.isEmpty {
                    EmptyCollectionView(caption: NSLocalizedString("Collections.Organise.Prompt", comment: "Empty prompt"))
                } else {
                    List {
                        ForEach(filteredCollections, id: \.id) { collection in
                            NavigationLink(destination: CollectionHymnsView(collection: collection), label: {
                                CollectionItemView(item: collection)
                            })
                        }
                        .onDelete { indexSet in
                            print("Deleting \(indexSet)")
                        }
                    }
                }
            }.navigationTitle(navTitle)
                .searchable(text: $filterQuery)
                .resignKeyboardOnDragGesture()
                .toolbar {
                    if !filteredCollections.isEmpty {
                        EditButton()
                    }
                }
        }
    }
    
    // MARK: - Private Views
    private var content: some View {
        NavigationView {
            ZStack {
                if filteredCollections.isEmpty {
                    EmptyCollectionView(caption: NSLocalizedString("Collections.Organise.Prompt", comment: "Empty prompt"))
                } else {
                    List {
                        ForEach(filteredCollections, id: \.id) { collection in
                            NavigationLink(destination: Text("He"), label: {
                                CollectionItemView(item: collection)
                            })
                        }
                    }
                }
            }
        }
        
    }
}

struct CollectionItemView: View {
    let item: StoreCollection
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.title)
                        .headLineStyle()
                        .lineLimit(1)
                }
                if let about = item.about {
                    Text(about)
                        .subHeadLineStyle()
                }
            }
            .padding([.top, .bottom], 8)
        }
        Spacer()
        Text(String(item.hymns?.count ?? 0))
            .subHeadLineStyle()
    }
}

struct EmptyCollectionView: View {
    let caption: String
    
    var body: some View {
        VStack {
            Image("EmptyCollections")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(caption)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding([.bottom], 200)
            
        }
        .padding()
    }
}
