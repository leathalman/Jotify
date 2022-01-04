//
//  NoteModel.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import Foundation

class NoteCollection {
    //model for array of firebase notes
    var FBNotes: [FBNote] = []
}

//model for a firebase note
//"note" is reserved for deprecated implementation of CloudKit notes
struct FBNote {
    var content: String
    var timestamp: Double
    var id: String
    var color: String
    var reminder: String?
    var reminderTimestamp: Double?
}

