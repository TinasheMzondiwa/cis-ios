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
struct CenteredLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
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
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                }
                if !description.isEmpty {
                    Text(description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .padding([.top, .bottom], 8)
            
            Spacer()
            
            Text(String(hymns))
                .foregroundColor(.secondary)
                .font(.system(.subheadline, design: .rounded))
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
