//
//  ScrollPageViewController.swift
//  ScrollPage
//
//  Created by 洪德晟 on 2017/8/2.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

/// Attribute Dictionary Keys. These keys are used to customize the UI elements of View.

/**
 Take UIFont as value. Set font of Tab button titleLabel Font.
 */
public let SMFontAttribute = "kFontAttribute"

/**
 Take UIColor as value. Set color of Tab button titleLabel Font.
 */
public let SMForegroundColorAttribute = "kForegroundColorAttribute"

/**
 Take UIColor as value. Set background color of any View.
 */
public let SMBackgroundColorAttribute = "kBackgroundColorAttribute"

/**
 Take UIColor as value. Set color of Tab button titleLabel Font when it is unselected or out of focus.
 */
public let SMUnselectedColorAttribute = "kUnselectedColorAttribute"

/// Take CGFlaot as value. Set alpha of any View.
public let SMAlphaAttribute = "kAlphaAttribute"

/// Take UIImage as value. Set image of any View.
public let SMBackgroundImageAttribute = "kBackgroundImageAttribute"

/// Take Array of Strings(image_name) as value. Set button image for normal state.
public let SMButtonNormalImagesAttribute = "kButtonNormalImageAttribute"

/// Take Array of Strings(image_name) as value. Set button image for highlighted state.
public let SMButtonHighlightedImagesAttribute = "kButtonHighlightedImageAttribute"

/// Take Bool as value. Set title label of tab bar button hidden.
public let SMButtonHideTitleAttribute = "kButtonShowTitleAttribute" // Set Bool instance

/// Swipe constant
public var kSelectionBarSwipeConstant: CGFloat = 4.5

public protocol ScrollPageViewControllerDelegate {
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController
}

open class ScrollPageViewController: UIViewController {
    
    /// To set the height of segment bar(Top swipable tab bar).
    open var segementBarHeight: CGFloat = 44.0
    
    /// To set the margin beteen the buttons or tabs in the scrollable tab bar
    open var buttonPadding: CGFloat = 8.0
    
    /// To set the fixed width of the button/tab in the tab bar
    open var buttonWidth: CGFloat?
    
    /** To set the height of the selection bar
     Selection bar can be seen under the tab
     */
    open var selectionBarHeight: CGFloat = 4.0
    
    /** To set the background color of the tab bar.
     Default color is black color. You can change the color as per your need.
     */
    open var defaultSegmentBarBgColor = UIColor.black
    
    /** To set the background color of the selection bar.
     Default color is red color. You can change the color as per your need.
     */
    open var defaultSelectionBarBgColor = UIColor.red
    
    /** To set the background color of the selection bar.
     Default color is orange color. You can change the color as per your need.
     */
    open var defaultSelectedButtonForegroundColor = UIColor.orange
    
    /** To set the background color of the selection bar.
     Default color is red color. You can change the color as per your need.
     */
    open var defaultUnSelectedButtonForegroundColor = UIColor.gray
    
