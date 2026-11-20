//
//  iOSUITests.swift
//  ChristInSongUITests
//
//

import XCTest

@MainActor
final class iOSUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["-UITesting", "-AppleLanguages", "(en)", "-AppleLocale", "en_US", "-AppleInterfaceStyle", "Dark"]
        app.launch()
    }
    
    func testCaptureAppStoreScreenshots() throws {
        let app = XCUIApplication()
        
        // 1. Home / Hymn List
        snapshot("01_HymnList")
        
        // 2. Open first hymn to capture lyrics / reading view
        let hymnCell = app.cells.matching(NSPredicate(format: "label CONTAINS[c] 'Watchman'")).firstMatch
        if hymnCell.waitForExistence(timeout: 5) {
            hymnCell.tap()
        } else if app.cells.count > 1 {
            app.cells.element(boundBy: 1).tap()
        }
        sleep(2)
        snapshot("02_HymnDetail")
        
        // Navigate back to list
        let backButton = app.navigationBars.buttons.firstMatch
        if backButton.waitForExistence(timeout: 3) {
            backButton.tap()
            sleep(1)
        }
        
        // 3. Navigate to Collections tab
        let collectionsTab = app.tabBars.buttons["Collections"]
        if collectionsTab.waitForExistence(timeout: 3) {
            collectionsTab.tap()
            sleep(1)
            snapshot("03_Collections")
            
            // Switch back to Hymns tab
            let hymnsTab = app.tabBars.buttons["Hymns"]
            if hymnsTab.waitForExistence(timeout: 3) {
                hymnsTab.tap()
                sleep(1)
            }
        }
        
        // 4. Open Hymnal list (shows all available hymnals)
        let bookButton = app.buttons["hymnal_picker_button"]
        if bookButton.waitForExistence(timeout: 3) {
            bookButton.tap()
        } else {
            let navTitleButton = app.navigationBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Christ In Song'")).firstMatch
            if navTitleButton.waitForExistence(timeout: 3) {
                navTitleButton.tap()
            }
        }
        sleep(2)
        snapshot("04_HymnalPicker")
    }
}
