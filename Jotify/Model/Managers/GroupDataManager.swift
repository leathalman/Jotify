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
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent(path)
        do {
            let data = try Data(contentsOf: url!)
            let string = String(data: data, encoding: .utf8)!
            return string
        } catch {
            print("Error retrieving data from local file for widget. Maybe file doesn't exist?")
            return "Error retrieving data"
        }
    }
    
    static func writeData(path: String, content: String) {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent(path)
        let data = Data(content.utf8)
        try! data.write(to: url!)
    }
}
