//
//  SFSymbol.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/20.
//

import Foundation
import SwiftUI

enum SFSymbol: String, View {
    case arrowBackward = "arrow.backward"
    case bookCircle = "book.circle"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    case close = "xmark"
    case checkmark = "checkmark"
    case musicNote = "music.note"
    case plus = "plus"
    case search = "magnifyingglass"
    case textPlus = "text.badge.plus"
    case xmarkFill = "xmark.circle.fill"
    
    var body: Image {
        Image(systemName: rawValue)
    }
}
