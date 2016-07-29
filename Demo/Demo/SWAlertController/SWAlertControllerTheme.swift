//
//  SWActionSheetTheme.swift
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

typealias CornerRadius = CGFloat

enum SWActionSheetShape {
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
 *  Implement SWActionSheetThemeType to define custom theme
 */
protocol SWAlertControllerThemeType {
    var overlayColor: UIColor { get }
    
    var titleFont: UIFont { get }
    var buttonFont: UIFont { get }
    var messageFont: UIFont { get }
    
    var titleTextColor: UIColor { get }
    var messageTextColor: UIColor { get }
    
    var animationSpeed: CGFloat { get }
    var animationSpringDamping: CGFloat { get }
    var animationSpringVelocity: CGFloat { get }
    
    var borderColor: UIColor { get }
    var backgroundColor: UIColor { get }
    
    var shape: SWActionSheetShape { get }
}

public struct SWAlertControllerTheme: SWAlertControllerThemeType {
    let overlayColor: UIColor
    
    let titleFont: UIFont
    let buttonFont: UIFont
    let messageFont: UIFont
    
    let titleTextColor: UIColor
    let messageTextColor: UIColor
    
    let animationSpeed: CGFloat
    let animationSpringDamping: CGFloat
    let animationSpringVelocity: CGFloat
    
    let borderColor: UIColor
    let backgroundColor: UIColor
    
    let shape: SWActionSheetShape
    
    static func defaultTheme() -> SWAlertControllerTheme {
        
        let theme = SWAlertControllerTheme(overlayColor: UIColor(r: 0, g: 0, b: 0, a: 0.5),
                                       titleFont: UIFont.boldSystemFontOfSize(18),
                                       buttonFont: UIFont.boldSystemFontOfSize(16),
                                       messageFont: UIFont.systemFontOfSize(16),
                                       titleTextColor: UIColor(r: 77, g: 77, b: 77),
                                       messageTextColor: UIColor(r: 77, g: 77, b: 77),
                                       animationSpeed: 0.55,
                                       animationSpringDamping: 0.5,
                                       animationSpringVelocity: 0.3,
                                       borderColor: UIColor.whiteColor().colorWithAlphaComponent(0.25),
                                       backgroundColor: UIColor.customWhiteColor,
                                       shape: .Rounded(2.0))
        return theme
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class var customWhiteColor: UIColor {
        get {
            return UIColor(r: 239, g: 240, b: 242)
        }
    }
}
