# Jotify

<img src="docs/1.png" width="20%"> <img src="docs/2.png" width="20%"> <img src="docs/3.png" width="20%"> <img src="docs/4.png" width="20%">

## About

Jotify is an iOS app used for lightning fast note-taking and reminders, all written in swift. It uses several of Apple's newest frameworks and features introduced in iOS 13 including:
- [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer)
- System Colors 
- [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)
- SceneDelegate

Jotify utilizes NSPersistentCloudKitContainer, allowing Jotify to sync notes between a user's devices seamlessly. Notes are stored locally on device using CoreData and are uploaded to iCloud using Apple's CloudKit. Jotify is avaliable for both iPhone and iPad.

<b>Jotify now supports Mac Catalyst! Check out the "mac" branch to see for yourself.</b>

## Testflight

Want to test the lastest features as they come out? Check out Jotify on [Testflight](https://testflight.apple.com/join/EnJVSmNy)!

## App Store

Jotify is available on the [iOS App Store](https://apps.apple.com/us/app/jotify/id1469983730?ls=1) for iPhone and iPad! 

## Prerequisites

To run this project you will need to use Xcode 11 and iOS 13. **Jotify does not support iOS 12**.

## Dependencies

- [MultilineTextField](https://github.com/rlaguilar/MultilineTextField) - Used in WriteNoteView.swift to create a UITextView with a placeholder
- [Blueprints](https://github.com/zenangst/Blueprints) - CollectionView layout for SavedNoteController.swift
- [ViewAnimator](https://github.com/marcosgriselli/ViewAnimator) - Used to animate cells in CollectionView on sort
- [XLActionController](https://github.com/xmartlabs/XLActionController) - Used for ActionSheet in SavedNoteController.swift
- [ChromaColorPicker](https://github.com/joncardasis/ChromaColorPicker) - Used for picking a static color for notes
- [WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit) - Used for displaying information about app updates and onboarding
- [BottomPopup](https://github.com/ergunemr/BottomPopup) - Used for presenting ViewControllers at a custom height
- [SPAlert](https://github.com/ivanvorobei/SPAlert) - Used for displaying confirmations to users when reminders are created or deleted
- [OpenSSL](https://github.com/krzyzanowskim/OpenSSL) - Used for verifying purchase receipts for users who bought Jotify as a paid application

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details
