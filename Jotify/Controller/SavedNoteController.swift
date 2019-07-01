//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import Blueprints
import ViewAnimator
import XLActionController

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    
    var firstLaunch: Int = 0
    var pressed: Int = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    let loadingAnimations = [AnimationType.from(direction: .top, offset: 30.0)]

    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        firstLaunch = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchNotesFromCoreData()
        
        if firstLaunch == 1{
            animateCells()
            firstLaunch = 2
        }
        
//        self.navigationController?.delegate = self
    }
 
    func setupView() {
        navigationItem.title = "Saved Notes"
        navigationController?.navigationBar.prefersLargeTitles = false
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"), style: .plain, target: self, action: #selector(handleRightButton))
        navigationItem.rightBarButtonItem  = rightItem
        
        collectionView.frame = self.view.frame
        collectionView.backgroundColor = UIColor(named: "viewBackgroundColor")
        collectionView.setCollectionViewLayout(blueprintLayout, animated: true)
        collectionView.alwaysBounceVertical = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        view.addSubview(collectionView)
        
        setupSearchBar()
        setupSwipes()
    }
    
    @objc func handleRightButton() {
        
        //change this to based on UserDefualts instead of pressed, because you can start with sort by content and then the button doesnt to anything
        
        if pressed == 0 {
            print("Sort by content")
            UserDefaults.standard.set("content", forKey: "sortBy")
            pressed += 1
            
        } else if pressed == 1 {
            print("Sort by color")
            UserDefaults.standard.set("color", forKey: "sortBy")
            pressed += 1
            
        } else if pressed == 2 {
            print("Sort by date")
            UserDefaults.standard.set("date", forKey: "sortBy")
            pressed = 0
            
        }
        
        if UIDevice.current.hasTapticEngine == true {
            //iPhone 6s and iPhone 6s Plus
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSoundWithCompletion(peek, nil)
            
        } else if UIDevice.current.hasHapticFeedback == true {
            //iPhone 7 and newer
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        fetchNotesFromCoreData()
        animateCells()
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            tabBarController?.selectedIndex = 1
            
        } else if gesture.direction == .right {
        }
    }
    
    func setupSwipes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        view.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        view.isUserInteractionEnabled = true
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNotes = notes.filter({( note : Note) -> Bool in
            return (note.content?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        collectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func fetchNotesFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortBy = UserDefaults.standard.string(forKey: "sortBy")
        var sortDescriptor: NSSortDescriptor?
        
        if sortBy == "content" {
            sortDescriptor = NSSortDescriptor(key: "content", ascending: true)
            
        } else if sortBy == "date" {
            sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            
        } else if sortBy == "color" {
            sortDescriptor = NSSortDescriptor(key: "color", ascending: false)
            
        }

        fetchRequest.sortDescriptors = [sortDescriptor] as? [NSSortDescriptor]
        
        do {
            notes = try managedContext.fetch(fetchRequest) as! [Note]
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func animateCells() {
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells, animations: loadingAnimations, completion: {
            })
        }, completion: nil)
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        print("Tap triggered")

        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let rowNumber : Int = indexPath?.row ?? 0

        let noteDetailController = NoteDetailController()

        var note = notes[indexPath?.row ?? 0]

        if isFiltering() {
            note = filteredNotes[indexPath?.row ?? 0]
            noteDetailController.filteredNotes = filteredNotes
            noteDetailController.isFiltering = true

        } else {
            note = notes[indexPath?.row ?? 0]
            noteDetailController.notes = notes
        }

        let date = note.value(forKey: "date")
        let color = note.value(forKey: "color") as! String
        let content = note.value(forKey: "content") as! String

        let updateDate = Date(timeIntervalSinceReferenceDate: date as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)

        noteDetailController.navigationController?.navigationItem.title = dateString
        noteDetailController.navigationTitle = dateString

        var cellColor: UIColor = .white
        cellColor = Colors.colorFromString(string: color)
        
        noteDetailController.backgroundColor = cellColor
        noteDetailController.detailText = content
        noteDetailController.index = rowNumber
        
//        noteDetailController.hidesBottomBarWhenPushed = true

//        present(noteDetailController, animated: true, completion: nil)
        navigationController?.pushViewController(noteDetailController, animated: true)
        
    }
    
    @objc func longTouchHandler(sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let rowNumber : Int = indexPath?.row ?? 0
        
        let note = notes[indexPath?.row ?? 0]
        let color = note.value(forKey: "color") as! String
        var cellColor = UIColor(red: 18/255.0, green: 165/255.0, blue: 244/255.0, alpha: 1.0)
        cellColor = Colors.colorFromString(string: color)

//        if UIDevice.current.hasTapticEngine == true {
//            //iPhone 6s and iPhone 6s Plus
//            let peek = SystemSoundID(1519)
//            AudioServicesPlaySystemSoundWithCompletion(peek, nil)
//
//        } else if UIDevice.current.hasHapticFeedback == true {
//            //iPhone 7 and newer
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()
//        }
        
        let actionController = SkypeActionController()
        actionController.backgroundColor = cellColor
        
        actionController.addAction(Action("Take photo", style: .default, handler: { action in
        }))
        actionController.addAction(Action("Delete Note", style: .default, handler: { action in
            print("1")
            self.deleteNote(indexPath: indexPath ?? [0, 0], int: rowNumber)
        }))
        actionController.addAction(Action("Remove profile picture", style: .default, handler: { action in
        }))
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
    
    func deleteNote(indexPath: IndexPath, int: Int) {
        let note = notes[indexPath.row]
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //delete from Core Data storage
        managedContext.delete(note)
        
        //delete from array so that UICollectionView displays cells correctly
        notes.remove(at: int)
        
        appDelegate.saveContext()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredNotes.count
        } else {
            return notes.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
        
        var note = notes[indexPath.row]
        
        if isFiltering() {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        
        let content = note.value(forKey: "content") as? String
        let color = note.value(forKey: "color") as? String ?? "white"
        let date = note.value(forKey: "date") as? Double ?? 0

        cell.textLabel.text = content?.trunc(length: 55)
        cell.textLabel.textColor = UIColor.white
        cell.dateLabel.textColor = UIColor.white

        let updateDate = Date(timeIntervalSinceReferenceDate: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)
        cell.dateLabel.text = dateString
        
        let cellColor = Colors.colorFromString(string: color)
        
        if cellColor == UIColor.white {
            cell.textLabel.textColor = .black
            cell.dateLabel.textColor = .black
        }
        
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.backgroundColor = cellColor
        cell.layer.addShadow(color: UIColor.darkGray)
        
        cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:))))
        cell.contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTouchHandler(sender:))))
        
        return cell
    }
}

extension SavedNoteController: CollectionViewFlowLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 110
        
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}

extension SavedNoteController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

//extension SavedNoteController: UINavigationControllerDelegate {
//
//    internal func navigationController(_ navigationController: UINavigationController,
//                                      animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch operation {
//        case .push:
//            return PopAnimator()
//        case .pop:
//            return SystemPopAnimator(type: .navigation)
//        default:
//            return nil
//        }
//    }
//}
