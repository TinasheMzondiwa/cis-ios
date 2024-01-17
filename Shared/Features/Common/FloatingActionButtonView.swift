//
//  FloatingActionButtonView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2024-01-17.
//

import SwiftUI

struct FloatingActionButtonView: View {
    let icon: SFSymbol
    let size: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    init(
        icon: SFSymbol,
        size: CGFloat = 60,
        backgroundColor: Color = Color.accentColor,
        foregroundColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                icon
                    .font(.system(size: size / 2))
                    .foregroundColor(foregroundColor)
            }
            .frame(width: size, height: size)
            .background(backgroundColor)
            .cornerRadius(30)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    ZStack {
        VStack {
            Spacer()
            Text("Screen content...")
                .padding()
            Spacer()
        }
    }.overlay(
        FloatingActionButtonView(
        icon: SFSymbol.plus,
        action: {}), alignment: .bottom
    )
}
