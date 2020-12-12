//
//  Date+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 12/12/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import Foundation

extension Double {
    func formattedString() -> String {
        let updateDate = Date(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: updateDate)
    }
}
