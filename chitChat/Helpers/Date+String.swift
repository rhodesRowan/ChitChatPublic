//
//  Date+Extension.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK:- Public
    static func convertDateToDayDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calender = Calendar.current
        if calender.isDateInToday(date) {
            return "Today"
        } else if calender.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return getDaysSinceDate(date: date, calender: calender, dateFormatter: dateFormatter)
        }
    }
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calender = Calendar.current
        if calender.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else if calender.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return getDaysSinceDate(date: date, calender: calender, dateFormatter: dateFormatter)
        }
    }
    
    static func getDaysSinceDate(date: Date, calender: Calendar, dateFormatter: DateFormatter) -> String {
        let startOfNow = calender.startOfDay(for: Date())
        let startOfTimestamp = calender.startOfDay(for: date)
        dateFormatter.dateStyle = .short
        let components = calender.dateComponents([.day], from: startOfNow, to: startOfTimestamp)
        guard let day = components.day else { return dateFormatter.string(from: date) }
        if day > -7  && day < 0 {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        return dateFormatter.string(from: date)
    }

}
