[![Build Status](https://travis-ci.org/Automattic/Gridicons-iOS.svg?branch=develop)](https://travis-ci.org/Automattic/Gridicons-iOS)
[![Version](https://img.shields.io/cocoapods/v/Gridicons.svg?style=flat)](http://cocoadocs.org/docsets/Gridicons)
[![License](https://img.shields.io/cocoapods/l/Gridicons.svg?style=flat)](http://cocoadocs.org/docsets/Gridicons)
[![Platform](https://img.shields.io/cocoapods/p/Gridicons.svg?style=flat)](http://cocoadocs.org/docsets/Gridicons)

# Gridicons iOS

Gridicons-iOS is a small framework which produces images of the [Gridicons icon set](https://github.com/automattic/gridicons).

The framework can be installed either via CocoaPods:

`pod 'Gridicons', :podspec => 'https://raw.github.com/Automattic/Gridicons-iOS/develop/Gridicons.podspec'`

or Carthage:

`github 'Automattic/Gridicons-iOS'`

## Usage

First, import the framework:

`import Gridicons`

Getting a `UIImage` of a Gridicon is as simple as:

`let icon = Gridicon.iconOfType(.Pages)`

You can optionally specify a size (default is 24 x 24):

`let icon = Gridicon.iconOfType(.Pages, withSize: CGSize(width: 100, height: 100))`

The images that the framework produces use the `AlwaysTemplate` rendering mode, so you can tint them however you like.

## License

Gridicons-iOS is licensed under [GNU General Public License v2 (or later)](./LICENSE.md).
