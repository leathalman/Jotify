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
        guard let url = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: group)?
                .appendingPathComponent(path) else {
            print("App group container unavailable for \(group); skipping read.")
            return "Error retrieving data"
        }
        do {
            let data = try Data(contentsOf: url)
            return String(data: data, encoding: .utf8) ?? "Error retrieving data"
        } catch {
            print("Error retrieving data from local file for widget. Maybe file doesn't exist?")
            return "Error retrieving data"
        }
    }

    static func writeData(path: String, content: String) {
        guard let url = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: group)?
                .appendingPathComponent(path) else {
            print("App group container unavailable for \(group); skipping write of \(path).")
            return
        }
        do {
            try Data(content.utf8).write(to: url)
        } catch {
            print("Failed to write \(path) to app group: \(error.localizedDescription)")
        }
    }
}
