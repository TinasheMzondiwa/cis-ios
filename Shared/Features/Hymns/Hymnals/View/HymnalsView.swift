//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @EnvironmentObject var selectedData: HymnalAppData
    
    @ObservedObject var viewModel = HymnalsViewModel()
    
    var body: some View {
        
        List(self.viewModel.hymnals, id: \.id) {  hymnal in
            Button(action: {
                viewModel.hymnalSelected(id: hymnal.id)
                
                selectedData.hymnal = hymnal
                selectedData.isShowingHymnals.toggle()
            }, label: {
                HymnalView(hymnal: hymnal,
                           index: viewModel.hymnals.firstIndex(of: hymnal) ?? 0)
            })
        }
        .padding()
        .onAppear(perform: {
            viewModel.onAppear(selectedId: selectedData.hymnal.id)
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
