# GradientAnimator
GradientAnimator helps to fill your view with vibrant gradient theme colours and animates them to give a stunning view to your application design
<img src="./Asset/art.png?raw=true">

## Preview
<img src="./Asset/preview.png?raw=true">

<img src="./Asset/preview2.gif?raw=true">

## Installation

Cocoapods installation is available  " pod 'GradientAnimator', '~> 1.0' "

### Compatibility

-  iOS 11.0+
- Swift 4.2

## Usage
1)  After installing the library import GradientAnimator to your controller

2) Gradient Animator has predefined Themes "GradientThemes" you can use our themes
```swift
let gradientView = GradientAnimator(frame: self.view.frame, theme: GradientThemes.Sunrise, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
```
3) You can also set custom UIColor combination of your choice as per order using the following initializer
```swift
 let gradientView = GradientAnimator(frame: self.frame, inputColors: [#colorLiteral(red: 0.9195817113, green: 0.04345837981, blue: 0.7682360411, alpha: 1),#colorLiteral(red: 0.1406921148, green: 0.05199617893, blue: 0.8817588687, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.7647058824, blue: 0.8039215686, alpha: 1)], _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 2.0)
```
4) GradientPoints - Gradient points are used to know from where yo wish to start your animation and to where to end and begins the next transition start point states from where to begin and endpoint states where to end
```swift
enum GradientPoints: Int {
case left
case top
case right
case bottom
case topLeft
case topRight
case bottomLeft
case bottomRight
}
```
5) After Initializing the gradient view we need to insert the gradient view at the index zero of subview and after that call the startAnimate() method to begin your animation
```swift
let gradientView = GradientAnimator(frame: self.view.frame, theme: GradientThemes.Sunrise, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
self.view.insertSubview(gradientView, at: 0)
gradientView.startAnimate()
```
6) For your convenience we wrote an extension of UIView so that you could simply call it on any view you would like the gradient animator to be there use the above code 
```swift
extension UIView{
func setGradient(){
self.removeGradient()

let gradientView = GradientAnimator(frame: self.frame, theme: GradientThemes.Sunrise, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
gradientView.tag = 007
self.insertSubview(gradientView, at: 0)
gradientView.startAnimate()

}
func removeGradient(){
if let gradView : GradientAnimator = self.subviews.filter({$0.tag == 007}).first as? GradientAnimator{
gradView.removeFromSuperview()
}
}
}
```

## Author
iLeaf Solutions
[http://www.ileafsolutions.com](http://www.ileafsolutions.com)
