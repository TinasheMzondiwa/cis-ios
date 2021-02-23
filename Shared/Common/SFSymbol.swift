//
//  SFSymbol.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/20.
//

import Foundation
import SwiftUI

enum SFSymbol: String, View {
    case bookCircle = "book.circle"
    case close = "xmark"
    case checkmark = "checkmark"
    case search = "magnifyingglass"
    case textPlus = "text.badge.plus"
    case xmark = "xmark.circle.fill"
    
    var body: Image {
        Image(systemName: rawValue)
    }
}
