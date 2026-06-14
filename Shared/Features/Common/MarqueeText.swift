//
//  MarqueeText.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-05-17.
//

import SwiftUI

struct MarqueeText: View {
    var text: String
    var font: Font
    var isPlaying: Bool
    
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        // Invisible text guarantees the correct height and lets it expand horizontally
        Text(text)
            .font(font)
            .lineLimit(1)
            .hidden()
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                // The actual visible text inside a GeometryReader for width measurements
                GeometryReader { containerProxy in
                    let containerWidth = containerProxy.size.width
                    
                    HStack(spacing: 30) {
                        Text(text)
                            .font(font)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .background(
                                GeometryReader { textProxy in
                                    Color.clear
                                        .onAppear { textWidth = textProxy.size.width }
                                        .onChange(of: textProxy.size.width) { _, w in textWidth = w }
                                }
                            )
                        
                        // Only show the second copy if the text is longer than the container
                        if textWidth > containerWidth && containerWidth > 0 {
                            Text(text)
                                .font(font)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    .offset(x: offset)
                    .frame(width: containerWidth, height: containerProxy.size.height, alignment: .leading)
                    .onChange(of: isPlaying) { _, playing in
                        animate(playing: playing, containerWidth: containerWidth)
                    }
                    .onChange(of: textWidth) { _, _ in
                        offset = 0
                        animate(playing: isPlaying, containerWidth: containerWidth)
                    }
                    .onAppear {
                        animate(playing: isPlaying, containerWidth: containerWidth)
                    }
                    .mask(
                        Group {
                            if textWidth > containerWidth && containerWidth > 0 {
                                LinearGradient(
                                    stops: [
                                        .init(color: .clear, location: 0.0),
                                        .init(color: .black, location: 0.05),
                                        .init(color: .black, location: 0.95),
                                        .init(color: .clear, location: 1.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                Color.black
                            }
                        }
                    )
                }
                .clipped(),
                alignment: .leading
            )
    }
    
    private func animate(playing: Bool, containerWidth: CGFloat) {
        if playing && textWidth > containerWidth && containerWidth > 0 {
            let distance = textWidth + 30 // distance to exact start of second copy
            let duration = Double(distance) / 30.0 // 30 points per second
            
            offset = 0
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                offset = -distance
            }
        } else {
            withAnimation {
                offset = 0
            }
        }
    }
}


#Preview {
    MarqueeText(
        text: "God will take care of you, through all the way, all the days.", font: .title2, isPlaying: true
    )
    .padding()
}
