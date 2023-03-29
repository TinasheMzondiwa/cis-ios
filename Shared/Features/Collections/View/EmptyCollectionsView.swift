//
//  EmptyCollectionsView.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/26.
//

import SwiftUI

struct EmptyCollectionsView: View {
    
    let caption: String
    
    var body: some View {
        VStack {
            Image("EmptyCollections")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(caption)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding([.bottom], 200)
            
        }
        .padding()
    }
}

struct EmptyCollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCollectionsView(caption: "Create a collection")
            .previewLayout(.sizeThatFits)
        
        EmptyCollectionsView(caption: "Create a collection")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
