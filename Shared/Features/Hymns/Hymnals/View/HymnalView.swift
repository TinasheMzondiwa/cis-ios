//
//  HymnalView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import SwiftUI

struct HymnalView: View {
    
    private let COLORS: [String] = ["#4b207f", "#5e3929", "#7f264a", "#2f557f", "#e36520", "#448d21", "#3e8391"]
    
    let book: StoreBook
    var index: Int
    let isPinned: Bool
    
    var body: some View {
        HStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: COLORS[index % COLORS.count]))
                    .frame(width: 42, height: 42)
                
                if book.isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .headLineStyle(selected: book.isSelected)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(book.language)
                    .subHeadLineStyle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
            
            if isPinned {
                Image(systemName: "pin.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
        }
        .padding(8)
    }
    
    func getColor() -> Color {
        if let random = COLORS.randomElement() {
            return Color.init(hex: random)
        } else {
            return Color.accentColor
        }
    }
}

struct HymnalView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                HymnalView(book: .init(key: "shona", language: "Shona", title: "Shona", isSelected: true), index: 1, isPinned: true)
                    .previewLayout(.sizeThatFits)
                
                HymnalView(book: .init(key: "cis", language: "English", title: "Christ In Song"), index: 1, isPinned: true)
                    .previewLayout(.sizeThatFits)
                
                HymnalView(book: .init(key: "shona-2", language: "Cristu Munzwiyo", title: "Shona"), index: 4, isPinned: false)
                    .previewLayout(.sizeThatFits)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                
            }
        }
        .padding()
    }
}
