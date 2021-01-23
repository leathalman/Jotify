//
//  WidgetManager.swift
//  Jotify
//
//  Created by Harrison Leath on 12/12/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import UIKit
import WidgetKit

class WidgetManager {
    
    func updateWidgetToRecentNote() {
        GroupDataManager().writeData(path: "widgetDate", content: NoteData.notes.first?.dateString ?? "Date not found")
        GroupDataManager().writeData(path: "widgetContent", content: NoteData.notes.first?.content ?? "Example content")
        GroupDataManager().writeData(path: "widgetColor", content: NoteData.notes.first?.color ?? "blue2")
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func createSampleData() {
        GroupDataManager().writeData(path: "widgetContent", content: "Have you written a note yet? You should do that.")
        GroupDataManager().writeData(path: "widgetColor", content: UIColor.stringFromColor(color: UIColor.blue2))
        GroupDataManager().writeData(path: "widgetDate", content: "July 2, 2002")
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
