//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var searchText = ""

    @EnvironmentObject var selectedData: HymnalAppData
    
    private var hymnalsButton: some View {
        Button(action: { self.selectedData.isShowingHymnals.toggle() }) {
            Image(systemName: "book.circle")
                .imageScale(.large)
                .accessibility(label: Text("Hymnals"))
                .padding()
        }
    }
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                iOSContent
            }
        } else {
            #if os(iOS)
                iOSContent
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
                    .toolbar(items: {
                        ToolbarItem {
                            hymnalsButton
                        }
                    })
            #endif
        }
    }
    
    var content: some View {
        VStack {
            
            SearchBarView(searchText: $searchText)
            
            List {
                
                ForEach(selectedData.hymns.filter({ searchText.isEmpty ? true : $0.content.localizedCaseInsensitiveContains(searchText) }), id: \.self) { item in
                    
                    NavigationLink(
                        destination: HymnView(hymn: item),
                        label: {
                            Text(item.title)
                        })
                }
            }
            .listStyle(InsetGroupedListStyle())
            
        }
        .navigationBarTitle(selectedData.hymnal.title)
        .resignKeyboardOnDragGesture()
        .sheet(isPresented: $selectedData.isShowingHymnals) {
            HymnalsView()
                .environmentObject(self.selectedData)
        }
    }
    
    var iOSContent: some View {
        content
            .toolbar(items: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    hymnalsButton
                }
            })
    }
}

struct HymnsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max", "iPad Pro (11-inch) (2nd generation)"], id: \.self) { deviceName in
            HymnsView()
                .environmentObject(HymnalAppData())
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
        
    }
}
