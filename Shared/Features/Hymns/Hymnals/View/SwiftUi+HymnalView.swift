//
//  SwiftUi+HymnalView.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-06-03.
//

import Foundation
import SwiftUI

struct AppleMailSwipeModifier: ViewModifier {
    let pinAction: () -> Void
    let forTip: Bool
    let isPinned: Bool
    
    @State private var dragOffset: CGFloat = 0
    @State private var isSwipedOpen = false
    
    private let maxActionWidth: CGFloat = 80
    private let snapThreshold: CGFloat = -50
    
    private var dragProgress: CGFloat {
        min(max(abs(dragOffset) / maxActionWidth, 0), 1)
    }
    
    // The background stays active as long as the cell has been shifted from its resting place
    private var isCellShifted: Bool {
        dragOffset != 0
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            
            // 1. Detached Action Button Background
            Group {
                if dragOffset < 0 {
                    Button(action: {
                        pinAction()
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            dragOffset = 0
                            isSwipedOpen = false
                        }
                    }) {
                        ZStack {
                            if forTip {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaleEffect(0.7 + (dragProgress * 0.3))
                            } else {
                                Circle()
                                    .fill(isPinned ? Color.orange : Color.blue)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: isPinned ? "pin.slash.fill" : "pin.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaleEffect(0.7 + (dragProgress * 0.3))
                            }
                        }
                    }
                    .padding(.trailing, 8)
                    .scaleEffect(0.8 + (dragProgress * 0.2))
                    .opacity(dragProgress)
                }
            }
            
            // 2. Main Cell Content with Persistent Shifted Background
            content
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        // Background stays gray until the cell animates fully back to 0
                        .fill(isCellShifted ? Color(.secondarySystemBackground) : Color(.systemBackground))
                )
                .offset(x: dragOffset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 15, coordinateSpace: .local)
                        .onChanged { value in
                            // ignore the swipe so the ScrollView can handle it.
                            if abs(value.translation.height) > abs(value.translation.width) && !isSwipedOpen {
                                return
                            }
                            
                            let translation = value.translation.width
                            if isSwipedOpen {
                                let targetOffset = -maxActionWidth + translation
                                if targetOffset < -maxActionWidth {
                                    dragOffset = -maxActionWidth + (translation + maxActionWidth) * 0.25
                                } else {
                                    dragOffset = targetOffset
                                }
                            } else if translation < 0 {
                                dragOffset = translation
                            }
                        }
                        .onEnded { value in
                            // If the scroll view took over, reset safely
                            if abs(value.translation.height) > abs(value.translation.width) && !isSwipedOpen {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    dragOffset = 0
                                }
                                return
                            }
                            
                            let predictedEnd = value.predictedEndTranslation.width
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                if value.translation.width < snapThreshold || predictedEnd < -maxActionWidth {
                                    dragOffset = -maxActionWidth
                                    isSwipedOpen = true
                                } else {
                                    dragOffset = 0
                                    isSwipedOpen = false
                                }
                            }
                        }
                )
                .padding([.top], isCellShifted ? (forTip ? 0 : 8) : 0)
        }
        // Smoothly animates the background color change during the spring reset
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isCellShifted)
        .onChange(of: isPinned) { _, _ in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                dragOffset = 0
                isSwipedOpen = false
            }
        }
        .onChange(of: isSwipedOpen) { _, isOpen in
            HapticsManager.instance.trigger(isOpen ? .soft : .gestureEnd)
        }
    }
}

extension View {
    func swipeToPin(isPinned: Bool, forTip: Bool = false, action: @escaping () -> Void) -> some View {
        self.modifier(AppleMailSwipeModifier(pinAction: action, forTip: forTip, isPinned: isPinned))
    }
}
