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
    @AppStorage("hymnalFontSize") private var fontSize: Double = 22.0
    @AppStorage("hymnalTypeface") private var selectedFontRaw: String = AppTypeface.defaultTypeface.rawValue
    
    @State private var displayedBook: StoreBook?
    @State var displayedHymn: StoreHymn
    @State private var currState: (message: String, state: AlertState)? = nil
    @State private var showingHUD = false
    @State private var showingTextSettings = false
    
    private var books: [StoreBook] {
        return vm.allBooks.map {
            StoreBook(
                key: $0.key,
                language: $0.language,
                title: $0.title,
                isSelected: $0.key == displayedHymn.book
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
        let typeface = AppTypeface(rawValue: selectedFontRaw) ?? .defaultTypeface
        
        ZStack {
            
            HymnContainerView(
                previousHymn: displayedHymn.number > 1 ? displayedHymn.number - 1 : nil,
                nextHymn: displayedHymn.number < vm.hymnsFromSelectedBook.count ? displayedHymn.number + 1 : nil,
                enabled: true,
                onPreviousHymn: { swipeTo(direction: .backward) },
                onNextHymn: { swipeTo(direction: .forward) },
            ) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .center) {
                            Text(displayedHymn.number.formatted())
                            Text(displayedHymn.title)
                        }
                        .font(typeface.font(size: fontSize + 4, weight: .bold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                        
                        
                        VStack(spacing: 20) {
                            ForEach(Array(displayedHymn.lyrics.enumerated()), id: \.offset) { _, lyric in
                                if lyric.type == "refrain" {
                                    ChorusUiView(lines: lyric.lines)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            
        }
        .toolbar {
            
            ToolbarSpacer(.flexible)
            
            ToolbarItem(placement: .principal) {
                HymnalsPickerUIView(
                    book: displayedBook?.title ?? defaultTitle(),
                    books: books,
                    onSelect: { book in setSelectedBook(to: book) }
                )
            }
            
            ToolbarSpacer(.flexible)
            
            
            ToolbarItem(placement: .navigationBarTrailing) {
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
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
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
