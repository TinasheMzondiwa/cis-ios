//
//  PendingView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/26.
//

import SwiftUI

struct PendingView<Content: View>: View {
    var isRedacted: Bool
    let content: Content

    init(isRedacted: Bool = true, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.isRedacted = isRedacted
    }
    
    var body: some View {
        if self.isRedacted {
            content
                .redacted(reason: .placeholder)
        } else {
            content
                .unredacted()
        }
    }
}
struct PendingView_Previews: PreviewProvider {
    static var previews: some View {
        PendingView() {
            NavigationView {
                Form {
                    Text("test")
                        .font(.largeTitle)
                    Text("test")
                    Text("Longer Line I can see here")
                    Text("test")
                    
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color.blue)
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("StrokeColor"), lineWidth: 1)
                            )
                        Text("Blue Color showing here")
                        Spacer()
                    }
                    Text("What about this thing")
                    HStack {
                        Image(systemName: "gear")
                        Toggle("This is a big decision", isOn: .constant(false))
                    }
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color.red)
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("StrokeColor"), lineWidth: 1)
                            )
                        Text("Red Color showing here")
                        Spacer()
                    }
                }
            }
        }
    }
}
