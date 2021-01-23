//
//  Double+Date.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import Foundation

extension Double {
    //change double into formatted date
    func getDate() -> String {
        let updateDate = Date(timeIntervalSinceReferenceDate: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: updateDate)
    }
}
