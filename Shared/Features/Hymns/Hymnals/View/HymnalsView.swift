//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @AppStorage(Constants.hymnalKey) var hymnal: String = Constants.defHymnal
    @AppStorage(Constants.hymnalTitleKey) var hymnalTitle: String = Constants.defHymnalTitle
    
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
                            HymnalView(hymnal: item,
                                       index: viewModel.hymnals.firstIndex(of: item) ?? 0)
                        })
                    }
                }
            }
            .padding([.leading, .trailing])
            .navigationBarTitle("Hymnals", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        onDismiss()
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
            HymnalsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .previewLayout(.sizeThatFits)
            
            HymnalsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}
