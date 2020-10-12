//
//  GroupDataManager.swift
//  Jotify
//
//  Created by Harrison Leath on 10/12/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import Foundation

//used to store data on-device to be read by the widget
class GroupDataManager {
    let group: String = "group.austinleath.Jotify.contents"
    
    //where path = "widgetContent" or "widgetColor" or "widgetDate"
    func readData(path: String) -> String {
        let string: String = {
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent(path)
            let data = try! Data(contentsOf: url!)
            let string = String(data: data, encoding: .utf8)!
            return string
        }()
        return string
    }
    
    func writeData(path: String, content: String) {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent(path)
        let data = Data(content.utf8)
        try! data.write(to: url!)
    }
}
