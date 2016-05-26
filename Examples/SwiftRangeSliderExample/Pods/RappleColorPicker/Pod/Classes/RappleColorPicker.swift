/* **
RappleColorPicker.swift
Custom Activity Indicator with swift 2.0

Created by Rajeev Prasad on 28/11/15.

The MIT License (MIT)

Copyright (c) 2015 Rajeev Prasad <rjeprasad@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
** */

import UIKit

/**
 RappleColorPickerDelegate public delegate
 */
@objc
public protocol RappleColorPickerDelegate: NSObjectProtocol {
    /**
     Retrieve selected color from color picker
     */
    optional func colorSelected(color:UIColor)
    optional func colorSelected(color:UIColor, tag: Int)
}

/**
 RappleColorPicker attribute keys
 case Title     Title text
 case BGColor   Background color
 case Style     Cell style (Square, Circle)
 case TintColor Tint Color (Text color, cell border color)
 */
public enum RappleCPAttributeKey : String {
    case Title = "Title"
    case BGColor = "BGColor"
    case Style = "Style"
    case TintColor = "TintColor"
}

public let RappleCPStyleSquare = "Square"
public let RappleCPStyleCircle = "Circle"

/**
 RappleColorPicker - Easy to use color pricker for iOS apps
 */
public class RappleColorPicker: NSObject {
    
    private var colorVC : RappleColorPickerViewController?
    private var background : UIView?
    private var closeButton : UIButton?
    
    private static let sharedInstance = RappleColorPicker()
    
    /**
     Open color picker with default look and feel
     Color picker size - W(218) x H(352) fixed size for now
     @param     onViewController opening viewController
     @param     origin origin point of the color pallet
     @param     delegate RappleColorPickerDelegate
     @param     title color pallet name default "Color Picker"
     @param     tag
     */
    
    public class func openColorPallet(onViewController vc: UIViewController, origin: CGPoint, delegate:RappleColorPickerDelegate, title:String?) {
        RappleColorPicker.openColorPallet(onViewController: vc, origin: origin, delegate: delegate, title: title, tag: 0)
    }
    
    /**
     Open color picker with default look and feel
     Color picker size - W(218) x H(352) fixed size for now
     */
    public class func openColorPallet(onViewController vc: UIViewController, origin: CGPoint, delegate:RappleColorPickerDelegate, title:String?, tag: Int) {
        var attributes : [RappleCPAttributeKey : AnyObject]?
        if title != nil {
            attributes = [.Title : title!]
        }
        
        RappleColorPicker.openColorPallet(onViewController: vc, origin: origin, delegate: delegate, attributes: attributes, tag: tag)
    }
    
    /**
     Open color picker with custom look and feel (optional)
     Color picker size - W(218) x H(352) fixed size for now
     @param     onViewController opening viewController
     @param     origin origin point of the color pallet
     @param     delegate RappleColorPickerDelegate
     @param     attributes look and feel attribute (Title, BGColor, TintColor, Style)
     @param     tag
     */
    public class func openColorPallet(onViewController vc: UIViewController, origin: CGPoint, delegate:RappleColorPickerDelegate, attributes:[RappleCPAttributeKey:AnyObject]?) {
        RappleColorPicker.openColorPallet(onViewController: vc, origin: origin, delegate: delegate, attributes: attributes, tag: 0)
    }
    
    /**
     Open color picker with custom look and feel (optional)
     Color picker size - W(218) x H(352) fixed size for now
     */
    public class func openColorPallet(onViewController vc: UIViewController, origin: CGPoint, delegate:RappleColorPickerDelegate, attributes:[RappleCPAttributeKey:AnyObject]?, tag: Int) {
        
        let this = RappleColorPicker.sharedInstance
        
        var title = attributes?[.Title] as? String; if title == nil { title = "Color Picker" }
        var bgColor = attributes?[.BGColor] as? UIColor; if bgColor == nil { bgColor = UIColor.darkGrayColor() }
        var tintColor = attributes?[.TintColor] as? UIColor; if tintColor == nil { tintColor = UIColor.whiteColor() }
        var style = attributes?[.Style] as? String; if style == nil { style = RappleCPStyleCircle }
        
        let attrib : [RappleCPAttributeKey:AnyObject] = [
            .Title : title!,
            .BGColor  : bgColor!,
            .TintColor : tintColor!,
            .Style  : style!
        ]
        
        this.background = UIView(frame: vc.view.bounds)
        this.background?.backgroundColor = UIColor.clearColor()
        vc.view.addSubview(this.background!)
        
        this.closeButton = UIButton(frame: this.background!.bounds)
        this.closeButton?.addTarget(this, action: "closeTapped", forControlEvents: .TouchUpInside)
        this.background?.addSubview(this.closeButton!)
        
        var point = CGPointMake(origin.x, origin.y)
        if origin.x < 0 { point.x = 0 }
        if origin.y < 0 { point.y = 0 }
        if origin.x + 224 > vc.view.bounds.width { point.x = vc.view.bounds.width - 224 }
        if origin.y + 354 > vc.view.bounds.height { point.y = vc.view.bounds.height - 354 }
        
        this.colorVC = RappleColorPickerViewController()
        this.colorVC?.delegate = delegate
        this.colorVC?.attributes = attrib
        this.colorVC?.tag = tag
        this.colorVC!.view.frame = CGRectMake(point.x, point.y, 222, 352)
        this.background!.addSubview(this.colorVC!.view)
        
    }
    
    /**
     Close color picker Class func
     */
    public class func close(){
        let this = RappleColorPicker.sharedInstance
        this.closeTapped()
    }
    
    /**
     Close color picker
     */
    internal func closeTapped(){
        self.background?.removeFromSuperview()
        self.colorVC = nil
        self.closeButton = nil
        self.background = nil
    }
}
