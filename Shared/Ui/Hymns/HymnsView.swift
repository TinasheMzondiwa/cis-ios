//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
    @State private var isShowingHymnals = false
    @State private var searchText = ""
    
    private var hymns = hymnalData.hymns
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                ScrollView {
                    VStack {
                        NavigationLink(
                            destination: HymnalsView(),
                            isActive: $isShowingHymnals,
                            label: { EmptyView() })
                        
                        SearchBar(text: $searchText)
                            .padding(.top, 10)
                        
                        List(hymns.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) }), id: \.number) {
                            item in Text(item.title)
                        }.frame(width: g.size.width - 5, height: g.size.height - 50, alignment: .center)
                    }
                }
            }
            .navigationBarTitle("Hymns")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingHymnals = true
                    }, label: {
                        Image(systemName: "book")
                    })
                }
            }
        }
    }
}

struct HymnsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnsView()
    }
}
