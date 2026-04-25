//
//  ShimmerPlaceholderView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-25.
//

import SwiftUI

struct ShimmerPlaceholderView: View {
    var body: some View {
        ZStack {
            // Background color matching the app's off-white background
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Top Navigation / Action Bar Placeholders
                HStack {
                    // "ABC" button placeholder
                    Capsule()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 70, height: 40)
                        .shimmering()
                    
                    Spacer()
                    
                    // Top right icon placeholder
                    Circle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 40, height: 40)
                        .shimmering()
                }
                .padding(.horizontal)
                
                // Large Title "SDA Hymnal" placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 220, height: 40)
                    .padding(.horizontal)
                    .shimmering()
                
                // Search Bar placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.25))
                    .frame(height: 44)
                    .padding(.horizontal)
                    .shimmering()
                
                // List Items Container
                VStack(spacing: 0) {
                    ForEach(0..<10, id: \.self) { index in
                        SkeletonRowView(index: index)
                        
                        // Add dividers between items, but not after the last one
                        if index < 9 {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer(minLength: 0)
            }
            .padding(.top, 16)
        }
    }
}

// MARK: - Individual Row Skeleton
struct SkeletonRowView: View {
    let index: Int
    // Varying widths to make the text placeholders look like natural, staggered titles
    let textWidths: [CGFloat] = [180, 260, 150, 280, 220, 170, 240, 190, 210, 160]
    
    var body: some View {
        HStack(spacing: 16) {
            // Hymn Title placeholder
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.25))
                .frame(width: textWidths[index % textWidths.count], height: 18)
                .shimmering()
            
            Spacer()
            
            // Right Chevron placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.25))
                .frame(width: 10, height: 14)
                .shimmering()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}

// MARK: - Adaptive Shimmer Effect Modifier
struct ShimmerEffect: ViewModifier {
    @State private var isAnimating = false
    @Environment(\.colorScheme) var colorScheme // Detect light/dark mode
    
    func body(content: Content) -> some View {
        // Use a much subtler opacity for the shimmer in dark mode
        let shimmerColor = colorScheme == .dark ? Color.white.opacity(0.15) : Color.white.opacity(0.6)
        
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            shimmerColor,
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width * 2)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - View Extension for easy use
extension View {
    /// Applies an animated shimmering effect to the view
    func shimmering() -> some View {
        self.modifier(ShimmerEffect())
    }
}
#Preview {
    ShimmerPlaceholderView()
}
