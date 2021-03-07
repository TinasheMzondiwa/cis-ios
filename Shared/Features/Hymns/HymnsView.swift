//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

private enum Sort: String {
    case number = "number"
    case title = "title"
}

struct HymnsView: View {
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @AppStorage(Constants.hymnalKey) var hymnal: String = Constants.defHymnal
    @AppStorage(Constants.hymnalTitleKey) var hymnalTitle: String = Constants.defHymnalTitle
    @AppStorage("sort") var sortOption: String = Sort.number.rawValue

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
    
    private var sortButton: some View {
        Button(action: {
            withAnimation {
                sortOption = sortOption == Sort.title.rawValue ? Sort.number.rawValue : Sort.title.rawValue
            }
        }, label: {
            Text(sortOption == Sort.title.rawValue ? "123" : "ABC")
        })
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
                        .headLineStyle()
                        .lineLimit(1)
                })
        }
        .navigationTitle(hymnalTitle)
        .add(self.searchBar)
        .resignKeyboardOnDragGesture()
        .sheet(isPresented: $showModal) {
            HymnalsView { showModal.toggle() }
        }
    }
    
    private var iOSContent: some View {
        content
            .navigationBarItems(leading: sortButton, trailing: hymnalsButton)
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
