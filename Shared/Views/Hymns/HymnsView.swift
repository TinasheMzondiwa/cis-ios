//
//  HymnsView.swift
//  iOS
//
//  Created by George Nyakundi on 13/03/2023.
//

import SwiftUI

struct HymnsView: View {
    
    @EnvironmentObject var vm: CISAppViewModel
    @State var filterQuery: String = ""
    
    var filteredHymns: [StoreHymn] {
        if filterQuery.trimmed.isEmpty {
            return vm.hymnsFromSelectedBook
        } else {
            return vm.hymnsFromSelectedBook.filter { $0.title.localizedCaseInsensitiveContains(filterQuery)}
        }
    }
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @AppStorage("sort") var sortOption: String = Sort.number.rawValue
    
    var body: some View {
        if (idiom == .phone) {
            iOSContent
        } else {
        #if os(iOS)
            iOSContent
        #else
            content
                .frame(minWidth: 300, idealWidth: 500)
                .toolbar(items: {
                    ToolbarItem {
                        bookSwitchButton
                    }
                })
        #endif
        }
    }
    
    
    // MARK: - Private Views
    private var bookSwitchButton: some View {
        Button {
            vm.toggleBookSelectionSheet()
        } label: {
            SFSymbol.bookCircle
                .imageScale(.large)
                .accessibility(label: Text(LocalizedStringKey("Hymnals.Switch")))
                .padding()
        }
    }
    
    private var sortButton: some View {
        Button {
            withAnimation {
                sortOption = sortOption == Sort.titleStr.rawValue ? Sort.number.rawValue : Sort.titleStr.rawValue
                vm.toggleHymnsSorting(using: Sort(rawValue: sortOption) ?? .titleStr)
            }
        } label: {
            Text(LocalizedStringKey(sortOption == Sort.titleStr.rawValue ? "Sort.Number" : "Sort.Title"))
        }
        
    }
    
    private var content: some View {
        NavigationView {
            List {
                ForEach(filteredHymns, id: \.id){ hymn in
                    NavigationLink(destination: HymnView(displayedHymn: hymn)) {
                        Text(sortOption == Sort.number.rawValue ? hymn.title : "\(hymn.titleStr) - \(hymn.number)")
                            .headLineStyle()
                            .lineLimit(1)
                    }
                }
            }
            .navigationTitle(vm.selectedBook?.title ?? "")
            .searchable(text: $filterQuery)
            .resignKeyboardOnDragGesture()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    sortButton
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    bookSwitchButton
                })
            }
            .sheet(isPresented: $vm.bookSelectionShown) {
                BooksView(books: vm.allBooks) { book in
                    vm.setSelectedBook(to: book)
                } dismissAction: {
                    vm.toggleBookSelectionSheet()
                }

            }
        }
    }
    
    private var iOSContent: some View {
        content
    }
}

enum Sort: String {
    case number
    case titleStr
}
