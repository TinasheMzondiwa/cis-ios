//
//  XCTestCase+TrackForMemoryLeaks.swift
//  ChristInSongTests
//
//  Created by George Nyakundi on 23/03/2023.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, possible memory leak", file: file, line: line)
        }
    }
}
