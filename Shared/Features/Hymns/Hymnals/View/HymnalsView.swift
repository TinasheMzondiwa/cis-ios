//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @AppStorage(Contants.hymnalKey) var hymnal: String = Contants.defHymnal
    @AppStorage(Contants.hymnalTitleKey) var hymnalTitle: String = Contants.defHymnalTitle
    
    @ObservedObject var viewModel = HymnalsViewModel()
    
    var onDismiss: () -> Void = {}
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(self.viewModel.hymnals, id: \.id) {  item in
                        
                        Button(action: {
                            viewModel.hymnalSelected(id: item.id)
                            
                            hymnal = item.id
                            hymnalTitle = item.title
                            
                            onDismiss()
                        }, label: {
                            VStack {
                                HymnalView(hymnal: item,
                                           index: viewModel.hymnals.firstIndex(of: item) ?? 0)
                                
                                Divider()
                                    .padding(.leading, 70)
                            }
                        })
                    }
                }
            }
            .padding([.leading, .trailing])
            .navigationBarTitle("Hymnals")
        }
        .onAppear(perform: {
            viewModel.onAppear(selectedId: hymnal)
        })
        
    }
}

struct HymnalsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnalsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
