//
//  Double+Date.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import Foundation

extension Double {
    //change double into formatted date, ex: January 1, 2021
    func getDate() -> String {
        let updateDate = Date(timeIntervalSinceReferenceDate: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: updateDate)
    }
}

extension Date {
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
