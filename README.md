# Jotify

Jotify is an iOS app written completely in swift used for simple note taking. It uses a few of Apple's new frameworks and features introduced with iOS 13 including:
- [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer)
- System Colors 
- [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)
- SceneDelegate

By using NSPersistentCloudKitContainer, this application can serve as an example of using both CoreData and CloudKit in the same application. Jotify syncs notes instantly between devices and well as storing a copy of the CloudKit database on device.

[Demo](https://imgur.com/ninS69q)

## Testflight

Available on [Testflight](https://testflight.apple.com/join/EnJVSmNy)!

## App Store

Check out Jotify on the [iOS App Store](https://apps.apple.com/us/app/jotify/id1469983730?ls=1)! 

## Prerequisites

To run this project you will need to use Xcode 11 and iOS 13. **Jotify does not support iOS 12**.

## Dependencies

- [MultilineTextField](https://github.com/rlaguilar/MultilineTextField) - Used in WriteNoteView.swift to create a UITextView with a placeholder
- [Blueprints](https://github.com/zenangst/Blueprints) - CollectionView layout for SavedNoteController.swift
- [ViewAnimator](https://github.com/marcosgriselli/ViewAnimator) - Used to animate cells in CollectionView on sort
- [XLActionController](https://github.com/xmartlabs/XLActionController) - Used for ActionSheet in SavedNoteController.swift
- [PageBoy](https://github.com/uias/Pageboy) - UIPageController for navigation across multiple views
- [ChromaColorPicker](https://github.com/joncardasis/ChromaColorPicker) - Used for picking a static color for notes
- [WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit) - Used for displaying information about app updates and onboarding
- [BottomPopup](https://github.com/ergunemr/BottomPopup) - Used for presenting ViewControllers at a custom height
- [SPAlert](https://github.com/ivanvorobei/SPAlert) - Used for displaying confirmations to users when reminders are created or deleted
- [OpenSSL](https://github.com/krzyzanowskim/OpenSSL) - Used in receipt validation to read the user's original purchase statement

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details
