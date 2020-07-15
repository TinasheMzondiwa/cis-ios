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
    
    private var hymns = [
        Hymn(title: "1 Watchman Blow The Gospel Trumpet."),
        Hymn(title: "2 The Coming King"),
        Hymn(title: "3 Face To Face"),
        Hymn(title: "4 He Is Coming"),
        Hymn(title: "5 How Far From Home")
    ]
    
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
                        
                        List(hymns.filter({ searchText.isEmpty ? true : $0.title.contains(searchText) })) {
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
