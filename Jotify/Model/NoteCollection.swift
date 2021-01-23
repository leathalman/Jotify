//
//  NoteModel.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import Foundation

class NoteCollection {
    var notes: [Note] = []
}

struct Note {
    var content: String
    var timestamp: Double
    var uid: String
}

