//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    let books: [StoreBook]
    let action: (StoreBook) -> Void
    let dismissAction: () -> Void
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(books, id: \.id) {  book in
                        
                        Button(action: {
                            action(book)
                        }, label: {
                            HymnalView(book: book, index: books.firstIndex(of: book) ?? 0)
                        })
                    }
                }
                .padding([.leading, .trailing])
            }
            .navigationBarTitle(LocalizedStringKey("Hymnals"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismissAction()
                    }, label: {
                        SFSymbol.close
                            .navButtonStyle()
                    })
                }
            }
        }
        
    }
}
