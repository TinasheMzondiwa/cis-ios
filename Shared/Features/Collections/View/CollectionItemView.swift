//
//  CollectionItemView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return dateFormatter.string(from: self)
    }
}

struct CollectionItemView: View {
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
            CollectionItemView(title: "Favorite Hymns", description: "Some of the very best hymns I love so much", date: Date(), hymns: 4)
                .previewLayout(.sizeThatFits)
            CollectionItemView(title: "Sabbath Hymns", description: "Some hymns for the Sabbath I love so much", date: nil, hymns: 0)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            CollectionItemView(title: "Sabbath Hymns", description: "Some hymns for the Sabbath I love so much", date: nil, hymns: 23)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
