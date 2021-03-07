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
        let versionShort: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let versionCode: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        
        if let short = versionShort as? String, let code = versionCode as? String {
            return "v\(short) (\(code))"
        } else {
            return ""
        }
    }
}
