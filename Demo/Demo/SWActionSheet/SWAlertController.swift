//
//  SWAlertController.swift
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

typealias ButtonTitleColor = UIColor
typealias ButtonBackgroundColor = UIColor

enum SWAlertActionStyle {
    case Default(String, ButtonTitleColor, ButtonBackgroundColor)
    case Cancel(String, ButtonTitleColor, ButtonBackgroundColor)
    case Destructive(String, ButtonTitleColor, ButtonBackgroundColor)
    
    var buttonTitle: String {
        get {
            switch self {
            case .Default(let title, _, _): return title
            case .Cancel(let title, _, _): return title
            case .Destructive(let title, _, _): return title
            }
        }
    }
    
    var buttonTitleColor: UIColor {
        get {
            switch self {
            case .Default(_, let titleColor, _): return titleColor
            case .Cancel(_, let titleColor, _): return titleColor
            case .Destructive(_, let titleColor, _): return titleColor
            }
        }
    }
    
    var buttonBackgroundColor: UIColor {
        get {
            switch self {
            case .Default(_, _, let backgroundColor): return backgroundColor
            case .Cancel(_, _, let backgroundColor): return backgroundColor
            case .Destructive(_, _, let backgroundColor): return backgroundColor
            }
        }
    }
}

enum SWActionSheetStyle {
    case ActionSheet, Alert
}

typealias SWActionSheetTapColsure = (tappedButtonIndex: Int) -> Void

private struct Handler {
    static let AlertActionEnabledDidChangeNotification = "AlertActionEnabledDidChangeNotification"
    static let BaseTag: Int = 0
    static let LayoutPriority: Float = 1000.0
}

private extension Selector {
    static let handleAlertActionEnabledDidChangeNotification = #selector(SWAlertController.handleAlertActionEnabledDidChangeNotification(_:))
    static let alertActionButtonTapped = #selector(SWAlertController.buttonTapped(_:))
    static let handleContainerViewTapGesture = #selector(SWAlertController.handleContainerViewTapGesture(_:))
}

// MARK: DOAlertAnimation Class

class SWAlertAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if (isPresenting) {
            return 0.45
        } else {
            return 0.25
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if (isPresenting) {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
    
    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! SWAlertController
        let containerView = transitionContext.containerView()
        
        alertController.overlayView.alpha = 0.0
        if (alertController.isAlert()) {
            alertController.alertView.alpha = 0.0
            alertController.alertView.center = alertController.view.center
            alertController.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        } else {
            alertController.alertView.transform = CGAffineTransformMakeTranslation(0, alertController.alertView.frame.height)
        }
        containerView!.addSubview(alertController.view)
        
        UIView.animateWithDuration(0.25, animations: { 
            alertController.overlayView.alpha = 1.0
            if (alertController.isAlert()) {
                alertController.alertView.alpha = 1.0
                alertController.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05)
            } else {
                let bounce = alertController.alertView.frame.height / 480 * 10.0 + 10.0
                alertController.alertView.transform = CGAffineTransformMakeTranslation(0, -bounce)
            }
        }) { finished in
            UIView.animateWithDuration(0.2, animations: { 
                alertController.alertView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                if (finished) {
                    transitionContext.completeTransition(true)
                }
            })
        }
    }
    
    func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SWAlertController
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            alertController.overlayView.alpha = 0.0
            if (alertController.isAlert()) {
                alertController.alertView.alpha = 0.0
                alertController.alertView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            } else {
                alertController.containerView.transform = CGAffineTransformMakeTranslation(0, alertController.alertView.frame.height)
            }
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
}

