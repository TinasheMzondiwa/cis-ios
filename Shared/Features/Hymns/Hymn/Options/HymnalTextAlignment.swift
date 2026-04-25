//
//  HymnalTextAlignment.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-04-25.
//

import SwiftUI

enum HymnalTextAlignment: String, CaseIterable, Identifiable {
    case leading, center, trailing
    
    var id: String { rawValue }
    
    var textAlignment: TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
    
    var horizontalAlignment: HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
    
    var frameAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
    
    var icon: String {
        switch self {
        case .leading: return "text.alignleft"
        case .center: return "text.aligncenter"
        case .trailing: return "text.alignright"
        }
    }
}
