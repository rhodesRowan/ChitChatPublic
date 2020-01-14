//
//  DatechitChatTests.swift
//  chitChatTests
//
//  Created by Rowan Rhodes on 13/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import XCTest
@testable import chitChat

class DatechitChatTests: XCTestCase {

    func testDatefromString() {
        let dateToTest = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (60*60*3)) // three hours before the current time
        let formattedDate = Date.convertDateToString(date: dateToTest)
        XCTAssertEqual(formattedDate, "11:35")
    }
    
    func testDaysSinceDate() {
        let dateToTest = Date(timeIntervalSince1970: 1578486061)
        let daysSinceDate = Date.getDaysSinceDate(date: dateToTest, calender: Calendar.current, dateFormatter: DateFormatter())
        XCTAssertEqual(daysSinceDate, "Wednesday")
    }

}
