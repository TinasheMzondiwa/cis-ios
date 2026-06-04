//
//  SupportBannerView.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-06-04.
//

import SwiftUI

struct SupportBannerView: View {
    let action: () -> Void
    
    private let preciseMessages = [
        "Help keep Christ in Song ad-free and support our annual developer fees.",
        "Blessed by this ad-free hymnal? Consider a small tip to support maintenance.",
        "Keep our mission going. Consider a small gift to cover annual app fees.",
        "Proudly ad-free. Tap here to support the continued maintenance of this app."
    ]
    
    // Changes the text subtly based on the day of the year to prevent daily visual stagnation
    private var timedMessage: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % preciseMessages.count
        return preciseMessages[index]
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            //            Image(systemName: "heart.circle.fill")
            //                .font(.system(size: 24))
            //                .foregroundColor(.accentColor)
            
            ZStack {
                Circle()
                    .fill(Color.teal.opacity(0.15)) // Light green background circle tint
                    .frame(width: 30, height: 30)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.teal) // Matches your custom heart icon design
            }
            
            Text(timedMessage)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(.systemGray3))
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    SupportBannerView(action: {})
}
