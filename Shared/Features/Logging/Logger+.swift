//
//  Logger+.swift
//  iOS
//
//  Created by George Nyakundi on 17/11/2024.
//

import Foundation
import OSLog

extension String {
    static let subsystem = Bundle.main.bundleIdentifier ?? ""
    static let categoryCoreDatastore = "ciscoredatastore"
    static let categoryFileloader = "fileloader"
}
