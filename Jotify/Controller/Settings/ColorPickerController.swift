//
//  ColorPickerController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import ChromaColorPicker
import CoreData

class ColorPickerController: UIViewController {
    
    var notes: [Note] = []
    
    lazy var colorPicker: ChromaColorPicker = {
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPicker.delegate = self
        colorPicker.padding = 5
        colorPicker.stroke = 3
        colorPicker.hexLabel.textColor = UIColor.black
        colorPicker.center = self.view.center
        return colorPicker
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        contentView.center = self.view.center
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 15
        return contentView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
        setupClearNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        var image = UIImage(named: "cancel")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(handleCancel))
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.addSubview(contentView)
        view.addSubview(colorPicker)
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupClearNavigationBar() {
        guard self.navigationController?.topViewController === self else { return }
        self.transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.backgroundColor = .clear
            self?.navigationController?.navigationBar.barTintColor = .clear
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }, completion: nil)
    }
    
    func setStaticColorForNotes() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let writeNoteView = WriteNoteView()
        var newBackgroundColor = UIColor.white
        
        for note in notes {
            var newColor = String()
            
            if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
                newColor = "staticNoteColor"
                newBackgroundColor = UserDefaults.standard.color(forKey: "staticNoteColor") ?? UIColor.white
            }
            
            note.color = newColor
        }
        
        writeNoteView.colorView.backgroundColor = newBackgroundColor
        
        appDelegate.saveContext()
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            notes = try managedContext.fetch(fetchRequest) as! [Note]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
}

extension ColorPickerController: ChromaColorPickerDelegate{
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        view.backgroundColor = color
        
        UserDefaults.standard.set(color, forKey: "staticNoteColor")
        setStaticColorForNotes()
        
        StoredColors.staticNoteColor = color

        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { (done) in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.transform = CGAffineTransform.identity
                
                self.colorPicker.hexLabel.textColor = UIColor.white

                self.contentView.backgroundColor = UIColor.grayBlur
                self.contentView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                self.contentView.center = self.view.center
                
            })
        })
    }
}
