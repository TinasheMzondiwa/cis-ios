//
//  HymnContainerView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import SwiftUI

struct HymnContainerView<Content: View>: View {
    // MARK: - API Properties
    let previousHymn: Int?
    let nextHymn: Int?
    let enabled: Bool
    let onPreviousHymn: () -> Void
    let onNextHymn: () -> Void
    let content: Content
    
    // MARK: - Internal State
    @GestureState private var dragOffset: CGFloat = 0
    private let previewWidth: CGFloat = 80
    
    // MARK: - Initializer
    init(
        previousHymn: Int?,
        nextHymn: Int?,
        enabled: Bool,
        onPreviousHymn: @escaping () -> Void,
        onNextHymn: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.previousHymn = previousHymn
        self.nextHymn = nextHymn
        self.enabled = enabled
        self.onPreviousHymn = onPreviousHymn
        self.onNextHymn = onNextHymn
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let fullWidth = geometry.size.width
            
            HStack(spacing: 0) {
                // Previous Hymn Preview
                HymnPreviewView(number: previousHymn ?? 0)
                    .frame(width: previewWidth)
                
                // User-provided content view
                content
                    .frame(width: fullWidth)
                
                // Next Hymn Preview
                HymnPreviewView(number: nextHymn ?? 0)
                    .frame(width: previewWidth)
            }
            .offset(x: -previewWidth + dragOffset)
            .simultaneousGesture(drag, isEnabled: enabled)
        }
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 20)
            .updating($dragOffset, body: { value, state, _ in
                let translation = value.translation
                
                // Prevent horizontal swipe from reacting if the gesture is primarily vertical
                if abs(translation.height) > abs(translation.width) {
                    state = 0
                    return
                }
                
                let width = translation.width
                
                // Prevent dragging right if there's no previous hymn
                if previousHymn == nil && width > 0 {
                    state = 0
                    return
                }
                
                // Prevent dragging left if there's no next hymn
                if nextHymn == nil && width < 0 {
                    state = 0
                    return
                }
                
                // Clamp the offset to the preview width
                state = min(previewWidth, max(-previewWidth, width))

            })
            .onEnded({ value in
                // Prevent gesture ending action if the gesture is primarily vertical
                if abs(value.translation.height) > abs(value.translation.width) { return }
                
                let swipeThreshold: CGFloat = 80
                
                if value.translation.width < -swipeThreshold {
                    if (nextHymn != nil) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        onNextHymn()
                    }
                } else if value.translation.width > swipeThreshold {
                    if (previousHymn != nil) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        onPreviousHymn()
                    }
                }
            })
    }
}

// A view for the numeric-only preview of adjacent hymns.
private struct HymnPreviewView: View {
    let number: Int
    
    var body: some View {
        ZStack {
            if number > 0 {
                Text("\(number)")
                    .font(AppTypeface.garamond.font(size: 22, weight: .medium))
                    .foregroundStyle(.primary)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HymnPreviewView(number: 25)
}

