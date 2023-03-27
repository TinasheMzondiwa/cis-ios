//
//  CollectionRowView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct OldCollectionRowView: View {
    
    let item: StoreCollection
    let selected: Bool?
    
    var body: some View {
        HStack {
            CheckBoxView(checked: .constant(selected ?? false))
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .headLineStyle(selected: selected ?? false)
                    .lineSpacing(4)
                    .animation(.none)
                if let about = item.about {
                    Text(about)
                        .footNoteStyle()
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

struct OldCollectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OldCollectionRowView(item: .init(id: UUID(), title: "Favorite Hymns", dateCreated: .now), selected: true)
                .previewLayout(.sizeThatFits)
            OldCollectionRowView(item: .init(id: UUID(), title: "Sabbath Hymns", dateCreated: .now), selected: false)
                .previewLayout(.sizeThatFits)
            OldCollectionRowView(item: .init(id: UUID(), title: "Favorite Hymns", dateCreated: .now, about: "Some hymns for the Sabbath I love so much Some hymns for the Sabbath I love so much Some hymns for the Sabbath I love so much Some hymns for the Sabbath I love so much"), selected: false)
                .previewLayout(.sizeThatFits)
            
        }
    }
}
