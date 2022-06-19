//
//  Constants.swift
//  ChristInSong
//
//  Created by Tinashe  on 2021/02/23.
//

import Foundation

struct Constants {
    static let hymnalKey = "hymnal"
    static let hymnalTitleKey = "hymnalTitle"
    
    static let defHymnal = "english"
    static let defHymnalTitle = "Christ In Song"
    
    
    static func getAppVersion() -> String {
        let versionString = Bundle.versionString
        let versionCode = Bundle.versionCode
        
        if !versionString.isEmpty && !versionCode.isEmpty {
            return "v\(versionString) (\(versionCode))"
        } else {
            return ""
        }
    }
}
