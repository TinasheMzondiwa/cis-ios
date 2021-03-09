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
            return NSLocalizedString("Collections.Add", comment: "Add prompt")
        case .create:
            return NSLocalizedString("Collections.New", comment: "New prompt")
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
            return NSLocalizedString("Common.New", comment: "New")
        case .create:
            return NSLocalizedString("Common.Save", comment: "Save")
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
