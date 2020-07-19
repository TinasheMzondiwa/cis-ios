//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
   // @State private var isShowingHymnals = false
    @State private var searchText = ""

    @EnvironmentObject var selectedData: HymnalAppData
    
    var hymnalsButton: some View {
        Button(action: { self.selectedData.isShowingHymnals.toggle() }) {
            Image(systemName: "book")
                .imageScale(.large)
                .accessibility(label: Text("Hymnals"))
                .padding()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
//                NavigationLink(
//                    destination: HymnalsView(),
//                    isActive: $selectedData.isShowingHymnals,
//                    label: { EmptyView() })
                
                SearchBarView(searchText: $searchText)
                
                List {
                    
                    ForEach(selectedData.hymns.filter({ searchText.isEmpty ? true : $0.content.localizedCaseInsensitiveContains(searchText) }), id: \.self) { item in
                        
                        NavigationLink(
                            destination: HymnView(hymn: item),
                            label: {
                                Text(item.title)
                            })
                        
                    }
                }
            }
            .navigationBarTitle(selectedData.hymnal.title)
            .resignKeyboardOnDragGesture()
            .navigationBarItems(trailing: hymnalsButton)
            .sheet(isPresented: $selectedData.isShowingHymnals) {
                HymnalsView()
                    .environmentObject(self.selectedData)
            }
        }
    }
}

struct HymnsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnsView()
            .environmentObject(HymnalAppData())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
