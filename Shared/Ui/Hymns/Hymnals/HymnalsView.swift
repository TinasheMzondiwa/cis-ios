//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @EnvironmentObject var selectedData: HymnalAppData
    
    @State var data: [RemoteHymnal] = hymnalsData
    @State var isLoadingData = true
    
    var body: some View {
        List(data, id: \.key) { hymnal in
            
            Button(action: {
                if (isLoadingData) {
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    let hymns = loadHymns(key: hymnal.key)

                    DispatchQueue.main.async {
                        let selected = hymnalsData.first(where: {$0.key == hymnal.key})!
                        selectedData.hymnal = Hymnal(key: selected.key, title: selected.title!, language: selected.language!)
                        selectedData.hymns = hymns
                        selectedData.isShowingHymnals.toggle()
                    }
                }
                
            }, label: {
                HymnalView(hymnal: hymnal,
                           index: data.firstIndex(of: hymnal) ?? 0,
                           loading: isLoadingData)
            })
            
        }
        .padding()
        .onAppear(perform: {
            getHymnals(completion: { hymnals in
                selectedData.hymnals = hymnals
                isLoadingData = false
                data = hymnals
            })
        })
        
    }
}

struct HymnalsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnalsView()
            .environmentObject(HymnalAppData())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
