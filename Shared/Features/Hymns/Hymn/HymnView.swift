//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI

struct HymnView: View {
    @EnvironmentObject var vm: CISAppViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State private var displayedBook: StoreBook?
    @State var displayedHymn: StoreHymn
    @State private var currState: (message: String, state: AlertState)? = nil
    @State private var showingHUD = false
    @State private var showingTextSettings = false
    @State private var showingNumberPicker = false
    
    private var books: [StoreBook] {
        return vm.allBooks.map {
            StoreBook(
                key: $0.key,
                language: $0.language,
                title: $0.title,
                isSelected: $0.key == displayedHymn.book,
                refrainLabel: $0.refrainLabel
            )
        }
    }
    
    private func swipeTo(direction: CISAppViewModel.SwipeDirection) {
        var newHymn: StoreHymn?
        switch direction {
            
        case .forward:
            newHymn = vm.getNextOrPreviousHymn(to: displayedHymn, swipeDirection: .forward)
        case .backward:
            newHymn = vm.getNextOrPreviousHymn(to: displayedHymn, swipeDirection: .backward)
        }
        
        if let newHymn {
            displayedHymn = newHymn
        } else {
            currState = ("No more Hymns", .warning)
        }
    }
    
    private func setSelectedBook(to book: StoreBook) {
        if let newHymn = vm.get(similarHymnTo: displayedHymn, from: book) {
            displayedBook = book
            displayedHymn = newHymn
        } else {
            displayedBook = vm.selectedBook
            // Hymn not found
            currState = ("Hymn \(displayedHymn.number) is not available in \(book.title)", .warning)
            showingHUD = true
        }
    }
    
    var body: some View {
        ZStack {
            HymnContainerView(
                previousHymn: displayedHymn.number > 1 ? displayedHymn.number - 1 : nil,
                nextHymn: displayedHymn.number < vm.hymnsFromSelectedBook.count ? displayedHymn.number + 1 : nil,
                enabled: true,
                onPreviousHymn: { swipeTo(direction: .backward) },
                onNextHymn: { swipeTo(direction: .forward) },
            ) {
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        
                        HymnInfoUIView(
                            title: displayedHymn.title,
                            hymnNumber: displayedHymn.number,
                            titleEnglish: displayedHymn.titleEnglish,
                            hymnalReferences: displayedHymn.hymnalReferences,
                        )
                        
                        VStack(alignment: .center, spacing: 20) {
                            ForEach(Array(displayedHymn.lyrics.enumerated()), id: \.offset) { _, lyric in
                                if lyric.type == "refrain" {
                                    ChorusUiView(
                                        lines: lyric.lines,
                                        refrainLabel: vm.selectedBook?.refrainLabel
                                    )
                                } else {
                                    VerseUIView(
                                        index: lyric.index ?? 0,
                                        lines: lyric.lines
                                    )
                                }
                            }
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: 700)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                HymnalsPickerUIView(
                    book: displayedBook?.title ?? defaultTitle(),
                    books: books,
                    onSelect: { book in setSelectedBook(to: book) }
                )
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    HapticsManager.instance.trigger(.buttonPress)
                    showingNumberPicker.toggle()
                } label: {
                    SFSymbol.number
                }
                .modifier(
                    NumberPickerPresentation(
                        isPresented: $showingNumberPicker,
                        maxNumber: vm.hymnsFromSelectedBook.count,
                        onSelect: { selectedNumber in
                            if let hymn = vm.hymnsFromSelectedBook.first(where: { $0.number == selectedNumber }) {
                                displayedHymn = hymn
                            }
                        }
                    )
                )
                
                Menu {
                    Button(action: {
                        HapticsManager.instance.trigger(.buttonPress)
                        vm.toggleCollectionSheetVisibility()
                    }) {
                        Label("Add to Collection", systemImage: "text.badge.plus")
                    }
                    
                    Button(action: {
                        HapticsManager.instance.trigger(.buttonPress)
                        
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showingTextSettings.toggle()
                        }
                    }) {
                        Label(LocalizedStringKey("Text.Format"), systemImage: SFSymbol.textFormat.rawValue)
                    }
                    
                    Divider()
                    
                    Button(action: {
                        HapticsManager.instance.trigger(.buttonPress)
                        UIApplication.shared.open(URL(string: WebLink.userJot.rawValue)!)
                    }) {
                        Label("Report an Issue", systemImage: "exclamationmark.bubble")
                    }
                    
                } label: {
                    SFSymbol.ellipsis
                }
                .modifier(
                    TextSettingsPresentation(
                        isPresented: $showingTextSettings,
                        isCompact: horizontalSizeClass == .compact,
                    )
                )
            }
        }
        .sheet(isPresented: $vm.collectionsSheetShown) {
            AddToCollectionView(hymn: displayedHymn)
        }
        .hud(state: currState?.state, isPresented: $showingHUD) {
            if let data = currState {
                Label(
                    data.message,
                    systemImage: data.state.rawValue
                )
                .font(.body.weight(.bold))
                .foregroundColor(data.state == .info ? Color.primary : .white)
            }
        }
    }
    
    func defaultTitle() -> String {
        vm.allBooks.first { $0.key == displayedHymn.book }?.title ?? ""
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        HymnView(displayedHymn: CISAppViewModel.sample.hymnsFromSelectedBook.first!)
    }
    .environmentObject(CISAppViewModel.sample)
}
#endif
