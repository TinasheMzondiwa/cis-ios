//
//  SwipeEducationCard.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-06-04.
//

import SwiftUI

struct SwipeEducationCard: View {
    var onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Context Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 42, height: 42)
                
                Image(systemName: "hand.draw.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.purple)
            }
            
            // Text Guidance
            VStack(alignment: .leading, spacing: 4) {
                Text("Tip: Swipe to Pin")
                    .font(.system(size: 16, weight: .semibold))
                Text("Swipe left on any hymnal to quickly pin it to the top of your list.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Explicit Dismiss Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    onDismiss()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.8))
                    .padding(8)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .swipeToPin(isPinned: false, forTip: true) {
            withAnimation(.spring()) {
                onDismiss()
            }
        }
    }
}

#Preview {
    SwipeEducationCard {
        
    }
    .padding()
}