    ///Dictionary to set button attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
     - Usage:
     buttonAttributes = [
     SMBackgroundColorAttribute : UIColor.clearColor(),
     SMAlphaAttribute : 0.8,
     SMButtonHideTitleAttribute : true,
     SMButtonNormalImagesAttribute :["image_name1", "image_name2"] as [String]),
     SMButtonHighlightedImagesAttribute : ["high_image_name1", "high_image_name2"] as [String])
     ]
     */
    open var buttonAttributes: [String : AnyObject]?
    
    ///Dictionary to set tab bar attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
     - Usage:
     segmentBarAttributes = [
     SMBackgroundColorAttribute : UIColor.greenColor(),
     ]
     */
    open var segmentBarAttributes: [String : AnyObject]?
    
    ///Dictionary to selection bar attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
     - Usage:
     segmentBarAttributes = [
     SMBackgroundColorAttribute : UIColor.greenColor(),
     SMAlphaAttribute : 0.8
     ]
     */
    open var selectionBarAttributes: [String : AnyObject]?
    
    /// To set the frame of the view.
    open var viewFrame : CGRect?
    
    /// Array of tab Bar Buttons (Text need to display)
    open var titleBarDataSource: [String]?
    
    /// Delegate of viewController. Set the delegate to load the viewController at new index.
    open var delegate: ScrollPageViewControllerDelegate?
    
    //Fixed
    fileprivate var segmentBarView = UIScrollView()
    fileprivate lazy var selectionBar = UIView()
    
    fileprivate var buttonsFrameArray = [CGRect]()
    fileprivate var lastPageIndex = 0
    open var currentPageIndex = 0 {
        didSet {
            updateButtonColorOnSelection()
            lastPageIndex = currentPageIndex
        }
    }
    fileprivate let contentSizeOffset: CGFloat = 10.0
    fileprivate var pageScrollView: UIScrollView!
    
    fileprivate var currentOrientationIsPortrait : Bool = true
    
    private func setUpScrollView() {
        
        pageScrollView = UIScrollView()
        guard let titleBarDataSource = titleBarDataSource else { return }
        pageScrollView.frame = CGRect(x: 0, y: segementBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - segementBarHeight - 64)
        pageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(titleBarDataSource.count), height: pageScrollView.bounds.size.height)
        pageScrollView.isPagingEnabled = true
        pageScrollView.delegate = self
        pageScrollView.backgroundColor = UIColor.white
        
        view.addSubview(pageScrollView)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        if let frame = viewFrame {
            self.view.frame = frame
        }
        
        segmentBarView.layer.shadowColor = UIColor.gray.cgColor
        segmentBarView.layer.masksToBounds = false
        segmentBarView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        segmentBarView.layer.shadowRadius = 3.0
        segmentBarView.layer.shadowOpacity = 0.5
        
        setupSegmentBarButtons()
        self.view.addSubview(segmentBarView)
        
        setUpScrollView()
        if viewControllerAtIndex(0) != nil {
            var viewControllers = [UIViewController]()

            
            guard let titleBarDataSource = titleBarDataSource else { return }
            for i in 0 ..< titleBarDataSource.count {
                if let viewController = viewControllerAtIndex(i) {
                    viewControllers.append(viewController)
                }
            }
            for i in 0 ..< titleBarDataSource.count {
                self.addChild(viewControllers[i])
                self.pageScrollView.addSubview(viewControllers[i].view)

                let pageViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height-segementBarHeight)
                viewControllers[i].view.sizeThatFits(pageViewSize)
                viewControllers[i].view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(i), y: 0)
                viewControllers[i].didMove(toParent: self)
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSegmentBar()
    }
    
    fileprivate func setupSegmentBar() {
        if self.view.subviews.contains(segmentBarView) {
            segmentBarView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            segmentBarView.layer.removeFromSuperlayer()
            segmentBarView.removeFromSuperview()
        }
        
        segmentBarView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: segementBarHeight)
        segmentBarView.isScrollEnabled = true
        segmentBarView.showsHorizontalScrollIndicator = false
        segmentBarView.backgroundColor = defaultSegmentBarBgColor
        
        if let attributes = segmentBarAttributes {
            if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                segmentBarView.backgroundColor = bgColor
            }
            
            if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                segmentBarView.backgroundColor = UIColor(patternImage: bgImage)
            }
        }
        
        setupSegmentBarButtons()
        self.view.addSubview(segmentBarView)
        setupSelectionBar()
    }
    
    fileprivate func setupSegmentBarButtons() {
        if let buttonList = titleBarDataSource {
            buttonsFrameArray.removeAll()
            for i in 0 ..< buttonList.count {
                
                let previousButtonX = i > 0 ? buttonsFrameArray[i-1].origin.x : 0.0
                let previousButtonW = i > 0 ? buttonsFrameArray[i-1].size.width : 0.0
                
                let segmentButton = UIButton(frame: CGRect(x: previousButtonX + previousButtonW + buttonPadding, y: 0.0, width: getWidthForText(buttonList[i]) + buttonPadding, height: segementBarHeight))
                buttonsFrameArray.append(segmentButton.frame)
                segmentButton.setTitle(buttonList[i], for: UIControl.State())
                segmentButton.tag = i
                segmentButton.addTarget(self, action: #selector(ScrollPageViewController.didSegmentButtonTap(_:)), for: .touchUpInside)
                
                if let attributes = buttonAttributes {
                    if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                        segmentButton.backgroundColor = bgColor
                    }
                    
                    if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                        segmentButton.setBackgroundImage(bgImage, for: UIControl.State())
                    }
                    
                    if let normalImages = attributes[SMButtonNormalImagesAttribute] as? [String] {
                        segmentButton.setImage(UIImage(named: normalImages[i]), for: UIControl.State())
                    }
                    
                    if let highlightedImages = attributes[SMButtonHighlightedImagesAttribute] as? [String] {
                        segmentButton.setImage(UIImage(named: highlightedImages[i]), for: .selected)
                    }
                    
                    if let hideTitle = attributes[SMButtonHideTitleAttribute] as? Bool, hideTitle == true{
                        segmentButton.titleLabel?.isHidden = true
                        segmentButton.setTitle("", for: UIControl.State())
                    }
                    else{
                        segmentButton.titleLabel?.isHidden = false
                    }
                    
                    if let font = attributes[SMFontAttribute] as? UIFont {
                        segmentButton.titleLabel?.font = font
                    }
                    
                    if let foregroundColor = attributes[SMForegroundColorAttribute] as? UIColor, currentPageIndex == i{
                        segmentButton.setTitleColor(foregroundColor, for: UIControl.State())
                    }
                    else if let unSelectedForegroundColor = attributes[SMUnselectedColorAttribute] as? UIColor, currentPageIndex != i{
                        segmentButton.setTitleColor(unSelectedForegroundColor, for: UIControl.State())
                    }
                    else {
                        segmentButton.setTitleColor(defaultUnSelectedButtonForegroundColor, for: UIControl.State())
                    }
                    
                    if let alpha = attributes[SMAlphaAttribute] as? CGFloat {
                        segmentButton.alpha = alpha
                    }
                }
                else {
                    segmentButton.setTitleColor(currentPageIndex == i ? defaultSelectedButtonForegroundColor : defaultUnSelectedButtonForegroundColor , for: UIControl.State())
                }
                
                segmentBarView.addSubview(segmentButton)
                
                if i == buttonList.count-1 {
                    segmentBarView.contentSize = CGSize(width:buttonsFrameArray[i].origin.x + buttonsFrameArray[i].size.width + contentSizeOffset, height: segementBarHeight)
                }
            }
        }
    }
    
    fileprivate func setupSelectionBar() {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.setupSelectionBarFrame(self.currentPageIndex)
        }
        
        selectionBar.backgroundColor = defaultSelectionBarBgColor
        if let attributes = selectionBarAttributes {
            if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                selectionBar.backgroundColor = bgColor
            }
            else {
                selectionBar.backgroundColor = defaultSelectionBarBgColor
            }
            
            if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                segmentBarView.backgroundColor = UIColor(patternImage: bgImage)
            }
            
            if let alpha = attributes[SMAlphaAttribute] as? CGFloat {
                selectionBar.alpha = alpha
            }
        }
        
        segmentBarView.addSubview(selectionBar)
    }
    
    fileprivate func setupSelectionBarFrame(_ index: Int) {
        if buttonsFrameArray.count > 0 {
            let previousButtonX = index > 0 ? buttonsFrameArray[index-1].origin.x : 0.0
            let previousButtonW = index > 0 ? buttonsFrameArray[index-1].size.width : 0.0
            
            selectionBar.frame = CGRect(x: previousButtonX + previousButtonW + buttonPadding, y: segementBarHeight - selectionBarHeight, width: buttonsFrameArray[index].size.width, height: selectionBarHeight)
        }
    }
    
    fileprivate func getWidthForText(_ text: String) -> CGFloat {
        return buttonWidth ?? ceil((text as NSString).size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 17.0)])).width)
    }
    
    fileprivate func updateButtonColorOnSelection() {
        var indicatorBtns = [UIButton]()
        for button in segmentBarView.subviews {
            if button is UIButton {
                indicatorBtns.append(button as! UIButton)
            }
        }
        indicatorBtns[self.lastPageIndex].setTitleColor(UIColor.lightGray, for: UIControl.State())
        indicatorBtns[self.currentPageIndex].setTitleColor(UIColor.orange, for: UIControl.State())
    }
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard let titleBarDataSource = titleBarDataSource else { return nil }
        if titleBarDataSource.count == 0 || index >= titleBarDataSource.count {
            return nil
        }
        let viewController = delegate?.didLoadViewControllerAtIndex(index)
        viewController?.view.tag = index
        return viewController
    }
    
    //MARK : Segment Button Action
    @objc func didSegmentButtonTap(_ sender: UIButton) {
        currentPageIndex = sender.tag
        
        let offset = UIScreen.main.bounds.width * CGFloat(currentPageIndex)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.pageScrollView.contentOffset.x = offset
        })
        
        let xFromCenter: CGFloat = (self.pageScrollView.frame.size.width * CGFloat(currentPageIndex)) - self.pageScrollView.contentOffset.x
        let xCoor = buttonsFrameArray[currentPageIndex].origin.x
        UIView.animate(withDuration: 0.05) { [unowned self] in
            self.selectionBar.frame = CGRect(x: xCoor-xFromCenter/kSelectionBarSwipeConstant, y: self.selectionBar.frame.origin.y, width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: self.selectionBar.frame.size.height)
        }
    }
    
    // MARK: - Orientation Change
    
    override open func viewDidLayoutSubviews() {
        
        guard let titleBarDataSource = titleBarDataSource else { return }
        pageScrollView.frame = CGRect(x: 0, y: segementBarHeight, width: self.view.frame.width, height: self.view.frame.height)
        pageScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(titleBarDataSource.count), height: self.view.frame.height)
        
        let oldCurrentOrientationIsPortrait : Bool = currentOrientationIsPortrait
        
        if UIDevice.current.orientation != UIDeviceOrientation.unknown {
            currentOrientationIsPortrait = UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat
        }
        
        segmentBarView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: segementBarHeight)
        
        if (oldCurrentOrientationIsPortrait && UIDevice.current.orientation.isLandscape) || (!oldCurrentOrientationIsPortrait && (UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat)) {
            
            for i in 0 ..< titleBarDataSource.count {
                if i == titleBarDataSource.count-1 {
                    segmentBarView.contentSize = CGSize(width:buttonsFrameArray[i].origin.x + buttonsFrameArray[i].size.width + contentSizeOffset, height: segementBarHeight)
                }
            }
            
            for view in pageScrollView.subviews where view.frame.width == pageScrollView.frame.width {
                view.frame = CGRect(x: self.view.frame.width * CGFloat(view.tag), y: 0, width: pageScrollView.frame.width, height: pageScrollView.frame.height)
                print(view)
            }
            
            let xOffset : CGFloat = CGFloat(self.currentPageIndex) * pageScrollView.frame.width
            pageScrollView.setContentOffset(CGPoint(x: xOffset, y: pageScrollView.contentOffset.y), animated: false)
        }
        
        self.view.layoutIfNeeded()
    }

}

//MARK: - UIScrollViewDelegate

extension ScrollPageViewController: UIScrollViewDelegate {
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) /
            pageWidth)) + 1
        guard let titleBarDataSource = titleBarDataSource else { return }
        guard page < titleBarDataSource.count && page > -1  else {
            return
        }
        currentPageIndex = page
        
        let xFromCenter: CGFloat = (self.pageScrollView.frame.size.width * CGFloat(currentPageIndex)) - scrollView.contentOffset.x
        let xCoor = buttonsFrameArray[currentPageIndex].origin.x
        UIView.animate(withDuration: 0.05) { [unowned self] in
            self.selectionBar.frame = CGRect(x: xCoor-xFromCenter/kSelectionBarSwipeConstant, y: self.selectionBar.frame.origin.y, width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: self.selectionBar.frame.size.height)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
