//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField
import CoreData

class WriteNoteController: UIViewController, UITextViewDelegate {
    
    let writeNoteView = WriteNoteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = writeNoteView
        
        writeNoteView.inputTextView.delegate = self
    }
    
    @objc func handleSend() {
        
        if writeNoteView.inputTextView.text == "" {
            
        } else {
            StoredColors.noteColorString = Colors.stringFromColor(color: StoredColors.noteColor)
            
            let date = Date.timeIntervalSinceReferenceDate
            saveNote(content: writeNoteView.inputTextView.text, color: StoredColors.noteColorString, date: date)
            writeNoteView.inputTextView.text = ""
        }
    }
    
    func saveNote(content: String, color: String, date: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
        note.setValue(content, forKeyPath: "content")
        note.setValue(color, forKey: "color")
        note.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        //dismiss keyboard on return key
        textView.resignFirstResponder()
        handleSend()
        
        writeNoteView.getRandomColor()
        
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
