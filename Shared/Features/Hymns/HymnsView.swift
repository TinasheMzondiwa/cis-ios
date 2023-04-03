//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
    @EnvironmentObject var vm: CISAppViewModel
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var filterQuery: String = ""
    @AppStorage("sort") var sortOption: String = Sort.number.rawValue
    
    var filteredHymns: [StoreHymn] {
        if filterQuery.trimmed.isEmpty {
            return vm.hymnsFromSelectedBook
        } else {
            return vm.hymnsFromSelectedBook.filter {
                $0.title.localizedCaseInsensitiveContains(filterQuery) ||
                ($0.html ?? "").localizedCaseInsensitiveContains(filterQuery) ||
                ($0.markdown ?? "").localizedCaseInsensitiveContains(filterQuery)
            }
        }
    }
    
    private var hymnalsButton: some View {
        Button(action: { vm.toggleBookSelectionSheet()}) {
            SFSymbol.bookCircle
                .imageScale(.large)
                .accessibility(label: Text(LocalizedStringKey("Hymnals.Switch")))
                .padding()
        }
    }
    
    private var sortButton: some View {
        Button(action: {
            withAnimation {
                sortOption = sortOption == Sort.titleStr.rawValue ? Sort.number.rawValue : Sort.titleStr.rawValue
                vm.toggleHymnsSorting(using: Sort(rawValue: sortOption) ?? .titleStr)
            }
        }, label: {
            Text(LocalizedStringKey(sortOption == Sort.titleStr.rawValue ? "Sort.Number" : "Sort.Title"))
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
                        bookSwitchButton
                    }
                })
#endif
        }
    }
    
    private var content: some View {
        List {
            ForEach(filteredHymns, id: \.id) { hymn in
                NavigationLink {
                    HymnView(displayedHymn: hymn)
                } label: {
                    Text(sortOption == Sort.number.rawValue ? hymn.title : "\(hymn.titleStr) - \(hymn.number)")
                        .headLineStyle()
                        .lineLimit(1)
                }
            }
        }
        .navigationTitle(vm.selectedBook?.title ?? "")
        .searchable(text: $filterQuery)
        .onChange(of: filterQuery) { query in
            filterQuery = query
        }
        .resignKeyboardOnDragGesture()
        .sheet(isPresented: $vm.bookSelectionShown) {
            HymnalsView(books: vm.allBooks) { book in
                vm.setSelectedBook(to: book)
            } dismissAction: {
                vm.toggleBookSelectionSheet()
            }
        }
    }
    
    private var iOSContent: some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    sortButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    hymnalsButton
                }
            }
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

enum Sort: String {
    case number
    case titleStr
}
