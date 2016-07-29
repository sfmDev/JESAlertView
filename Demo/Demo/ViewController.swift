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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            
        } else {
            switch indexPath.row {
            case 0:
                let theme = SWAlertControllerTheme.defaultTheme()
                let actionSheet = SWAlertController(withTheme: theme,
                                                    preferredStyle: .ActionSheet,
                                                    title: "12",
                                                    message: "1234555",
                                                    cancelButton: .Cancel("OK", UIColor.blackColor(), UIColor.whiteColor()),
                                                    destructiveButton: .Destructive("DESTRUCTIVE", UIColor.blackColor(), UIColor.whiteColor()),
                                                    otherButtons: [],
                                                    tapClosure: { (tappedButtonIndex) in
                    print("\(tappedButtonIndex)")
                })
                presentViewController(actionSheet, animated: true, completion: nil)
            default: break
            }
        }
    }
    
}

