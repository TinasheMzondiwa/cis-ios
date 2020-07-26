//
//  RemoteHymnal.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/26.
//

import Foundation
import FirebaseDatabase

struct RemoteHymnal: Hashable, Codable {

    var key: String
    var title: String?
    var language: String?
    
    init(key: String, title: String, language: String) {
        self.key = key
        self.title = title
        self.language = language
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let language = value["language"] as? String
        
            else {
                return nil
            }
        
        self.key = snapshot.key
        self.title = title
        self.language = language
    }
}
