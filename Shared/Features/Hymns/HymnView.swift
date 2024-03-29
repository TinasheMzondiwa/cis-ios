//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI
import WebKit
import MarkdownUI

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
                HTMLText(html: html)
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

#Preview {
    NavigationView {
        HymnView( displayedHymn: .init(id: UUID(), title: "1. Watchman Blow The Gospel Trumpet", titleStr: "Watchman Blow The Gospel Trumpet", html: "<h1>1 Watchman Blow The Gospel Trumpet.</h1>\n<p>\nWatchman, blow the gospel trumpet,<br/>\nEvery  soul a warning give;<br/>\n Whosoever hears the message <br/>\nMay repent, and turn, and live.", markdown: nil, book: .defaultBook, number: 1))
    }
}

private struct HTMLText: UIViewRepresentable {

    let html: String
    private let contentScalingSetting = """
    <HEAD>
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">
        <style>
            :root {
                color-scheme: light dark;
            }
            body {
                font: -apple-system-body;
                color: var(--title-color);
                padding: 1rem;
                font-size: 1.2rem;
            }
        </style>
    </HEAD>
    """
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString(contentScalingSetting + html, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(contentScalingSetting + html, baseURL: nil)
    }
}
