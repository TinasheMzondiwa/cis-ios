//
//  CollectionsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct CollectionsView: View {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
                    .navigationTitle("Collections")
            }
        } else {
            #if os(iOS)
                content
                    .navigationTitle("Collections")
            #else
                content
                    .frame(minWidth: 300, idealWidth: 500)
            #endif
            
        }
    }
    
    var content: some View {
        VStack {
            
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}
