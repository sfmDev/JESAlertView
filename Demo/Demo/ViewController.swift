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
        if indexPath.section == 0 {
            
        } else {
            switch indexPath.row {
            case 0:
                let theme = SWAlertControllerTheme.defaultTheme()
                let actionSheet = SWAlertController(withTheme: theme,
                                                    preferredStyle: .ActionSheet,
                                                    cancelButton: .Cancel("CANCEL",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 127, g: 140, b: 141)),
                                                    destructiveButton: .Destructive("OK",
                                                        UIColor.whiteColor(),
                                                        UIColor(r: 231, g: 76, b: 70)),
                                                    otherButtons: [],
                                                    tapClosure: { (tappedButtonIndex) in
                    
                })
                presentViewController(actionSheet, animated: true, completion: nil)
            default: break
            }
        }
    }
    
}