class SWAlertController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
 
    // Message
    var message: String?
    
    var theme: SWAlertControllerTheme = SWAlertControllerTheme.defaultTheme()
    
    // AlertController Style
    private(set) var preferredStyle: SWActionSheetStyle = .ActionSheet
    
    // OverlayView
    private var overlayView = UIView()
    private var overlayColor: UIColor {
        get {
            return self.theme.overlayColor
        }
    }
    
    // ContainerView
    private var containerView = UIView()
    private var containerViewBottomSpaceConstraint: NSLayoutConstraint!
    
    // AlertView
    private var alertView = UIView()
    private var alertViewWidth: CGFloat = 270.0
    private var alertViewPadding: CGFloat = 15.0
    private var innerContentWidth: CGFloat = 240.0
    private var actionSheetBounceHeight: CGFloat = 20.0
    
    private var alertViewHeightConstraint: NSLayoutConstraint!
    
    private var alertViewBackgroundColor: UIColor {
        get {
            return self.theme.backgroundColor
        }
    }
    
    // TextAreaScrollView
    private var textAreaScrollView = UIScrollView()
    private var textAreaHeight: CGFloat = 0.0
    
    // TextAreaView
    private var textAreaView: UIView = UIView()
    
    // TextContainer
    private var textContainer = UIView()
    private var textContainerHeightConstraint: NSLayoutConstraint!
    
    // TitleLabel
    private var titleLabel = UILabel()
    private var titleFont: UIFont {
        get {
            return self.theme.titleFont
        }
    }
    private var titleTextColor: UIColor {
        get {
            return self.theme.titleTextColor
        }
    }
    
    // MessageView
    private var messageView = UILabel()
    private var messageFont: UIFont {
        get {
            return self.theme.messageFont
        }
    }
    private var messageTextColor: UIColor {
        get {
            return self.theme.messageTextColor
        }
    }
    
    // ButtonAreaScrollView
    private var buttonAreaScrollView = UIScrollView()
    private var buttonAreaScrollViewHeightConstraint: NSLayoutConstraint!
    private var buttonAreaHeight: CGFloat = 0.0
    
    // ButtonAreaView
    private var buttonAreaView = UIView()
    
    // ButtonContainer
    private var buttonContainer = UIView()
    private var buttonContainerHeightConstraint: NSLayoutConstraint!
    private let buttonHeight: CGFloat = 44.0
    private var buttonMargin: CGFloat = 10.0
    
    // Buttons
    private var buttons = [UIButton]()
    private var buttonStyles = [SWAlertActionStyle]()
    
    private var buttonCornerRadius: CGFloat {
        get {
            return self.theme.shape.cornerRadius
        }
    }
    
    private var layoutFlg = false
    private var keyboardHeight: CGFloat = 0.0
    private var cancelButtonTag = 0

    convenience init(withTheme theme: SWAlertControllerTheme, preferredStyle: SWActionSheetStyle, title: String?, message: String? = nil, cancelButton: SWAlertActionStyle, destructiveButton: SWAlertActionStyle?, otherButtons: [SWAlertActionStyle], tapClosure: SWActionSheetTapColsure) {
        self.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .Custom
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .handleAlertActionEnabledDidChangeNotification, name: Handler.AlertActionEnabledDidChangeNotification, object: nil)
        
        self.transitioningDelegate = self
        
        var screenSize = UIScreen.mainScreen().bounds.size
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue < 8.0 {
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                screenSize = CGSize(width: screenSize.height, height: screenSize.width)
            }
        }
        
        // variable for ActionSheet
        if !isAlert() {
            alertViewWidth = screenSize.width
            alertViewPadding = 8.0
            innerContentWidth = (screenSize.height > screenSize.width) ? screenSize.width - alertViewPadding * 2 : screenSize.height - alertViewPadding * 2
            buttonMargin = 8.0
        }
        
        // self.view
        self.view.frame.size = screenSize
        
        // OverlayView
        self.view.addSubview(overlayView)
        
        // ContainerView
        self.view.addSubview(containerView)
        
        // AlertView
        containerView.addSubview(alertView)
        
        // TextAreaScrollView
        alertView.addSubview(textAreaScrollView)
        
        // TextAreaView
        textAreaScrollView.addSubview(textAreaView)
        
        // TextContainer
        textAreaView.addSubview(textContainer)
        
        // ButtonAreaScrollView
        alertView.addSubview(buttonAreaScrollView)
        
        // ButtonAreaView
        buttonAreaScrollView.addSubview(buttonAreaView)
        
        // ButtonContainer
        buttonAreaView.addSubview(buttonContainer)
        
        //------------------------------
        // Layout Constraint
        //------------------------------
        overlayView.translatesAutoresizingMaskIntoConstraints          = false
        containerView.translatesAutoresizingMaskIntoConstraints        = false
        alertView.translatesAutoresizingMaskIntoConstraints            = false
        textAreaScrollView.translatesAutoresizingMaskIntoConstraints   = false
        textAreaScrollView.translatesAutoresizingMaskIntoConstraints   = false
        textContainer.translatesAutoresizingMaskIntoConstraints        = false
        buttonAreaScrollView.translatesAutoresizingMaskIntoConstraints = false
        buttonAreaView.translatesAutoresizingMaskIntoConstraints       = false
        buttonContainer.translatesAutoresizingMaskIntoConstraints      = false
        
        // self.view
        let overlayViewTopSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let overlayViewRightSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let overlayViewLeftSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let overlayViewBottomSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let containerViewTopSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let containerViewRightSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let containerViewLeftSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        containerViewBottomSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([
                overlayViewTopSpaceConstraint,
                overlayViewRightSpaceConstraint,
                overlayViewLeftSpaceConstraint,
                overlayViewBottomSpaceConstraint,
                containerViewTopSpaceConstraint,
                containerViewRightSpaceConstraint,
                containerViewLeftSpaceConstraint,
                containerViewBottomSpaceConstraint])
        
        // MARK: - ContainerView && AlertView Constraint
        if (isAlert()) {
            // ContainerView
            let alertViewCenterXConstraint = NSLayoutConstraint(item: alertView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            let alertViewCenterYConstraint = NSLayoutConstraint(item: alertView, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            containerView.addConstraints([alertViewCenterXConstraint, alertViewCenterYConstraint])
            
            // AlertView
            let alertViewWidthConstraint = NSLayoutConstraint(item: alertView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: alertViewWidth)
            alertViewHeightConstraint = NSLayoutConstraint(item: alertView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 1000.0)
            alertView.addConstraints([
                alertViewWidthConstraint,
                alertViewHeightConstraint])
        } else {
            // ContainerView
            let alertViewCenterXConstraint = NSLayoutConstraint(item: alertView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            let alertViewBottomSpaceConstraint = NSLayoutConstraint(item: alertView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: actionSheetBounceHeight)
            let alertViewWidthConstraint = NSLayoutConstraint(item: alertView, attribute: .Width, relatedBy: .Equal, toItem: containerView, attribute: .Width, multiplier: 1.0, constant: 0.0)
            containerView.addConstraints([
                alertViewCenterXConstraint,
                alertViewBottomSpaceConstraint,
                alertViewWidthConstraint])
            
            // AlertView
            alertViewHeightConstraint = NSLayoutConstraint(item: alertView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 1000.0)
            alertView.addConstraint(alertViewHeightConstraint)
        }
        
        // MARK: - AlertView Constraint
        let textAreaScrollViewTopSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .Top, relatedBy: .Equal, toItem: alertView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let textAreaScrollViewRightSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let textAreaScrollViewLeftSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let textAreaScrollViewBottomSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .Bottom, relatedBy: .Equal, toItem: buttonAreaScrollView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        
        let buttonAreaScrollViewRightSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let buttonAreaScrollViewLeftSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let buttonAreaScrollViewBottomSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .Bottom, relatedBy: .Equal, toItem: alertView, attribute: .Bottom, multiplier: 1.0, constant: isAlert() ? 0.0 : -actionSheetBounceHeight)
        alertView.addConstraints([
            textAreaScrollViewTopSpaceConstraint,
            textAreaScrollViewLeftSpaceConstraint,
            textAreaScrollViewRightSpaceConstraint,
            textAreaScrollViewBottomSpaceConstraint,
            buttonAreaScrollViewRightSpaceConstraint,
            buttonAreaScrollViewLeftSpaceConstraint,
            buttonAreaScrollViewBottomSpaceConstraint])
        
        // MARK: - TextAreaScrollView Constraint
        let textAreaViewTopSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .Top, relatedBy: .Equal, toItem: textAreaScrollView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let textAreaViewRightSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .Right, relatedBy: .Equal, toItem: textAreaScrollView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let textAreaViewBottomSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .Bottom, relatedBy: .Equal, toItem: textAreaScrollView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        textAreaScrollView.addConstraints([
            textAreaViewTopSpaceConstraint, textAreaViewRightSpaceConstraint,
            textAreaViewBottomSpaceConstraint])
        
        // MARK: - TextArea Constraint
        let textAreaViewHeightConstraint = NSLayoutConstraint(item: textAreaView, attribute: .Height, relatedBy: .Equal, toItem: textContainer, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let textContainerTopSpaceConstraint = NSLayoutConstraint(item: textContainer, attribute: .Top, relatedBy: .Equal, toItem: textAreaView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        textAreaView.addConstraints([textAreaViewHeightConstraint, textContainerTopSpaceConstraint])
        
        // MARK: - ButtonAreaScrollView Constraint
        buttonAreaScrollViewHeightConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewTopSpaceConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .Top, relatedBy: .Equal, toItem: buttonAreaScrollView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewLeftSpaceConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .Left, relatedBy: .Equal, toItem: buttonAreaScrollView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewWidthConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .Width, relatedBy: .Equal, toItem: buttonAreaScrollView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        buttonAreaScrollView.addConstraints([buttonAreaScrollViewHeightConstraint, buttonAreaViewTopSpaceConstraint, buttonAreaViewLeftSpaceConstraint, buttonAreaViewWidthConstraint])
        
        // MARK: - ButtonArea Constraint
        let buttonContainerTopSpaceConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .Top, relatedBy: .Equal, toItem: buttonAreaView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let buttonContainerCenterXConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .CenterX, relatedBy: .Equal, toItem: buttonAreaView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        buttonAreaView.addConstraints([buttonContainerTopSpaceConstraint, buttonContainerCenterXConstraint])
        
        // MARK: - ButtonContainer Constraint
        let buttonContainerWidthConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: innerContentWidth)
        buttonContainerHeightConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: buttonHeight)
        buttonContainer.addConstraints([buttonContainerWidthConstraint])
        
        let hasCancelButton = otherButtons.contains {
            switch $0 {
            case .Cancel(_, _, _): return true
            default: return false
            }
        }
        let hasDestructiveButton = otherButtons.contains {
            switch $0 {
            case .Destructive(_, _, _): return true
            default: return false
            }
        }
        if hasCancelButton || hasDestructiveButton {
            fatalError("Others Button has Cancel or Destructive Button. The others button category can only have Default button")
        }
        if destructiveButton == nil {
            buttonStyles = [otherButtons, [cancelButton]].reduce([], combine: +)
            buttons = self.addButtons(withButtons: buttonStyles)
        } else {
            buttonStyles = [otherButtons, [destructiveButton!, cancelButton]].reduce([], combine: +)
            buttons = self.addButtons(withButtons: buttonStyles)
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func isAlert() -> Bool {
        return preferredStyle == .Alert
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!isAlert() && cancelButtonTag != Handler.BaseTag) {
            let tapGesture = UITapGestureRecognizer(target: self, action: .handleContainerViewTapGesture)
            containerView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func addButtons(withButtons buttons: [SWAlertActionStyle]) -> [UIButton] {
        // Add Button
        return buttons.map { (buttonStyle) -> UIButton in
            let button = UIButton()
            button.layer.masksToBounds = true
            button.setTitle(buttonStyle.buttonTitle, forState: .Normal)
            button.layer.cornerRadius = self.theme.shape.cornerRadius
            button.addTarget(self, action: .alertActionButtonTapped, forControlEvents: .TouchUpInside)
            button.tag = Handler.BaseTag + buttons.indexOf { return $0.buttonTitle == buttonStyle.buttonTitle }!
            buttonContainer.addSubview(button)
            return button
        }
    }
    
    // Button Tapped Action
    func buttonTapped(sender: UIButton) {
        
    }
    
    func layoutView() {
        if (layoutFlg) { return }
        layoutFlg = true
        
        //------------------------------
        // Layout & Color Settings
        //------------------------------
        overlayView.backgroundColor = overlayColor
        alertView.backgroundColor = alertViewBackgroundColor
        
        //------------------------------
        // TextArea Layout
        //------------------------------
        let hasTitle: Bool = title != nil && title != ""
        let hasMessage: Bool = message != nil && message != ""
        
        var textAreaPositionY: CGFloat = alertViewPadding
        if (!isAlert()) {textAreaPositionY += alertViewPadding}
        
        // TitleLabel
        if (hasTitle) {
            titleLabel.frame.size = CGSizeMake(innerContentWidth, 0.0)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .Center
            titleLabel.font = titleFont
            titleLabel.textColor = titleTextColor
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.frame = CGRectMake(0, textAreaPositionY, innerContentWidth, titleLabel.frame.height)
            textContainer.addSubview(titleLabel)
            textAreaPositionY += titleLabel.frame.height + 5.0
        }
        
        // MessageView
        if (hasMessage) {
            messageView.frame.size = CGSizeMake(innerContentWidth, 0.0)
            messageView.numberOfLines = 0
            messageView.textAlignment = .Center
            messageView.font = messageFont
            messageView.textColor = messageTextColor
            messageView.text = message
            messageView.sizeToFit()
            messageView.frame = CGRectMake(0, textAreaPositionY, innerContentWidth, messageView.frame.height)
            textContainer.addSubview(messageView)
            textAreaPositionY += messageView.frame.height + 5.0
        }
        
        if (!hasTitle && !hasMessage) {
            textAreaPositionY = 0.0
        }
        
        // TextAreaScrollView
        textAreaHeight = textAreaPositionY
        textAreaScrollView.contentSize = CGSizeMake(alertViewWidth, textAreaHeight)
        
        //------------------------------
        // ButtonArea Layout
        //------------------------------
        var buttonAreaPositionY: CGFloat = buttonMargin
        
        // Buttons
        if (isAlert() && buttons.count == 2) {
            let buttonWidth = (innerContentWidth - buttonMargin) / 2
            var buttonPositionX: CGFloat = 0.0
            
            for button in buttons {
                let idx = buttons.indexOf(button)
                let style = buttonStyles[idx!]
                button.titleLabel?.font = self.theme.buttonFont
                button.setTitleColor(style.buttonTitleColor, forState: .Normal)
                button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Normal)
                button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Highlighted)
                button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Selected)
                button.frame = CGRectMake(buttonPositionX, buttonAreaPositionY, buttonWidth, buttonHeight)
                buttonPositionX += buttonMargin + buttonWidth
            }
            buttonAreaPositionY += buttonHeight
        } else {
            for button in buttons {
                let idx = buttons.indexOf(button)
                let style = buttonStyles[idx!]
                switch style {
                case .Cancel(_, _, _): cancelButtonTag = button.tag
                default:
                    button.titleLabel?.font = self.theme.buttonFont
                    button.setTitleColor(style.buttonTitleColor, forState: .Normal)
                    button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Normal)
                    button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Highlighted)
                    button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Selected)
                    button.frame = CGRectMake(0, buttonAreaPositionY, innerContentWidth, buttonHeight)
                    buttonAreaPositionY += buttonHeight + buttonMargin
                }
            }
            
            // Cancel Button
            if (cancelButtonTag != Handler.BaseTag) {
                if (!isAlert() && buttons.count > 1) {
                    buttonAreaPositionY += buttonMargin
                }
                let button = buttonAreaScrollView.viewWithTag(cancelButtonTag) as! UIButton
                let idx = buttons.indexOf(button)
                let style = buttonStyles[idx! - 1]
                button.titleLabel?.font = self.theme.buttonFont
                button.setTitleColor(style.buttonTitleColor, forState: .Normal)
                button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Normal)
                button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Highlighted)
                button.setBackgroundImage(createImageFromUIColor(style.buttonBackgroundColor), forState: .Selected)
                button.frame = CGRectMake(0, buttonAreaPositionY, innerContentWidth, buttonHeight)
                buttonAreaPositionY += buttonHeight + buttonMargin
            }
            buttonAreaPositionY -= buttonMargin
        }
        buttonAreaPositionY += alertViewPadding
        
        if (buttons.count == 0) {
            buttonAreaPositionY = 0.0
        }
        
        // ButtonAreaScrollView Height
        buttonAreaHeight = buttonAreaPositionY
        buttonAreaScrollView.contentSize = CGSizeMake(alertViewWidth, buttonAreaHeight)
        buttonContainerHeightConstraint.constant = buttonAreaHeight
        
        //------------------------------
        // AlertView Layout
        //------------------------------
        // AlertView Height
        reloadAlertViewHeight()
        alertView.frame.size = CGSizeMake(alertViewWidth, alertViewHeightConstraint.constant)
    }
    
    // Reload AlertView Height
    func reloadAlertViewHeight() {
        
        var screenSize = UIScreen.mainScreen().bounds.size
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue < 8.0) {
            if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)) {
                screenSize = CGSizeMake(screenSize.height, screenSize.width)
            }
        }
        let maxHeight = screenSize.height - keyboardHeight
        
        // for avoiding constraint error
        buttonAreaScrollViewHeightConstraint.constant = 0.0
        
        // AlertView Height Constraint
        var alertViewHeight = textAreaHeight + buttonAreaHeight
        if (alertViewHeight > maxHeight) {
            alertViewHeight = maxHeight
        }
        if (!isAlert()) {
            alertViewHeight += actionSheetBounceHeight
        }
        alertViewHeightConstraint.constant = alertViewHeight
        
        // ButtonAreaScrollView Height Constraint
        var buttonAreaScrollViewHeight = buttonAreaHeight
        if (buttonAreaScrollViewHeight > maxHeight) {
            buttonAreaScrollViewHeight = maxHeight
        }
        buttonAreaScrollViewHeightConstraint.constant = buttonAreaScrollViewHeight
    }
    
    // Handle ContainerView tap gesture
    func handleContainerViewTapGesture(sender: AnyObject) {
        // cancel action
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension SWAlertController {
    
    // UIColor -> UIImage
    func createImageFromUIColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let contextRef: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(contextRef, color.CGColor)
        CGContextFillRect(contextRef, rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    @objc func handleAlertActionEnabledDidChangeNotification(aNotification: NSNotification) {
        
    }
    
    // MARK: UIViewControllerTransitioningDelegate Methods
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        layoutView()
        return SWAlertAnimation(isPresenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SWAlertAnimation(isPresenting: false)
    }
}
