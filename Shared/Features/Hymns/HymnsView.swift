//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
    @EnvironmentObject var vm: CISAppViewModel
    @StateObject private var bannerManager = BannerManager.shared
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @State private var filterQuery: String = ""
    @AppStorage("sort") var sortOption: String = Sort.number.rawValue
    
    @State private var showingNumberPicker = false
    @State private var hymnToOpen: StoreHymn?
    
    var navigateToSupport: (() -> Void)? = nil
    
    var filteredHymns: [StoreHymn] {
        if filterQuery.trimmed.isEmpty {
            return vm.hymnsFromSelectedBook
        } else {
            return vm.hymnsFromSelectedBook.filter {
                "\($0.number) - \($0.title)".localizedCaseInsensitiveContains(filterQuery) ||
                $0.lyrics.contains(where: {
                    $0.lines.contains(where: { $0.localizedCaseInsensitiveContains(filterQuery) })
                })
            }
        }
    }
    
    private var books: [StoreBook] {
        return vm.allBooks.map {
            StoreBook(
                key: $0.key,
                language: $0.language,
                title: $0.title,
                isSelected: $0.key == vm.selectedBook?.key,
                refrainLabel: $0.refrainLabel
            )
        }
    }
    
    private var sortButton: some View {
        Button(action: {
            HapticsManager.instance.trigger(.light)
            AnalyticsManager.shared.logEvent("click_sort_hymns")
            
            withAnimation {
                sortOption = sortOption == Sort.titleStr.rawValue ? Sort.number.rawValue : Sort.titleStr.rawValue
                vm.toggleHymnsSorting(using: Sort(rawValue: sortOption) ?? .titleStr)
            }
        }, label: {
            Text(LocalizedStringKey(sortOption == Sort.titleStr.rawValue ? "Sort.Number" : "Sort.Title"))
        })
    }
    
    var body: some View {
#if os(iOS)
        NavigationStack {
            iOSContent
        }
#else
        searchableContent
            .frame(minWidth: 300, idealWidth: 500)
            .toolbar(items: {
                ToolbarItem(placement: .principal) {
                    HymnalsPickerUIView(
                        book: vm.selectedBook?.title ?? "Christ In Song",
                        books: books,
                        onSelect: { book in vm.setSelectedBook(to: book) }
                    )
                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        showingNumberPicker.toggle()
                    } label: {
                        Image(systemName: "number.circle")
                    }
                }
            })
#endif
    }
    
    private var content: some View {
        List {
            
            if bannerManager.isBannerVisible {
                SupportBannerView(action: {
                    AnalyticsManager.shared.logEvent("click_support_banner")
                    HapticsManager.instance.trigger(.success)
                    navigateToSupport?()
                })
            }
            
            ForEach(filteredHymns, id: \.id) { hymn in
                NavigationLink {
                    HymnView(displayedHymn: hymn)
                } label: {
                    Text(sortOption == Sort.number.rawValue ? "\(hymn.number) - \(hymn.title)" : "\(hymn.title) - \(hymn.number)")
                        .headLineStyle()
                        .lineLimit(1)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .resignKeyboardOnDragGesture()
        .navigationDestination(isPresented: Binding(
            get: { hymnToOpen != nil },
            set: { if !$0 { hymnToOpen = nil } }
        )) {
            if let hymn = hymnToOpen {
                HymnView(displayedHymn: hymn)
            }
        }
        .task {
            AnalyticsManager.shared.logScreen(name: "HymnsView")
            // Asynchronously updates FCM
            await bannerManager.fetchBannerStatus()
        }
        .modifier(
            NumberPickerPresentation(
                isPresented: $showingNumberPicker,
                maxNumber: vm.hymnsFromSelectedBook.count,
                onSelect: { selectedNumber in
                    if let hymn = vm.hymnsFromSelectedBook.first(where: { $0.number == selectedNumber }) {
                        
                        AnalyticsManager.shared.logEvent("click_hymn_number_picker", parameters: ["number": selectedNumber])
                        
                        hymnToOpen = hymn
                    }
                }
            )
        )
    }
    
    @ViewBuilder
    private var searchableContent: some View {
        if #available(iOS 18.0, *) {
            content
        } else {
            content
                .searchable(text: $filterQuery)
        }
    }
    
    private var iOSContent: some View {
        searchableContent
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    sortButton
                }
                
                ToolbarItem(placement: .principal) {
                    HymnalsPickerUIView(
                        book: vm.selectedBook?.title ?? "Christ In Song",
                        books: books,
                        onSelect: { book in vm.setSelectedBook(to: book) }
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        HapticsManager.instance.trigger(.light)
                        showingNumberPicker.toggle()
                        AnalyticsManager.shared.logEvent("click_show_number_picker", parameters: ["source": "hymns_view"])
                    } label: {
                        SFSymbol.number
                    }
                }
            }
    }
}

#if DEBUG
struct HymnsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnsView()
            .environmentObject(CISAppViewModel.sample)
    }
}
#endif

enum Sort: String {
    case number
    case titleStr
}
