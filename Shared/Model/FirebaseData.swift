//
//  FirebaseData.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/26.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

func checkAuth(completion: @escaping (Bool) ->()) {
    if (Auth.auth().currentUser == nil) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            let user = authResult?.user
            completion(user != nil)
        }
    } else {
        completion(true)
    }
}

func getHymnals(completion: @escaping ([RemoteHymnal])->()) {
    checkAuth(completion: { authenticated in
        if (!authenticated) {
            completion([])
            return
        }
        
        let ref = Database.database().reference()
        ref.child("cis").observe(DataEventType.value) { (snapshot) in
            var hymnals: [RemoteHymnal] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let hymnal = RemoteHymnal(snapshot: snapshot) {
                    hymnals.append(hymnal)
                }
            }
            
            print("Remote Hymns: \(hymnals.count)")
            let sorted = hymnals.sorted {
                $0.title ?? "" < $1.title ?? ""
            }
            completion(sorted)
        }
    })
}
