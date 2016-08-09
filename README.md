<p align="center">

<!--<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>-->

<a href="http://cocoadocs.org/docsets/JESAlertView"><img src="https://img.shields.io/badge/pod-v0.0.1--beta-blue.svg"></a>

<a href="https://raw.githubusercontent.com/ShiWeiCN/JESAlertView/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-000000.svg"></a>

<a href="http://cocoadocs.org/docsets/Kingfisher"><img src="https://img.shields.io/badge/platform-ios 8.0+-lightgrey.svg"></a>

</p>

An alert view written by swift 2.2. Support both action sheet and alert view style.

![GIF](/Users/JerryShi/GitHub/JESAlertView/demo.gif)

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
     - parameter preferredStyle:    .ActionSheet / /Alert
     - parameter title:             Title
     - parameter message:           SubTitle / Message
     - parameter cancelButton:      Cancel Button (JESAlertViewItemStyle)
     - parameter destructiveButton: Destructive Button (JESAlertViewItemStyle)
     - parameter otherButtons:      Others Button (Array[JESAlertViewItemStyle])
     - parameter tapClosure:        Tapped Closure
     
     JESAlertViewItemStyle => .Default(String, ButtonTitleColor, ButtonBackgroundColor) / .Cancel(String) / .Destructive(String)
     
     */
#### Customize theme

You can customi

## License

JESAlertView is released under the MIT license. See LICENSE for details.

