//
//  Bundle+Extensions.swift
//  iOS
//
//  Created by George Nyakundi on 19/06/2022.
//

import Foundation

extension Bundle {
    static var versionString: String {
        return Self.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static var versionCode: String {
        return Self.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
