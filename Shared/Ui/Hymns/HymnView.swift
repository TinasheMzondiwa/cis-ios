//
//  HymnView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import SwiftUI
import WebKit

struct HymnView: View {
    var hymn: Hymn
    var body: some View {
        ScrollView {
            
            HTMLText(html: hymn.content)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
        }.navigationBarTitle(Text("Christ In Song"), displayMode: .inline)
    }
}

struct HymnView_Previews: PreviewProvider {
    static var previews: some View {
        HymnView(hymn: Hymn(
                    content: "<h1><b>1 Watchman Blow The Gospel Trumpet.</b></h1>\n        <p>\nWatchman, blow the gospel trumpet,<br/>\n         Evry  soul a warning give;<br/>\n        Whosoever hears the message <br/>\n        May repent, and turn, and live."
        ))
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}

struct HTMLText: UIViewRepresentable {

    let html: String
        
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
