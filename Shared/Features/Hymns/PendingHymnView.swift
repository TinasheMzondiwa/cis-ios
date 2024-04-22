//
//  PendingHymnView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2024-04-18.
//

import SwiftUI

struct PendingHymnView: View {
    @EnvironmentObject var vm: CISAppViewModel
    
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .title2Style()
                .redacted(reason: .placeholder)
            
            Text("")
            
            Text("Watchman Blow The Gospel Trumpet.")
                .redacted(reason: .placeholder)
            Text("Watchman Blow The Gospel Trumpet.")
                .redacted(reason: .placeholder)
            Text("Watchman Blow The Gospel Trumpet.")
                .redacted(reason: .placeholder)
            Text("Watchman Blow The Gospel Trumpet.")
                .redacted(reason: .placeholder)
            Text("")
            Text("Watchman ")
                .redacted(reason: .placeholder)
            Text("Watchman Blow The")
                .redacted(reason: .placeholder)
            Text("Watchman Blow The Gospel Trumpet.")
                .redacted(reason: .placeholder)
        }
        .padding()
    }
}

#Preview {
    PendingHymnView(title: "Watchman Blow The Gospel Trumpet.")
}
