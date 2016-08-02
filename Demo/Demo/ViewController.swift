//
//  ViewController.swift
//  Demo
//
//  Created by JerryShi on 7/28/16.
//  Copyright © 2016 jerryshi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // 🌟 Usage 👇
        let theme = SWAlertControllerTheme.defaultTheme()
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let alert = SWAlertController(withViewController: self, theme: theme,
                                                    preferredStyle: .Alert,
                                                    cancelButton: .Cancel("CANCEL",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 127, g: 140, b: 141)),
                                                    destructiveButton: .Destructive("OK",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 231, g: 76, b: 70)),
                                                    otherButtons: [],
                                                    tapClosure: { (tappedButtonIndex) in
                                                        print("Tapped button index is \(tappedButtonIndex)")
                                                    })
                presentViewController(alert, animated: true, completion: nil)
            case 1:
                let alert = SWAlertController(withViewController: self, theme: theme,
                                                    preferredStyle: .Alert,
                                                    title: "A customizable action sheet title",
                                                    message: "A customizable action sheet message.",
                                                    cancelButton: .Cancel("CANCEL",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 127, g: 140, b: 141)),
                                                    destructiveButton: .Destructive("OK",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 38, g: 126, b: 217)),
                                                    otherButtons: [],
                                                    tapClosure: { (tappedButtonIndex) in
                                                        print("Tapped button index is \(tappedButtonIndex)")
                                                    })
                presentViewController(alert, animated: true, completion: nil)
            case 2:
                let alert = SWAlertController(withViewController: self, theme: theme,
                                                    preferredStyle: .Alert,
                                                    title: "A customizable action sheet title",
                                                    message: "A customizable action sheet message.",
                                                    cancelButton: .Cancel("CANCEL",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 127, g: 140, b: 141)),
                                                    destructiveButton: .Destructive("OK",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 38, g: 126, b: 217)),
                                                    otherButtons: [
                                                        .Default("Default 1",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 80, g: 227, b: 194)),
                                                        .Default("Default 2",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 146, g: 212, b: 230)),
                                                        .Default("Default 3",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 168, g: 236, b: 102))
                                                    ],
                                                    tapClosure: { (tappedButtonIndex) in
                                                        print("Tapped button index is \(tappedButtonIndex)")
                                                    })
                presentViewController(alert, animated: true, completion: nil)
            default: break
            }
        } else {
            switch indexPath.row {
            case 0:
                let actionSheet = SWAlertController(withViewController: self, theme: theme,
                                                    preferredStyle: .ActionSheet,
                                                    title: "A customizable alert title",
                                                    message: "A customizable alert message.",
                                                    cancelButton: .Cancel("CANCEL",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 127, g: 140, b: 141)),
                                                    destructiveButton: .Destructive("OK",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 231, g: 76, b: 70)),
                                                    otherButtons: [],
                                                    tapClosure: { (tappedButtonIndex) in
                                                        let vc = UIViewController()
                                                        vc.view.backgroundColor = UIColor.redColor()
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                    })
                presentViewController(actionSheet, animated: true, completion: nil)
            case 1:
                let actionSheet = SWAlertController(withViewController: self, theme: theme,
                                                    preferredStyle: .ActionSheet,
                                                    title: "A customizable action sheet title",
                                                    message: "A customizable action sheet message.",
                                                    cancelButton: .Cancel("CANCEL",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 127, g: 140, b: 141)),
                                                    destructiveButton: .Destructive("OK",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 231, g: 76, b: 70)),
                                                    otherButtons: [
                                                        .Default("Default 1",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 38, g: 126, b: 217)),
                                                        .Default("Default 2",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 38, g: 126, b: 217))
                                                        ],
                                                    tapClosure: { (tappedButtonIndex) in
                                                        print("Tapped button index is \(tappedButtonIndex)")
                                                    })
                presentViewController(actionSheet, animated: true, completion: nil)
            default: break
            }
        }
    }
    
}

