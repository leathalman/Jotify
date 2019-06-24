//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailController: UIViewController {
    
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0
    
    var notes: [Note] = []
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var textView: UITextView = {
        let frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight)
        let textField = UITextView(frame: frame)
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.isEditable = true
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        textField.text = detailText
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(textView)
        
        fetchNotesFromCoreData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        updateContent(index: index, newContent: textView.text)
    }
    
    func fetchNotesFromCoreData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            notes = try managedContext.fetch(fetchRequest) as! [Note]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func updateContent(index: Int, newContent: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        notes[index].content = newContent
        appDelegate.saveContext()
    }
    
}
