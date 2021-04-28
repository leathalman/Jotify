//
//  NoteCollectionController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit
import Blueprints
import SwiftMessages

class NoteCollectionController: UICollectionViewController {
    //update collection view when model changes
    var noteCollection: NoteCollection? {
        didSet {
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
    //global instance of searchController for NoteCollectionController
    let searchController = UISearchController(searchResultsController: nil)
    
    //layouts for collectionView
    let iOSLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    let iPadOSLayout = VerticalBlueprintLayout(
        itemsPerRow: 3.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    //life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
        handleStatusBarStyle(style: .darkContent)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    //view configuration
    func setupViewElements() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView.setCollectionViewLayout(iPadOSLayout, animated: true)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.setCollectionViewLayout(iOSLayout, animated: true)
        }
        
        //navigation bar item customization
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleLeftNavButton))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.setHidesBackButton(true, animated: true)
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(handleRightNavButton))
        navigationItem.rightBarButtonItem = rightItem
        
        collectionView.backgroundColor = ColorManager.bgColor
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Saved Notes"
        navigationController?.enablePersistence()
        navigationController?.setColor(color: ColorManager.bgColor)
        navigationController?.navigationBar.titleTextAttributes = nil
    }
    
    //action handlers
    @objc func longTouchHandler(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)
        let note = noteCollection?.FBNotes[indexPath!.row]
        
        let menu: NoteOptionMenu = try! SwiftMessages.viewFromNib(named: "NoteOptionMenu")
        menu.configureBackgroundView(width: 250)
        
        //configure title and actions
        menu.titleLabel?.text = "Options"
        menu.button1.setTitle("Share Note", for: .normal)
        menu.button2.setTitle("Delete Note", for: .normal)
        menu.button3.setTitle("Select Multiple", for: .normal)
        menu.button4.setTitle("Cancel", for: .normal)
        
        menu.titleLabel?.font = .boldSystemFont(ofSize: 24)
        menu.button1.titleLabel?.font = .boldSystemFont(ofSize: 16)
        menu.button2.titleLabel?.font = .boldSystemFont(ofSize: 16)
        menu.button3.titleLabel?.font = .boldSystemFont(ofSize: 16)
        menu.button4.titleLabel?.font = .boldSystemFont(ofSize: 16)

        menu.button1.addTarget(self, action: #selector(shareNoteFromMenu(_:)), for: .touchUpInside)
        menu.button1.params["content"] = note?.content
        menu.button2.addTarget(self, action: #selector(deleteNoteFromMenu(_:)), for: .touchUpInside)
        menu.button2.params["id"] = note?.id
        menu.button4.addTarget(self, action: #selector(cancelOptionFromMenu), for: .touchUpInside)
        
        menu.backgroundView.backgroundColor = ColorManager.bgColor
        menu.backgroundView.layer.cornerRadius = 10
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: menu)
    }
    
    @objc func handleLeftNavButton() {
        //initialize settings controller and pass note collection for theme changing
        let vc = GeneralSettingsController(style: .insetGrouped)
        vc.noteCollection = noteCollection
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.modalPresentationStyle = .formSheet
            navigationController?.present(vc, animated: true, completion: nil)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func handleRightNavButton() {
        let rootVC = self.getRootViewController() as! PageBoyController
        rootVC.scrollToWriteNoteController()
    }
    
    //NoteOptionMenu Actions
    @objc func deleteNoteFromMenu(_ sender: PassableUIButton) {
        DataManager.deleteNote(docID: sender.params["id"] as! String) { (success) in
            if success! {
                AnalyticsManager.logEvent(named: "note_deleted", description: "note_deleted")
            }
        }
        SwiftMessages.hide()
    }
    
    @objc func shareNoteFromMenu(_ sender: PassableUIButton) {
        let objectsToShare = [sender.params["content"]]
        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]

        //required properties for iPad's popoverPresentationController, otherwise crash
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        self.present(activityVC, animated: true, completion: nil)
        AnalyticsManager.logEvent(named: "share_note", description: "share_note")
        SwiftMessages.hide()
    }
    
    @objc func cancelOptionFromMenu() {
        SwiftMessages.hide()
    }
    
    //collectionView Logic
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //noteCollection.notes.count will return nil if no notes exist on launch, will return 0 if user deletes a note
        //and num of objs in array go to 0
        if (noteCollection?.FBNotes.count == nil) || (noteCollection?.FBNotes.count == 0) {
            collectionView.backgroundView = EmptyNoteView()
        } else {
            //remove backgroundView if array of notes isn't empty
            collectionView.backgroundView = nil
        }
        
        return noteCollection?.FBNotes.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else { fatalError("Wrong cell class dequeued") }
        
        cell.textLabel.text = noteCollection?.FBNotes[indexPath.row].content
        cell.dateLabel.text = noteCollection?.FBNotes[indexPath.row].timestamp.getDate()
        cell.backgroundColor = noteCollection?.FBNotes[indexPath.row].color.getColor()
        
        cell.layer.cornerRadius = 5
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTouchHandler(sender:))))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playHapticFeedback()
        let controller = EditingController()
        controller.note = (noteCollection?.FBNotes[indexPath.row])!
        controller.noteCollection = noteCollection
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //traitcollection: dynamic iPad layout and light/dark mode support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            iPadOSLayout.itemsPerRow = 1.0
        } else if traitCollection.horizontalSizeClass == .regular {
            iPadOSLayout.itemsPerRow = 3.0
        }
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.backgroundColor = ColorManager.bgColor
        navigationController?.setColor(color: ColorManager.bgColor)
        handleStatusBarStyle(style: .darkContent)
    }
}

extension NoteCollectionController: CollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = 120
        } else {
            height = 110
        }
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
