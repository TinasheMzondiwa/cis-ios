//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI
import WebKit

struct HymnView: View {
    
    @AppStorage(Constants.hymnalKey) var hymnal: String = Constants.defHymnal
    @State private var showCollectionModal = false
    @State private var showHymnalsModal = false
    
    @ObservedObject private var viewModel = HymnViewModel()
    
    var hymn: HymnModel
    
    var body: some View {
        
        ZStack {
            if let model = viewModel.model {
                HTMLText(html: model.content)
            } else {
                // TODO: Loading state and re-enter view
                EmptyView()
            }
        }
        .navigationTitle(hymn.bookTitle)
        .toolbar {
            ToolbarItemGroup {
                Button(action: { showCollectionModal.toggle() }) {
                    SFSymbol.textPlus
                        .accessibility(label: Text(LocalizedStringKey("Collections.Add")))
                }
                
                Button(action: { showHymnalsModal.toggle() }) {
                    SFSymbol.bookCircle
                        .accessibility(label: Text(LocalizedStringKey("Hymnals.Switch")))
                }
            }
        }
        .sheet(isPresented: $showCollectionModal) {
                AddToCollectionView(hymnId: hymn.id, onDismiss: {
                    showCollectionModal.toggle()
                    viewModel.model = hymn
                })
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)

        }
        .sheet(isPresented: $showHymnalsModal) {
            HymnalsView(hymnal: viewModel.hymnal?.id ?? hymnal) { item in
                showHymnalsModal.toggle()
                
                if let hymnal: HymnalModel = item {
                    viewModel.switchHymnal(hymnal: hymnal)
                }
            }
        }
        .hud(state: viewModel.currState?.state, isPresented: $viewModel.showingHUD) {
            if let data = viewModel.currState {
                Label(
                    data.message,
                    systemImage: data.state.rawValue
                )
                .font(.body.weight(.bold))
                .foregroundColor(data.state == .info ? Color.primary : .white)
            }
        }
        .onAppear {
            viewModel.onAppear(hymn: hymn)
        }
    
    }
}

struct HymnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HymnView(hymn: HymnModel(content: "<h1>1 Watchman Blow The Gospel Trumpet.</h1>\n<p>\nWatchman, blow the gospel trumpet,<br/>\nEvery  soul a warning give;<br/>\n Whosoever hears the message <br/>\nMay repent, and turn, and live."))
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
