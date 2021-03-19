//
//  NoteCollectionController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit
import Blueprints
import XLActionController

class NoteCollectionController: UICollectionViewController {
    //update collection view when model changes
    var noteCollection: NoteCollection? {
        didSet {
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
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
        
        let actionController = SkypeActionController()
        if traitCollection.userInterfaceStyle == .light {
            actionController.backgroundColor = ColorManager.noteColor
        } else {
            actionController.backgroundColor = .mineShaft
        }
        actionController.addAction(Action("Share note", style: .default, handler: { _ in
            print("Share note")
            let objectsToShare = [note?.content ?? "Note could not be found."] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
            
            //required properties for iPad's popoverPresentationController, otherwise crash
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
            
            self.present(activityVC, animated: true, completion: nil)
            AnalyticsManager.logEvent(named: "share_note", description: "share_note")
        }))
        actionController.addAction(Action("Delete note", style: .default, handler: { _ in
            DataManager.deleteNote(docID: note!.id) { (success) in
                if success! {
                    AnalyticsManager.logEvent(named: "note_deleted", description: "note_deleted")
                }
            }
        }))
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
        present(actionController, animated: true, completion: nil)
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
