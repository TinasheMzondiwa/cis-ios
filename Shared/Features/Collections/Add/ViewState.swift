//
//  ViewState.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import Foundation
import SwiftUI

enum ViewState {
    case add
    case create
}

extension ViewState {
    var title: String {
        switch self {
        case .add:
            return "Add to Collection"
        case .create:
            return "New Collection"
        }
    }
    
    var navigation: SFSymbol {
        switch self {
        case .add:
            return SFSymbol.close
        case .create:
            return SFSymbol.arrowBackward
        }
    }
    
    var actionTitle: String {
        switch self {
        case .add:
            return "NEW"
        case .create:
            return "SAVE"
        }
    }
    
    var actionIcon: SFSymbol {
        switch self {
        case .add:
            return SFSymbol.plus
        case .create:
            return SFSymbol.checkmark
        }
    }
}
