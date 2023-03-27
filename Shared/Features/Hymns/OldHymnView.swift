//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI
import WebKit

struct OldHymnView: View {
    @EnvironmentObject var vm: CISAppViewModel
    
    @State private var displayedBook: StoreBook?
    @State var displayedHymn: StoreHymn
    
    var body: some View {
        
        ZStack {
            HTMLText(html: displayedHymn.content)
        }
        .navigationTitle(displayedBook?.title ?? vm.selectedBook?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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
//            if let model = viewModel.model {
//                OldAddToCollectionView(hymnId: model.id, onDismiss: {
//                    showCollectionModal.toggle()
//                })
//                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//            }
        }
        .sheet(isPresented: $vm.bookSelectionShownFromHymnView) {
//            OldHymnalsView(hymnal: viewModel.hymnal?.id ?? hymnal) { item in
//                showHymnalsModal.toggle()
//
//                if let hymnal: HymnalModel = item {
//                    viewModel.switchHymnal(hymnal: hymnal)
//                }
//            }
        }
//        .hud(state: viewModel.currState?.state, isPresented: $viewModel.showingHUD) {
//            if let data = viewModel.currState {
//                Label(
//                    data.message,
//                    systemImage: data.state.rawValue
//                )
//                .font(.body.weight(.bold))
//                .foregroundColor(data.state == .info ? Color.primary : .white)
//            }
//        }
    
    }
}

struct OldHymnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OldHymnView( displayedHymn: .init(id: UUID(), title: "1. Watchman Blow The Gospel Trumpet", titleStr: "Watchman Blow The Gospel Trumpet", content: "<h1>1 Watchman Blow The Gospel Trumpet.</h1>\n<p>\nWatchman, blow the gospel trumpet,<br/>\nEvery  soul a warning give;<br/>\n Whosoever hears the message <br/>\nMay repent, and turn, and live.", book: .defaultBook, number: 1))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
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
