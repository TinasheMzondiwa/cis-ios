//
//  CollectionRowView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct CollectionRowView: View {
    
    let title: String
    let description: String
    let selected: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(selected ? Color.accentColor : Color(.secondarySystemBackground))
                    .frame(width: 30, height: 30)
                
                if selected {
                    SFSymbol.checkmark
                        .foregroundColor(.white)
                }
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(selected ? .headline : .body)
                    .lineSpacing(4)
                    .animation(.none)
                if !description.isEmpty {
                    Text(description)
                        .font(.footnote)
                        .lineSpacing(4)
                        .lineLimit(1)
                        //.padding([.top, .bottom])
                }
            }
            
            Spacer()
        }
        .padding([.top, .bottom], 8)
       // .border(selected ? Color.primary : Color.secondary, width: 2)
       // .cornerRadius(12)
        .animation(.easeIn)
    }
}

struct CollectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CollectionRowView(title: "Favorite Hymns", description: "Some of the very best hymns I love so much", selected: true)
                .previewLayout(.sizeThatFits)
            CollectionRowView(title: "Sabbath Hymns", description: "Some hymns for the Sabbath I love so much", selected: false)
                .previewLayout(.sizeThatFits)
            
            CollectionRowView(title: "Sabbath Hymns", description: "", selected: false)
                .previewLayout(.sizeThatFits)
            
            CollectionRowView(title: "Favorite Hymns", description: "Some hymns for the Sabbath I love so much Some hymns for the Sabbath I love so much Some hymns for the Sabbath I love so much Some hymns for the Sabbath I love so much", selected: false)
                .previewLayout(.sizeThatFits)
            
        }
    }
}
