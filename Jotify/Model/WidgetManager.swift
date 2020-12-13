//
//  WidgetManager.swift
//  Jotify
//
//  Created by Harrison Leath on 12/12/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import WidgetKit

class WidgetManager {
    
    func updateWidgetToRecentNote() {
        GroupDataManager().writeData(path: "widgetDate", content: NoteData.notes.first?.dateString ?? "Date not found 2")
        GroupDataManager().writeData(path: "widgetContent", content: NoteData.notes.first?.content ?? "Example content")
        GroupDataManager().writeData(path: "widgetColor", content: NoteData.notes.first?.color ?? "blue2")
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
