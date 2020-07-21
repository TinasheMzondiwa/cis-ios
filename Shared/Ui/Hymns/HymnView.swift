//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI
import WebKit

struct HymnView: View {
    
    @EnvironmentObject var selectedData: HymnalAppData
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var hymn: Hymn
    var body: some View {
        HTMLText(html: hymn.content)
            .navigationBarTitle(Text(idiom == .phone ? selectedData.hymnal.title : "" ), displayMode: .inline)
        
    }
}

struct HymnView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLText(html: "<h1>1 Watchman Blow The Gospel Trumpet.</h1>\n<p>\nWatchman, blow the gospel trumpet,<br/>\nEvry  soul a warning give;<br/>\n Whosoever hears the message <br/>\nMay repent, and turn, and live.")
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}

struct HTMLText: UIViewRepresentable {

    let html: String
    private let contentScalingSetting = "<HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"> <style> :root { color-scheme: light dark; }   body { font: -apple-system-body; color: var(--title-color); padding: 1rem; font-size: 1.3rem; }</style> </HEAD>"
        
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString(contentScalingSetting + html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(contentScalingSetting + html, baseURL: nil)
    }
}
