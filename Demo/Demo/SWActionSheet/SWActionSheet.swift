//
//  SWActionSheet.swift
//  Demo
//
//  Created by JerryShi on 7/28/16.
//  Copyright © 2016 jerryshi. All rights reserved.
//
//  This software is released under the MIT License.
//  http://opensource.org/licenses/mit-license.php
//

import Foundation
import UIKit

enum SWAlertActionStyle {
    case Default, Cancel, Destructive
}

enum SWActionSheetStyle {
    case ActionSheet, Alert
}

class SWAlertController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {

    // Message
    var message: String?
    
    // AlertController Style
    private(set) var preferredStyle: SWActionSheetStyle = .ActionSheet
    
    // OverlayView
    private var overlayView = UIView()
    var overlayColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    
    // ContainerView
    private var containerView = UIView()
    private var containerViewBottomSpaceConstraint: NSLayoutConstraint!
    
    // AlertView
    private var alertView = UIView()
    
    
    var alertViewBackgroundColor = UIColor(r: 239, g: 240, b: 242)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
