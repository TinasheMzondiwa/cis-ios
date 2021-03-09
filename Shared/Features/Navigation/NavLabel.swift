//
//  NavLabel.swift
//  ChristInSong
//
//  Created by Tinashe  on 2021/03/09.
//

import SwiftUI

struct NavLabel: View {
    let item: (title: String, icon: String)
    
    var body: some View {
        Label(LocalizedStringKey(item.title), systemImage: item.icon)
            .accessibility(label: Text(LocalizedStringKey(item.title)))
    }
}

struct NavLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavLabel(item: NavItem.hymns)
                .previewLayout(.sizeThatFits)
            NavLabel(item: NavItem.collections)
                .previewLayout(.sizeThatFits)
            NavLabel(item: NavItem.support)
                .previewLayout(.sizeThatFits)
            NavLabel(item: NavItem.info)
                .previewLayout(.sizeThatFits)
        }
    }
}
