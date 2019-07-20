# Jotify

Jotify is an iOS app written completely in swift used for simple note taking. It uses a few of Apple's new frameworks and features introduced with iOS 13 including:
- [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer)
- System Colors 
- [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)
- SceneDelegate

By using NSPersistentCloudKitContainer, this application can serve as an example of using both CoreData and CloudKit in the same application. Jotify syncs notes instantly between devices and well as storing a copy of the CloudKit database on device.

[Demo](https://imgur.com/ninS69q)

## Prerequisites

To run this project you will need to be running the lastest Xcode 11 Beta and the lastest iOS 13 Beta. 

## Dependencies

- [MultilineTextField](https://github.com/rlaguilar/MultilineTextField) - Used in WriteNoteView.swift to create a UITextView with a placeholder
- [Blueprints](https://github.com/zenangst/Blueprints) - CollectionView layout for SavedNoteController.swift
- [ViewAnimator](https://github.com/marcosgriselli/ViewAnimator) - Used to animate cells in CollectionView on sort
- [XLActionController](https://github.com/xmartlabs/XLActionController) - Used for ActionSheet in SavedNoteController.swift
- [PageBoy](https://github.com/uias/Pageboy) - UIPageController for navigation across multiple views
- [ChromaColorPicker](https://github.com/joncardasis/ChromaColorPicker) - Used for picking a static color for notes

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* StackOverFlow... you already knew that
