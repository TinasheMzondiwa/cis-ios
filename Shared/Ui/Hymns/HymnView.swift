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
    
    var hymn: Hymn
    var body: some View {
        HTMLText(html: hymn.content)
            .navigationBarTitle(Text(selectedData.hymnal.title), displayMode: .inline)
    }
}

struct HymnView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLText(html: "<h1><font size=18><b>1 Watchman Blow The Gospel Trumpet.</b></h1>\n        <p>\nWatchman, blow the gospel trumpet,<br/>\n         Evry  soul a warning give;<br/>\n        Whosoever hears the message <br/>\n        May repent, and turn, and live.</font>")
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
