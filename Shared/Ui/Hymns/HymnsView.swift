//
//  HymnsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnsView: View {
    
    @State private var searchText = ""

    @EnvironmentObject var selectedData: HymnalAppData
    
    var hymnalsButton: some View {
        Button(action: { self.selectedData.isShowingHymnals.toggle() }) {
            Image(systemName: "book")
                .imageScale(.large)
                .accessibility(label: Text("Hymnals"))
                .padding()
        }
    }
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @ViewBuilder
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
            }
        } else {
            #if os(iOS)
                content
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
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
        .navigationBarItems(trailing: hymnalsButton)
        .sheet(isPresented: $selectedData.isShowingHymnals) {
            HymnalsView()
                .environmentObject(self.selectedData)
        }
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
