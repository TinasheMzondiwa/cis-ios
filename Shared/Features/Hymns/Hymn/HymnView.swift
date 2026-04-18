//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI
import WebKit
import MarkdownUI
import RichText

struct HymnView: View {
    @EnvironmentObject var vm: CISAppViewModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hymnalFontSize") private var fontSize: Double = 22.0
    @AppStorage("hymnalTypeface") private var selectedFontRaw: String = AppTypeface.defaultTypeface.rawValue
    
    @State private var displayedBook: StoreBook?
    @State var displayedHymn: StoreHymn
    @State private var currState: (message: String, state: AlertState)? = nil
    @State private var showingHUD = false
    
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
                       ForEach(displayedHymn.lyrics) { lyric in
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
        .toolbar {
            
            ToolbarSpacer(.flexible)
            
            ToolbarItem(placement: .title) {
                Text(displayedBook?.title ?? defaultTitle())
                    .font(AppTypeface.lato.font(size: 16, weight: .medium))
                    .padding()
                    .glassEffect()
            }
            
            ToolbarSpacer(.flexible)
            
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { vm.toggleCollectionSheetVisibility() }) {
                        Label("Add to Collection", systemImage: "text.badge.plus")
                    }
                    
                    Button(action: { vm.toggleBookSelectionShownFromHymnView() }) {
                        Label("Switch Hymnal", systemImage: "book.circle")
                    }
                    
                    Button(action: {}) {
                        Label(LocalizedStringKey("Text.Format"), systemImage: SFSymbol.textFormat.rawValue)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }

        .sheet(isPresented: $vm.collectionsSheetShown) {
            AddToCollectionView(hymn: displayedHymn)
        }
        .sheet(isPresented: $vm.bookSelectionShownFromHymnView) {
            HymnalsView(books: books) { book in
                setSelectedBook(to: book)
                vm.toggleBookSelectionShownFromHymnView()
            } dismissAction: {
                vm.toggleBookSelectionShownFromHymnView()
            }
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
        .overlay(
            HStack {
                FloatingActionButtonView(icon: SFSymbol.chevronLeft, size: 40, action: { swipeTo(direction: .backward)})
                
                Spacer()
                
                FloatingActionButtonView(icon: SFSymbol.chevronRight, size: 40, action: { swipeTo(direction: .forward) })
            }.padding()
        )
    }
    
    func defaultTitle() -> String {
        vm.allBooks.first { $0.key == displayedHymn.book }?.title ?? ""
    }
}
