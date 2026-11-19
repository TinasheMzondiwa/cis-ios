//
//  TVScriptureCatalogTests.swift
//  ChristInSongTests
//
//

import XCTest

final class TVScriptureCatalogTests: XCTestCase {
    
    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }
    
    private func makeDate(year: Int = 2026, month: Int = 11, day: Int = 19, hour: Int, minute: Int = 0) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components)!
    }
    
    // MARK: - Sabbath Detection Tests
    
    func test_isSabbathHours_onFridayBefore17_returnsFalse() {
        // Friday Nov 20, 2026 at 16:59
        let date = makeDate(year: 2026, month: 11, day: 20, hour: 16, minute: 59)
        XCTAssertFalse(TVScriptureCatalog.isSabbathHours(date: date, calendar: calendar))
    }
    
    func test_isSabbathHours_onFridayAtOrAfter17_returnsTrue() {
        // Friday Nov 20, 2026 at 17:00 and 20:00
        let date17 = makeDate(year: 2026, month: 11, day: 20, hour: 17, minute: 0)
        let date20 = makeDate(year: 2026, month: 11, day: 20, hour: 20, minute: 0)
        
        XCTAssertTrue(TVScriptureCatalog.isSabbathHours(date: date17, calendar: calendar))
        XCTAssertTrue(TVScriptureCatalog.isSabbathHours(date: date20, calendar: calendar))
    }
    
    func test_isSabbathHours_onSaturdayMorningAndMidday_returnsTrue() {
        // Saturday Nov 21, 2026 at 09:00 and 14:00
        let dateMorning = makeDate(year: 2026, month: 11, day: 21, hour: 9, minute: 0)
        let dateMidday = makeDate(year: 2026, month: 11, day: 21, hour: 14, minute: 0)
        
        XCTAssertTrue(TVScriptureCatalog.isSabbathHours(date: dateMorning, calendar: calendar))
        XCTAssertTrue(TVScriptureCatalog.isSabbathHours(date: dateMidday, calendar: calendar))
    }
    
    func test_isSabbathHours_onSaturdayAfter17_returnsFalse() {
        // Saturday Nov 21, 2026 at 17:00
        let dateAfter17 = makeDate(year: 2026, month: 11, day: 21, hour: 17, minute: 0)
        XCTAssertFalse(TVScriptureCatalog.isSabbathHours(date: dateAfter17, calendar: calendar))
    }
    
    func test_isSabbathHours_onSunday_returnsFalse() {
        // Sunday Nov 22, 2026 at 10:00
        let dateSunday = makeDate(year: 2026, month: 11, day: 22, hour: 10, minute: 0)
        XCTAssertFalse(TVScriptureCatalog.isSabbathHours(date: dateSunday, calendar: calendar))
    }
    
    // MARK: - Scripture Selection Tests
    
    func test_todayScripture_duringSabbathHours_returnsSabbathCategory() {
        // Friday Nov 20, 2026 at 19:00 (Sabbath)
        let date = makeDate(year: 2026, month: 11, day: 20, hour: 19, minute: 0)
        let scripture = TVScriptureCatalog.todayScripture(date: date, calendar: calendar)
        
        XCTAssertEqual(scripture.category, .sabbath)
        XCTAssertEqual(scripture.category.badgeTitle, "Sabbath Praise")
    }
    
    func test_todayScripture_inAfternoon_neverReturnsMorningScripture() {
        // Test multiple non-Sabbath weekdays at 14:00 (2:00 PM)
        // Verify that throughout the year, afternoon NEVER serves a .morning verse
        for day in 1...28 {
            // Thursday Feb <day>, 2026
            let afternoonDate = makeDate(year: 2026, month: 2, day: day, hour: 14, minute: 0)
            let scripture = TVScriptureCatalog.todayScripture(date: afternoonDate, calendar: calendar)
            
            XCTAssertNotEqual(
                scripture.category,
                .morning,
                "Afternoon should never return a morning devotion scripture for day \(day): got \(scripture.reference)"
            )
        }
    }
    
    func test_todayScripture_inEvening_neverReturnsMorningScripture() {
        // Test multiple non-Sabbath weekdays at 20:00 (8:00 PM)
        // Verify that throughout the year, evening NEVER serves a .morning verse
        for day in 1...28 {
            let eveningDate = makeDate(year: 2026, month: 3, day: day, hour: 20, minute: 0)
            let scripture = TVScriptureCatalog.todayScripture(date: eveningDate, calendar: calendar)
            
            XCTAssertNotEqual(
                scripture.category,
                .morning,
                "Evening should never return a morning devotion scripture for day \(day): got \(scripture.reference)"
            )
        }
    }
    
    func test_todayScripture_inMorning_neverReturnsEveningScripture() {
        // Test multiple non-Sabbath weekdays at 08:00 (8:00 AM)
        for day in 1...28 {
            let morningDate = makeDate(year: 2026, month: 4, day: day, hour: 8, minute: 0)
            let scripture = TVScriptureCatalog.todayScripture(date: morningDate, calendar: calendar)
            
            XCTAssertNotEqual(
                scripture.category,
                .evening,
                "Morning should never return an evening praise scripture for day \(day): got \(scripture.reference)"
            )
        }
    }
    
    func test_todayScripture_isDeterministicForSameDate() {
        let fixedDate = makeDate(year: 2026, month: 11, day: 19, hour: 10, minute: 0)
        let scripture1 = TVScriptureCatalog.todayScripture(date: fixedDate, calendar: calendar)
        let scripture2 = TVScriptureCatalog.todayScripture(date: fixedDate, calendar: calendar)
        
        XCTAssertEqual(scripture1, scripture2)
    }
}
