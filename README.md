# JESAlertView

<p align="center">

<!--<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>-->

<a href="http://cocoadocs.org/docsets/JESAlertView"><img src="https://img.shields.io/badge/pod-v0.0.1-blue.svg"></a>

<a href="https://raw.githubusercontent.com/ShiWeiCN/JESAlertView/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-000000.svg"></a>

<a href="http://cocoadocs.org/docsets/Kingfisher"><img src="https://img.shields.io/badge/platform-ios 8.0+-lightgrey.svg"></a>

</p>

An alert view written by swift 2.2. Support both action sheet and alert view style.

## Screenshots

![GIF](http://7xie11.com1.z0.glb.clouddn.com/demo.gif)

## Easy to use

Provide a default theme of alert view. So you can use this default theme or create a theme you like.

	// 🌟 Usage 👇
	let theme = JESAlertViewTheme.defaultTheme()
	let alert = JESAlertView(withTheme: theme, 
						preferredStyle: .Alert, 
							     title: "A customizable action sheet title.", 
							   message: "A customizable action sheet message.", 
						  cancelButton: .Cancel("CANCEL"),
				     destructiveButton: .Destructive("OK"), 
				          otherButtons: [.Default("Default 1",
				                       UIColor.whiteColor(),
	UIColor(red: 80 / 255.0, green: 227 / 255.0, b: 194 / 255.0, alpah: 1.0))], 
				            tapClosure: { (index) in
				          		print("Tapped button index is \(index)")
                     	})
	// Show Alert view
	presentViewController(alert, animated: true, completion: nil)
	
#### Parameters of JESAlertView's `init` method

	/**
     JESAlertView init Method
     
     - parameter theme:             theme (JESAlertViewTheme)
     - parameter preferredStyle:    .ActionSheet / .Alert
     - parameter title:             Title - Optional
     - parameter message:           SubTitle / Message - Optional
     - parameter cancelButton:      Cancel Button (JESAlertViewItemStyle)
     - parameter destructiveButton: Destructive Button (JESAlertViewItemStyle) - Optional
     - parameter otherButtons:      Others Button (Array[JESAlertViewItemStyle])
     - parameter tapClosure:        Tapped Closure
     
     JESAlertViewItemStyle => .Default(String, ButtonTitleColor, ButtonBackgroundColor) / .Cancel(String) / .Destructive(String)
     
     */
#### Customize theme

You can create a theme to make the alert view different. Like this

	JESAlertViewTheme(overlayColor: UIColor.overlayColor,
                        titleFont: UIFont.boldSystemFontOfSize(18),
                       buttonFont: UIFont.boldSystemFontOfSize(16),
                      messageFont: UIFont.systemFontOfSize(16),
                   titleTextColor: UIColor.textColor,
                 messageTextColor: UIColor.textColor,
                  backgroundColor: UIColor.backgroundColor,
                            shape: .Rounded(2.0))

> shape 

	public typealias CornerRadius = CGFloat
	public enum JESAlertViewShape {
     	case Squared
     	case Rounded(CornerRadius)
	}

## Installation

JESAlertView is available through [Cocoapods](https://cocoapods.org/).

Add the following to you `Podfile`

	pod 'JESAlertView'

## TODO

- [ ] More animation
- [ ] Show Custom view to window
- [ ] More beautiful syntax

## License

JESAlertView is released under the MIT license. See LICENSE for details.

