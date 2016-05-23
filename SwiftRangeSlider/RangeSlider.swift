//
//  RangeSlider.swift
//  SwiftRangeSlider
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import QuartzCore
@IBDesignable public class RangeSlider: UIControl {
  
  @IBInspectable public var minimumValue: Double = 0.0 {
    didSet {
      updateLayerFrames()
    }
  }
  
  @IBInspectable public var maximumValue: Double = 1.0 {
    didSet {
      updateLayerFrames()
    }
  }
  
  @IBInspectable public var lowerValue: Double = 0.2 {
    didSet {
      updateLayerFrames()
    }
  }
  
  @IBInspectable public var upperValue: Double = 0.8 {
    didSet {
      updateLayerFrames()
    }
  }
  
  @IBInspectable public var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  @IBInspectable public var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  @IBInspectable public var trackThickness: CGFloat = 0.1 {
    didSet {
      updateLayerFrames()
    }
  }
  
  @IBInspectable public var thumbTintColor: UIColor = UIColor.whiteColor() {
    didSet {
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }
  
  @IBInspectable public var curvaceousness: CGFloat = 1.0 {
    didSet {
      trackLayer.setNeedsDisplay()
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }
  
  var previousLocation = CGPoint()
  
  let trackLayer = RangeSliderTrackLayer()
  let lowerThumbLayer = RangeSliderThumbLayer()
  let upperThumbLayer = RangeSliderThumbLayer()
  
  var thumbWidth: CGFloat {
    return CGFloat(bounds.height)
  }
  
  override public var frame: CGRect {
    didSet {
      updateLayerFrames()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addContentViews()
  }
  
  required public init(coder: NSCoder) {
    super.init(coder: coder)!
    addContentViews()
  }
  
  func addContentViews(){
    trackLayer.rangeSlider = self
    trackLayer.contentsScale = UIScreen.mainScreen().scale
    layer.addSublayer(trackLayer)
    
    lowerThumbLayer.rangeSlider = self
    lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
    layer.addSublayer(lowerThumbLayer)
    
    upperThumbLayer.rangeSlider = self
    upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
    layer.addSublayer(upperThumbLayer)
  }
  
  public func updateLayerFrames() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    let newTrackDy = (frame.height - frame.height * trackThickness) / 2
    trackLayer.frame = CGRect(x: 0, y: newTrackDy, width: frame.width, height: frame.height * trackThickness)
    trackLayer.setNeedsDisplay()
    
    let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
    
    lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
                                   width: thumbWidth, height: thumbWidth)
    lowerThumbLayer.setNeedsDisplay()
    
    let upperThumbCenter = CGFloat(positionForValue(upperValue))
    upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                   width: thumbWidth, height: thumbWidth)
    upperThumbLayer.setNeedsDisplay()
    CATransaction.commit()
  }
  
  func positionForValue(value: Double) -> Double {
    return Double(bounds.width - thumbWidth) * (value - minimumValue) /
      (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
  }
  
  func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
    return min(max(value, lowerValue), upperValue)
  }
  
  override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    previousLocation = touch.locationInView(self)
    
    if lowerThumbLayer.frame.contains(previousLocation) {
      lowerThumbLayer.highlighted = true
    } else if upperThumbLayer.frame.contains(previousLocation) {
      upperThumbLayer.highlighted = true
    }
    
    return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
  }
  
  override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    let location = touch.locationInView(self)
    
    let deltaLocation = Double(location.x - previousLocation.x)
    let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
    
    previousLocation = location
    
    if lowerThumbLayer.highlighted {
      lowerValue += deltaValue
      lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
    } else if upperThumbLayer.highlighted {
      upperValue += deltaValue
      upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
    }
    
    sendActionsForControlEvents(.ValueChanged)
        
    return true
  }
  
  override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    lowerThumbLayer.highlighted = false
    upperThumbLayer.highlighted = false
  }
}
