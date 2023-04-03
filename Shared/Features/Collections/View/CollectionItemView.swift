//
//  CollectionItemView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct CollectionItemView: View {
    
    let item: StoreCollection
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text(item.title)
                        .headLineStyle()
                        .lineLimit(1)
                    
                }
                if let about = item.about {
                    Text(about)
                        .subHeadLineStyle()
                }
            }
            .padding([.top, .bottom], 8)
            
            Spacer()
            
            Text(String(item.hymns?.count ?? 0))
                .subHeadLineStyle()
        }
    }
}

struct CollectionItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CollectionRowView(item: .init(id: UUID(), title: "Favorite Hymns", dateCreated: .now, hymns: [.init(id: UUID(), title: "Test Hymn", titleStr: "Test Hymn", html: "An amazing hymn", markdown: nil, book: .defaultBook, number: 1)]), selected: false)
        }
    }
}
