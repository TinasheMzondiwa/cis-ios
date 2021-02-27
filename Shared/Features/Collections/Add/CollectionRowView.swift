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
            CheckBoxView(checked: .constant(selected))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(selected ? .primary : Color.primary.opacity(0.7))
                    .lineSpacing(4)
                    .animation(.none)
                if !description.isEmpty {
                    Text(description)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                        .lineLimit(1)
                }
            }
            .padding([.leading], 8)
            
            Spacer()
        }
        .padding([.top, .bottom], 8)
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
