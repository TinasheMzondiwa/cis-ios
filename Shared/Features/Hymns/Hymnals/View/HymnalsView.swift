//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @AppStorage(Constants.hymnalKey) var hymnal: String = Constants.defHymnal
    
    @ObservedObject var viewModel = HymnalsViewModel()
    
    var onDismiss: (HymnalModel?) -> Void
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(self.viewModel.hymnals, id: \.id) {  item in
                        
                        Button(action: {
                            viewModel.hymnalSelected(id: item.id)
                            
                            onDismiss(item)
                        }, label: {
                            HymnalView(hymnal: item,
                                       index: viewModel.hymnals.firstIndex(of: item) ?? 0)
                        })
                    }
                }
            }
            .padding([.leading, .trailing])
            .navigationBarTitle(LocalizedStringKey("Hymnals"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        onDismiss(nil)
                    }, label: {
                        SFSymbol.close
                            .navButtonStyle()
                    }))
        }
        .onAppear(perform: {
            viewModel.onAppear(selectedId: hymnal)
        })
        
    }
}

struct HymnalsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HymnalsView { item in }
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .previewLayout(.sizeThatFits)
            
            HymnalsView { item in }
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}
