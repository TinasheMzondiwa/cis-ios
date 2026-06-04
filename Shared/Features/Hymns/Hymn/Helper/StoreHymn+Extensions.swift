//
//  StoreHymn+Extensions.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-06-03.
//

import Foundation

extension StoreHymn {
    func shareText(refrainLabel: String? = nil) -> String {
        var shareText = "\(number). \(title)\n\n"
        
        let allVerses = lyrics.filter { $0.type != "refrain" }
        let firstRefrain = lyrics.first { $0.type == "refrain" }
        
        var lyricsToPrint: [StoreLyric] = []
        if let firstVerse = allVerses.first {
            lyricsToPrint.append(firstVerse)
            if let firstRefrain {
                lyricsToPrint.append(firstRefrain)
            }
            if allVerses.count > 1 {
                lyricsToPrint.append(contentsOf: allVerses.dropFirst())
            }
        } else {
            lyricsToPrint = lyrics
        }
        
        let formattedLyrics = lyricsToPrint.map { lyric in
            var sectionText = ""
            if lyric.type == "refrain" {
                let label = refrainLabel ?? "Chorus"
                sectionText += "[\(label)]\n"
            } else if let index = lyric.index, index > 0 {
                sectionText += "\(index)\n"
            }
            sectionText += lyric.lines.joined(separator: "\n")
            return sectionText
        }
        
        shareText += formattedLyrics.joined(separator: "\n\n")
        return shareText
    }
}
