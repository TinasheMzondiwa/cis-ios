//
//  HymnInfoUIView.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-04-27.
//

import SwiftUI

struct HymnInfoUIView: View {
    
    @AppStorage("hymnalFontSize") private var fontSize: Double = 22.0
    @AppStorage("hymnalTypeface") private var selectedFontRaw: String = AppTypeface.defaultTypeface.rawValue
    
    let title: String
    let hymnNumber: Int
    let titleEnglish: String?
    let hymnalReferences: String?
    let bookKey: String
    
    @EnvironmentObject private var tunePlayer: TunePlayer
    
    var body: some View {
        let typeface = AppTypeface(rawValue: selectedFontRaw) ?? .defaultTypeface
        
        VStack(alignment: .center) {
            VStack {
                Text(hymnNumber.formatted())
                Text(title)
            }
            .font(typeface.font(size: fontSize + 4, weight: .bold))
            
            VStack {
                if let titleEnglish {
                    Text(titleEnglish)
                }
                
                if let hymnalReferences {
                    Text(hymnalReferences)
                }
            }
            .font(typeface.font(size: fontSize - 2, weight: .medium))
            .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
        .onAppear {
            tunePlayer.load(bookKey: bookKey, hymnNumber: hymnNumber, title: title)
        }
        .onChange(of: hymnNumber) { _, _ in
            tunePlayer.load(bookKey: bookKey, hymnNumber: hymnNumber, title: title)
        }
    }
}

#Preview {
    Group {
        HymnInfoUIView(
            title: "Letša Phalafala Moleti",
            hymnNumber: 1,
            titleEnglish: "Watchman, Blow The Gospel Trumpet",
            hymnalReferences: "AH 350 CH 613",
            bookKey: "sdah"
        )
        
        Divider()
        
        HymnInfoUIView(
            title: "Watchman, Blow The Gospel Trumpet",
            hymnNumber: 1,
            titleEnglish: nil,
            hymnalReferences: nil,
            bookKey: "christ_in_song"
        )
        
        Divider()
        
        HymnInfoUIView(
            title: "Letša Phalafala Moleti",
            hymnNumber: 1,
            titleEnglish: "Watchman, Blow The Gospel Trumpet",
            hymnalReferences: nil,
            bookKey: "sdah"
        )
    }
    .onAppear {
        // Load for previews if needed
    }
}
