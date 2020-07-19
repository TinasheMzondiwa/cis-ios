//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @EnvironmentObject var selectedData: HymnalAppData
    
    let data = hymnalsData
    
    var body: some View {
        List(data, id: \.key) { hymnal in
            
            Button(action: {
                DispatchQueue.global(qos: .background).async {
                    let resources = loadHymns(key: hymnal.key)

                    DispatchQueue.main.async {
                        selectedData.hymnal = hymnal
                        selectedData.hymns = resources
                        selectedData.isShowingHymnals.toggle()
                    }
                }
                
            }, label: {
                HymnalView(hymnal: hymnal, index: data.firstIndex(of: hymnal) ?? 0 )
            })
            
        }
        .padding()
    }
}

struct HymnalsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnalsView()
            .environmentObject(HymnalAppData())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
