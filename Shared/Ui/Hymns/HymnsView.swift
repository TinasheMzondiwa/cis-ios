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
            VStack {
                NavigationLink(
                    destination: HymnalsView(),
                    isActive: $isShowingHymnals,
                    label: { EmptyView() })
                
                SearchBarView(searchText: $searchText)
                
                List {
                    
                    ForEach(hymns.filter({ searchText.isEmpty ? true : $0.content.localizedCaseInsensitiveContains(searchText) }), id: \.self) { item in
                        
                        NavigationLink(
                            destination: EmptyView(),
                            label: {
                                Text(item.title)
                            })
                        
                    }
                }
            }
            .navigationBarTitle("Hymns")
            .resignKeyboardOnDragGesture()
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
