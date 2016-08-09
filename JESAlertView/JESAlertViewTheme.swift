//
//  JESAlertViewTheme.swift
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

internal typealias CornerRadius = CGFloat

// Alert view & Action Sheet Background view's shape
enum JESAlertViewShape {
    
    case Squared
    case Rounded(CornerRadius)
    
    var cornerRadius: CornerRadius {
        get {
            switch self {
            case .Squared: return 0.0
            case .Rounded(let cornerRadius): return cornerRadius
            }
        }
    }
}

/**
 *  @author Shi Wei, 16-07-28 23:07:29
 *
 *  Implement JESAlertViewThemeType to define custom theme
 */
protocol JESAlertViewThemeType {
    // Overlay Color
    var overlayColor: UIColor { get }
    
    var titleFont: UIFont { get }
    var messageFont: UIFont { get }
    var buttonFont: UIFont { get }
    
    var titleTextColor: UIColor { get }
    var messageTextColor: UIColor { get }
    
    // Action sheet & Alert view's background color
    var backgroundColor: UIColor { get }
    var shape: JESAlertViewShape { get }
    
    // Default Theme
    static func defaultTheme() -> JESAlertViewTheme
}

struct JESAlertViewTheme: JESAlertViewThemeType {
    
    let overlayColor: UIColor
    
    let titleFont: UIFont
    let buttonFont: UIFont
    let messageFont: UIFont
    
    let titleTextColor: UIColor
    let messageTextColor: UIColor
    
    // Action sheet & Alert view's background color
    let backgroundColor: UIColor
    
    let shape: JESAlertViewShape
    
    // Default Theme
    static func defaultTheme() -> JESAlertViewTheme {
        return JESAlertViewTheme(overlayColor: UIColor.overlayColor,
                                 titleFont: UIFont.boldSystemFontOfSize(18),
                                 buttonFont: UIFont.boldSystemFontOfSize(16),
                                 messageFont: UIFont.systemFontOfSize(16),
                                 titleTextColor: UIColor.textColor,
                                 messageTextColor: UIColor.textColor,
                                 backgroundColor: UIColor.backgroundColor,
                                 shape: .Rounded(2.0))
    }
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class var backgroundColor: UIColor {
        get {
            return UIColor(r: 239, g: 240, b: 242)
        }
    }
    
    class var overlayColor: UIColor {
        get {
            return UIColor(r: 0, g: 0, b: 0, a: 0.5)
        }
    }
    
    class var textColor: UIColor {
        get {
            return UIColor(r: 77, g: 77, b: 77)
        }
    }
    
    class var destructiveColor: UIColor {
        get {
            return UIColor(r: 231, g: 76, b: 70)
        }
    }
    
    class var cancelColor: UIColor {
        get {
            return UIColor(r: 127, g: 140, b: 141)
        }
    }
}
