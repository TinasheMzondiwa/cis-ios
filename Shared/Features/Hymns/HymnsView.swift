//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @AppStorage(Contants.hymnalKey) var hymnal: String = Contants.defHymnal
    @AppStorage(Contants.hymnalTitleKey) var hymnalTitle: String = Contants.defHymnalTitle

    @ObservedObject private var searchBar: SearchBar = SearchBar()
    
    @State private var showModal = false
    
    private var hymnalsButton: some View {
        Button(action: { self.showModal.toggle() }) {
            SFSymbol.bookCircle
                .imageScale(.large)
                .accessibility(label: Text("Switch Hymnals"))
                .padding()
        }
    }
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                iOSContent
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            #if os(iOS)
                iOSContent
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
                    .toolbar(items: {
                        ToolbarItem {
                            hymnalsButton
                        }
                    })
            #endif
        }
    }
    
    private var content: some View {
        FilteredList(sortKey: "number",
                     filterKey: "book", filterValue: hymnal,
                     queryKey: "content", query: searchBar.text) { (item: Hymn) in
            NavigationLink(
                destination: HymnView(hymn: HymnModel(hymn: item, bookTitle: hymnalTitle)),
                label: {
                    Text(item.wrappedTitle)
                        .fontWeight(.medium)
                        .lineLimit(1)
                })
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(hymnalTitle)
        .add(self.searchBar)
        .resignKeyboardOnDragGesture()
        .sheet(isPresented: $showModal) {
            HymnalsView { showModal.toggle() }
        }
    }
    
    private var iOSContent: some View {
        content
            .navigationBarItems(trailing: hymnalsButton)
    }
}

struct HymnsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max", "iPad Pro (11-inch) (2nd generation)"], id: \.self) { deviceName in
            HymnsView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
        
    }
}
