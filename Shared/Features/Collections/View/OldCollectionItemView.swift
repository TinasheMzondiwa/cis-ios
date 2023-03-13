//
//  CollectionItemView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct OldCollectionItemView: View {
    let title: String
    let description: String
    let date: Date?
    let hymns: Int
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text(title)
                        .headLineStyle()
                        .lineLimit(1)
                    
                }
                if !description.isEmpty {
                    Text(description)
                        .subHeadLineStyle()
                }
            }
            .padding([.top, .bottom], 8)
            
            Spacer()
            
            Text(String(hymns))
                .subHeadLineStyle()
        }
    }
}

struct CollectionItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OldCollectionItemView(title: "Favorite Hymns", description: "Some of the very best hymns I love so much", date: Date(), hymns: 4)
                .previewLayout(.sizeThatFits)
            OldCollectionItemView(title: "Sabbath Hymns", description: "Some hymns for the Sabbath I love so much", date: nil, hymns: 0)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            OldCollectionItemView(title: "Sabbath Hymns", description: "Some hymns for the Sabbath I love so much", date: nil, hymns: 23)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
