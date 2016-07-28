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
protocol SWActionSheetThemeType {
    var titleFont: UIFont { get }
    var buttonFout: UIFont { get }
    
    var titleTextColor: UIColor { get }
    var normalButtonTextColor: UIColor { get }
    var destructiveButtonTextColor: UIColor { get }
    
    var normalButtonHighlightTextColor: UIColor { get }
    var destructiveButtonHighlightTextColor: UIColor { get }
    
    var normalButtonColor: UIColor { get }
    var destructiveButtonColor: UIColor { get }
    
    var normalButtonHighlightColor: UIColor { get }
    var destructiveButtonHighlightColor: UIColor { get }
    
    var animationSpeed: CGFloat { get }
    var animationSpringDamping: CGFloat { get }
    var animationSpringVelocity: CGFloat { get }
    
    var borderColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var backdropShadowColor: UIColor { get }
    
    var shape: SWActionSheetShape { get }
}

public struct SWActionSheetTheme: SWActionSheetThemeType {
    let titleFont: UIFont
    let buttonFout: UIFont
    
    let titleTextColor: UIColor
    let normalButtonTextColor: UIColor
    let destructiveButtonTextColor: UIColor
    
    let normalButtonHighlightTextColor: UIColor
    let destructiveButtonHighlightTextColor: UIColor
    
    let normalButtonColor: UIColor
    let destructiveButtonColor: UIColor
    
    let normalButtonHighlightColor: UIColor
    let destructiveButtonHighlightColor: UIColor
    
    let animationSpeed: CGFloat
    let animationSpringDamping: CGFloat
    let animationSpringVelocity: CGFloat
    
    let borderColor: UIColor
    let backgroundColor: UIColor
    let backdropShadowColor: UIColor
    
    let shape: SWActionSheetShape
    
    static func defaultTheme() -> SWActionSheetThemeType {
        
        let theme = SWActionSheetTheme(titleFont: UIFont.systemFontOfSize(16),
                                       buttonFout: UIFont.systemFontOfSize(16),
                                       titleTextColor: UIColor.blackColor(),
                                       normalButtonTextColor: UIColor.blackColor(),
                                       destructiveButtonTextColor: UIColor.redColor(),
                                       normalButtonHighlightTextColor: UIColor.whiteColor(),
                                       destructiveButtonHighlightTextColor: UIColor.whiteColor(),
                                       normalButtonColor: UIColor.whiteColor(),
                                       destructiveButtonColor: UIColor.whiteColor(),
                                       normalButtonHighlightColor: UIColor.blackColor(),
                                       destructiveButtonHighlightColor: UIColor.redColor(),
                                       animationSpeed: 0.55,
                                       animationSpringDamping: 0.5,
                                       animationSpringVelocity: 0.3,
                                       borderColor: UIColor.whiteColor().colorWithAlphaComponent(0.25),
                                       backgroundColor: UIColor.customWhiteColor,
                                       backdropShadowColor: UIColor.blackColor(),
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
