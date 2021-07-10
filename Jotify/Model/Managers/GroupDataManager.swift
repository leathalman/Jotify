//
//  GroupDataManager.swift
//  Jotify
//
//  Created by Harrison Leath on 7/9/21.
//

import WidgetKit

//used to store data on-device to be read by the widget
class GroupDataManager {
    static private let group: String = "group.austinleath.Jotify.contents"
    
    //where path = "recentNoteContent" or "recentNoteColor" or "recentNoteDate"
    static func readData(path: String) -> String {
        let string: String = {
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent(path)
            let data = try! Data(contentsOf: url!)
            let string = String(data: data, encoding: .utf8)!
            return string
        }()
        return string
    }
    
    static func writeData(path: String, content: String) {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent(path)
        let data = Data(content.utf8)
        try! data.write(to: url!)
    }
}
