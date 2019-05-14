# MultilineTextField

[![CI Status](http://img.shields.io/travis/rlaguilar/MultilineTextField.svg?style=flat)](https://travis-ci.org/rlaguilar/MultilineTextField)
[![Version](https://img.shields.io/cocoapods/v/MultilineTextField.svg?style=flat)](http://cocoapods.org/pods/MultilineTextField)
[![License](https://img.shields.io/cocoapods/l/MultilineTextField.svg?style=flat)](http://cocoapods.org/pods/MultilineTextField)
[![Platform](https://img.shields.io/cocoapods/p/MultilineTextField.svg?style=flat)](http://cocoapods.org/pods/MultilineTextField)

This  can be seen as a `UITextField` with multiple lines, but under the hood it is just a `UITextView` which aims to provide many of the functionalities currently available in the `UITextField` class. Currently the following functionalities are supported:

+ Multiple lines
+ Customizable left view
+ Customizable placeholder text

## Usage

### Via storyboards

Add a `UITextView` and set its custom class to `MultilineTextField`. From the storyboard you can customize the placeholder text and also an image to be shown at the left of the field text.

### Via code

First of all you have to import the library  `import MultilineTextField`.

After that just create an instance of the view an customize its properties:

````
let textField = MultiplelineTextField(frame: textFieldFrame)
textField.leftView = UIImageView(image: image)
// or use the convenience property:
// textField.leftImage to assign an image directly

// below are properties that can be optionally customized
textField.placeholder = "This is my placeholder"
textField.placeholderColor = UIColor.red
textField.isPlaceholderScrollEnabled = true
textField.leftViewOrigin = CGPoint(x: 8, y: 8)
someView.addSubview(textField)
````

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

It requires Swift 4 and Xcode 9 or above

## Installation

MultilineTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MultilineTextField'
```

## Author

Reynaldo Aguilar, [rlaguilar](https://twitter.com/rlaguilar_)

## License

MultilineTextField is available under the MIT license. See the LICENSE file for more info.
