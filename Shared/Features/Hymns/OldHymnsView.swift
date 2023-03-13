//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

private enum Sort: String {
    case number = "number"
    case title = "titleStr"
}

struct OldHymnsView: View {
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @AppStorage(Constants.hymnalKey) var hymnal: String = Constants.defHymnal
    @AppStorage(Constants.hymnalTitleKey) var hymnalTitle: String = Constants.defHymnalTitle
    @AppStorage("sort") var sortOption: String = Sort.number.rawValue

    @State private var searchQuery: String = ""
    
    @State private var showModal = false
    
    private var hymnalsButton: some View {
        Button(action: { self.showModal.toggle() }) {
            SFSymbol.bookCircle
                .imageScale(.large)
                .accessibility(label: Text(LocalizedStringKey("Hymnals.Switch")))
                .padding()
        }
    }
    
    private var sortButton: some View {
        Button(action: {
            withAnimation {
                sortOption = sortOption == Sort.title.rawValue ? Sort.number.rawValue : Sort.title.rawValue
            }
        }, label: {
            Text(LocalizedStringKey(sortOption == Sort.title.rawValue ? "Sort.Number" : "Sort.Title"))
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
        FilteredList(sortKey: sortOption,
                     filterKey: "book", filterValue: hymnal,
                     queryKey: "content", query: searchQuery) { (item: Hymn) in
            NavigationLink(
                destination: OldHymnView(hymn: HymnModel(hymn: item, bookTitle: hymnalTitle)),
                label: {
                    Text(sortOption == Sort.number.rawValue ? item.wrappedTitle : "\(item.wrappedTitleStr) - \(item.number)")
                        .headLineStyle()
                        .lineLimit(1)
                })
        }
        .navigationTitle(hymnalTitle)
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery) { query in
            searchQuery = query
        }
        .resignKeyboardOnDragGesture()
        .sheet(isPresented: $showModal) {
            OldHymnalsView(hymnal: hymnal) { item in
                showModal.toggle()
                
                if let hymnal: HymnalModel = item {
                    self.hymnal = hymnal.id
                    self.hymnalTitle = hymnal.title
                }
            }
        }
    }
    
    private var iOSContent: some View {
        content
            .navigationBarItems(leading: sortButton, trailing: hymnalsButton)
    }
}

struct OldHymnsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max", "iPad Pro (11-inch) (2nd generation)"], id: \.self) { deviceName in
            OldHymnsView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
        
    }
}
