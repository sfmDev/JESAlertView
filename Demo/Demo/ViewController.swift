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
        let theme = JESAlertViewTheme.defaultTheme()
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let alert = JESAlertView(withTheme: theme,
                                                    preferredStyle: .Alert,
                                                    cancelButton: .Cancel("CANCEL"),
                                                    destructiveButton: .Destructive("OK"),
                                                    otherButtons: [],
                                                    tapClosure: { (index) in
                                                        print("Tapped button index is \(index)")
                                                    })
                presentViewController(alert, animated: true, completion: nil)
            case 1:
                let alert = JESAlertView(withTheme: theme,
                                                    preferredStyle: .Alert,
                                                    title: "OKAY/CNACEL",
                                                    message: "A customizable alert view message.",
                                                    cancelButton: .Cancel("CANCEL"),
                                                    destructiveButton: .Destructive("OK"),
                                                    otherButtons: [],
                                                    tapClosure: { (index) in
                                                        print("Tapped button index is \(index)")
                                                    })
                presentViewController(alert, animated: true, completion: nil)
            case 2:
                let alert = JESAlertView(withTheme: theme,
                                                    preferredStyle: .Alert,
                                                    title: "MORE",
                                                    message: "A customizable alert view message.",
                                                    cancelButton: .Cancel("CANCEL"),
                                                    destructiveButton: .Destructive("OK"),
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
                                                    tapClosure: { (index) in
                                                        let vc = UIViewController()
                                                        vc.view.backgroundColor = UIColor.redColor()
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                        print("Tapped button index is \(index)")
                                                    })
                presentViewController(alert, animated: true, completion: nil)
            default: break
            }
        } else {
            switch indexPath.row {
            case 0:
                let actionSheet = JESAlertView(withTheme: theme,
                                                    preferredStyle: .ActionSheet,
                                                    title: "OKAY/CNACEL",
                                                    message: "A customizable action sheet message.",
                                                    cancelButton: .Cancel("CANCEL"),
                                                    destructiveButton: .Destructive("OK"),
                                                    otherButtons: [],
                                                    tapClosure: { (index) in
                                                        let vc = UIViewController()
                                                        vc.view.backgroundColor = UIColor.redColor()
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                    })
                presentViewController(actionSheet, animated: true, completion: nil)
            case 1:
                let actionSheet = JESAlertView(withTheme: theme,
                                                    preferredStyle: .ActionSheet,
                                                    title: "MORE",
                                                    message: "A customizable action sheet message.",
                                                    cancelButton: .Cancel("CANCEL"),
                                                    destructiveButton: .Destructive("OK"),
                                                    otherButtons: [
                                                        .Default("Default 1",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 38, g: 126, b: 217)),
                                                        .Default("Default 2",
                                                            UIColor.whiteColor(),
                                                            UIColor(r: 38, g: 126, b: 217))
                                                        ],
                                                    tapClosure: { (index) in
                                                        print("Tapped button index is \(index)")
                                                    })
                presentViewController(actionSheet, animated: true, completion: nil)
            default: break
            }
        }
    }
    
}

