//
//  tvOSUITests.swift
//  tvOSUITests
//
//

import XCTest

@MainActor
final class tvOSUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["-UITesting"]
        app.launch()
    }
    
    func testCaptureTvOSScreenshots() throws {
        // Wait for Core Data store loading to complete
        sleep(5)
        
        // 1. Move focus from sidebar into Home content and capture TV Home screen
        XCUIRemote.shared.press(.right)
        sleep(2)
        snapshot("01_TV_Home")
        
        // 2. Open focused hymn (Praise to the Lord) to capture full 10-foot Lyrics view
        XCUIRemote.shared.press(.select)
        sleep(2)
        snapshot("02_TV_Lyrics")
        
        // 3. Dismiss lyrics and move left to capture Sidebar navigation
        XCUIRemote.shared.press(.menu)
        sleep(2)
        XCUIRemote.shared.press(.left)
        sleep(2)
        snapshot("03_TV_Sidebar")
    }
}
