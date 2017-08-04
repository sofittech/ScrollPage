# ScrollPage

[![License](https://img.shields.io/cocoapods/l/SMSwipeableTabView.svg?style=flat)](http://cocoapods.org/pods/ScrollPage)
[![Platform](https://img.shields.io/cocoapods/p/PageMenu.svg?style=flat)](http://cocoapods.org/pods/ScrollPage)

ScrollPage is a custom control which is mixture of UIScrollView contains Container Views and Scrollable Tab Bar.

## Demo: 
(Without Customization)

![demo](https://github.com/dan12411/ScrollPage/blob/master/ScrollPageDemo(Portrait).gif)
![demo](https://github.com/dan12411/ScrollPage/blob/master/ScrollPageDemo(Landscape).gif)


## Installation

**CocoaPods**

ScrollPage is available through [CocoaPods](http://cocoapods.org). !! Swift only !!

To install add the following line to your Podfile:

    pod 'ScrollPage'


## How to use 

```swift 
//Add the title bar elements as an Array of String
swipeableView.titleBarDataSource = titleBarDataSource //Array of Button Titles like ["Movies", "Society", "Health"]

//Assign your viewcontroller as delegate to load the Viewcontroller
swipeableView.delegate = self

//Set the View Frame (64.0 is 44.0(NavigationBar Height) + 20.0(StatusBar Height))
swipeableView.viewFrame = CGRect(x: 0.0, y: 64.0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height-64.0)

//Then add the view controller on the current view.
self.addChildViewController(swipeableView)
self.view.addSubview(swipeableView.view)
swipeableView.didMoveToParentViewController(self)
```

## Customization 

```swift
swipeableView.buttonWidth = 60.0
```

Similarly Height of selectionBar can be changed using

```swift
swipeableView.selectionBarHeight = 2.0 //For thin line
```

We can also change the height of the segmentBar, use the below line of code:

```swift
swipeableView.segementBarHeight = 50.0 //Default is 44.0
```

Padding in the button can be customised using:

```swift
swipeableView.buttonPadding = 10.0 //Default is 8.0
