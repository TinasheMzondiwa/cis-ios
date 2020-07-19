//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    var body: some View {
        List(hymnalsData, id: \.key) { hymnal in
            Button(action: {
                
            }, label: {
                HymnalView(hymnal: hymnal)
            })
            
        }
        .padding(.top, 16)
        .navigationBarTitle(Text("Hymnals"), displayMode: .inline)
    }
}

struct HymnalsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnalsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
