//
//  PageViewController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    var currentIndex = 1
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    let noteCollectionController = UINavigationController(rootViewController: NoteCollectionController(collectionViewLayout: UICollectionViewFlowLayout()))
    let writeNotesController = WriteNoteController()
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.noteCollectionController, self.writeNotesController]
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
        
        //setup the color system for background with light/dark mode
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = UIColor.white.adjust(by: -4) ?? .white
        } else if traitCollection.userInterfaceStyle == .dark {
            ColorManager.bgColor = .mineShaft
        }
        
        if !UserDefaults.standard.bool(forKey: "hasMigrated") {
            print("Has migrated?: \(UserDefaults.standard.bool(forKey: "hasMigrated"))")
            //notify when notes are fetched from context, CloudKit
            NotificationCenter.default.addObserver(self, selector: #selector(migrateDataFromCloudKit), name: .NSManagedObjectContextObjectsDidChange, object: MigrationHandler().context)
        }

        //get data from Firebase
        DataManager.observeNoteChange { (collection, success) in
            if success! {
                let controller = self.noteCollectionController.viewControllers.first as! NoteCollectionController
                controller.noteCollection = collection
            }
        }
        
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break;
            }
        }
    }
    
    @objc func migrateDataFromCloudKit() {
        print("Called migration stuff")
        print(MigrationHandler.CDNotes.count)
        if !MigrationHandler.CDNotes.isEmpty {
            NotificationCenter.default.removeObserver(self)
            for note in MigrationHandler.CDNotes {
                DataManager.createNote(content: note.content ?? "", timestamp: note.modifiedDate, color: ColorManager.noteColor.getString())
                ColorManager.setNoteColor(theme: UIColor.defaultTheme)
            }
            UserDefaults.standard.setValue(true, forKey: "hasMigrated")
        }
    }
    
//    //migrates data from CloudKit to Firebase
//    @objc func migrateDataFromCloudKit() {
//        //if user has not migrated and the fetchrequest returns objects then create a new FBNote for each CDNote
//        if !UserDefaults.standard.bool(forKey: "hasMigrated") {
//            print("NUM OF FETCH: \(MigrationHandler.CDNotes.count)")
//            if MigrationHandler.CDNotes.count != 0 {
//                for note in MigrationHandler.CDNotes {
//                    if let noteIndex = migratedNotes.firstIndex(where: { $0 == note.content})  {
//                        print("duplicate note:\(String(describing: note.content))")
////                        MigrationHandler.CDNotes.remove(at: noteIndex)
//                    } else {
//                        DataManager.createNote(content: note.content ?? "", timestamp: note.modifiedDate, color: ColorManager.noteColor.getString())
//                        ColorManager.setNoteColor(theme: UIColor.defaultTheme)
//                        print("migrated notes: \(migratedNotes.count)")
//                        print("this is the note added: \(note.content)")
////                        print(migratedNotes)
//                    }
//                }
//
//                UserDefaults.standard.setValue(true, forKey: "hasMigrated")
//
//                DataManager.updateUserSettings(setting: "hasMigrated", value: true) { (success) in
//                    print("Migration complete")
//                }
//            }
//        }
//    }
    
    func setupPageController() {
        view.backgroundColor = UIColor.clear
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.last {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableSwipe(notification:)), name:NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableSwipe(notification:)), name:NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    @objc func disableSwipe(notification: Notification){
        self.dataSource = nil
    }

    @objc func enableSwipe(notification: Notification){
        self.dataSource = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = orderedViewControllers.firstIndex(of: visibleViewController)
            {
                currentIndex = index
            }
        }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = UIColor.white.adjust(by: -4) ?? .white
        } else if traitCollection.userInterfaceStyle == .dark {
            ColorManager.bgColor = .mineShaft
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}

extension PageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentIndex == orderedViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentIndex == orderedViewControllers.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
}
