//
//  BooksView.swift
//  iOS
//
//  Created by George Nyakundi on 14/03/2023.
//

import SwiftUI

struct BooksView: View {
    
    let books: [StoreBook]
    let action: (StoreBook) -> Void
    let dismissAction: () -> Void
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(books, id: \.id) { book in
                        Button {
                            action(book)
                        } label: {
                            BookItemView(book: book, index: books.firstIndex(of: book) ?? 0)
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            .navigationBarTitle(LocalizedStringKey("Hymnals"), displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismissAction()
                    } label: {
                        SFSymbol.close.navButtonStyle()
                    }
                }
            }
        }
    }
}

struct BookItemView: View {
    
    let book: StoreBook
    let index: Int
    
    private let COLORS: [String] = ["#4b207f", "#5e3929", "#7f264a", "#2f557f", "#e36520", "#448d21", "#3e8391"]
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.init(hex: COLORS[index % COLORS.count]))
                        .frame(width: 42, height: 42, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
//                    SFSymbol.checkmark
//                        .foregroundColor(.white)
//                        .opacity(book.isSelected ? 1 : 0)
                }
                
                VStack(alignment: .leading) {
                    Text(book.title)
//                        .headLineStyle(selected: book.isSelected)
                    Text(book.language)
                        .subHeadLineStyle()
                }
                .padding(.leading, 16)
                Spacer()
            }
            .padding([.bottom], 8)
            .padding([.top], 16)
            
            Divider()
                .padding(.leading, 70)
        }
    }
}
