//
//  Double+Date.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import Foundation

extension Double {
    // Cached formatter. `DateFormatter.init` is expensive (ICU + locale
    // lookup, ~1–3ms each), and this is called once per cell on every scroll
    // pass — enough to drop frames during overscroll bounces. `DateFormatter`
    // is thread-safe for reading since iOS 7, so a single shared instance is
    // fine.
    private static let longDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeZone = .current
        return f
    }()

    //change double into formatted date, ex: January 1, 2021
    func getDate() -> String {
        return Double.longDateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self))
    }
}

extension String {
    //change formatted date string into timestamp
    func getTimestamp() -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dateString = dateFormatter.date(from: self)
        let dateTimestamp = dateString!.timeIntervalSinceReferenceDate
        return dateTimestamp
    }
}

extension Date {
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
