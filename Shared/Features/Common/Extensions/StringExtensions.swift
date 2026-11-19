//
//  StringExtensions.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/08/05.
//

import Foundation
import SwiftUI

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(data: data,
                                                                 options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                                                                 documentAttributes: nil)
            let string = NSMutableAttributedString(attributedString: attributedString)
            
            
            string.addAttributes([.foregroundColor: UIColor.label,
                                  .font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)],
                                 range: NSRange(location: 0, length: attributedString.length))
            return string
        } catch {
            return nil
        }
    }
    
    var noHTML: String {
        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return str
    }
    
    func isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    var titleStr: String {
        return self.replacingOccurrences( of:"[0-9]", with: "", options: .regularExpression)
            .replacingOccurrences(of: ". ", with: "")
            .replacingOccurrences(of: "- ", with: "")
            .replacingOccurrences(of: ": ", with: "")
            .trimmed
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Normalizes text for search by folding case/diacritics, removing apostrophes,
    /// stripping punctuation (commas, periods, hyphens, etc.), and collapsing whitespace.
    var normalizedForSearch: String {
        let folded = self.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
        var scalars = String.UnicodeScalarView()
        scalars.reserveCapacity(folded.unicodeScalars.count)
        var lastWasSpace = true
        
        for scalar in folded.unicodeScalars {
            if scalar == "'" || scalar == "\u{2019}" || scalar == "\u{2018}" {
                continue
            } else if CharacterSet.alphanumerics.contains(scalar) {
                scalars.append(scalar)
                lastWasSpace = false
            } else if !lastWasSpace {
                scalars.append(" ")
                lastWasSpace = true
            }
        }
        
        var result = String(scalars)
        if result.hasSuffix(" ") {
            result.removeLast()
        }
        return result
    }
}
