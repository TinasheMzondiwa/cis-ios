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
        
        ZStack {
            if let html = displayedHymn.html {
                ScrollView {
                    RichText(html: html)
                        .fontType(.customName("Proxima"))
                        .customCSS("""
                            @font-face {
                                font-family: 'Proxima';
                                src: url("proxima_nova_soft_regular.ttf") format('truetype');
                            }
                        
                            body {
                                font-size: 1.2rem;
                                padding: 2rem;
                            }
                        """)
                        .placeholder {
                            PendingHymnView(title: displayedHymn.title)
                        }
                        .padding()
                }
                
            } else if let markdown = displayedHymn.markdown {
                ScrollView {
                    Markdown(markdown)
                        .textSelection(.enabled)
                        .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            dismiss()
                        }
                    }, label: {
                        SFSymbol.chevronBackward
                    })
                    
                    Text(displayedBook?.title ?? defaultTitle())
                        .font(.headline)
                }
            }
            
            ToolbarItemGroup {
                Button(action: { vm.toggleCollectionSheetVisibility() }) {
                    SFSymbol.textPlus
                        .accessibility(label: Text(LocalizedStringKey("Collections.Add")))
                }
                
                Button(action: {vm.toggleBookSelectionShownFromHymnView() }) {
                    SFSymbol.bookCircle
                        .accessibility(label: Text(LocalizedStringKey("Hymnals.Switch")))
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
