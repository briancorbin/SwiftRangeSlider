//
//  RangeSlider.swift
//  SwiftRangeSlider
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import QuartzCore


///Class that represents the RangeSlider object.
@IBDesignable open class RangeSlider: UIControl {
  
  // MARK: - Properties
  
  ///The minimum value selectable on the RangeSlider
  @IBInspectable open var minimumValue: Double = 0.0 {
    didSet {
      updateLayerFrames()
    }
  }
  ///The maximum value selectable on the RangeSlider
  @IBInspectable open var maximumValue: Double = 1.0 {
    didSet {
      updateLayerFrames()
    }
  }
  
  ///The current lower value selected on the RangeSlider
  @IBInspectable open var lowerValue: Double = 0.2 {
    didSet {
      updateLayerFrames()
    }
  }
  
  ///The current upper value selected on the RangeSlider
  @IBInspectable open var upperValue: Double = 0.8 {
    didSet {
      updateLayerFrames()
    }
  }
  
  ///The color of the track bar outside of the selected range
  @IBInspectable open var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  ///The color of the track bar within the selected range
  @IBInspectable open var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  ///the thickness of the track bar. `0.1` by default.
  @IBInspectable open var trackThickness: CGFloat = 0.1 {
    didSet {
      updateLayerFrames()
    }
  }
  
  ///The color of the slider buttons. `White` by default.
  @IBInspectable open var thumbTintColor: UIColor = UIColor.white {
    didSet {
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }
  
  ///The thickness of the slider buttons border. `0.1` by default.
  @IBInspectable open var thumbBorderThickness: CGFloat = 0.1 {
    didSet {
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }
  
  ///Whether or not the slider buttons have a shadow. `true` by default.
  @IBInspectable open var thumbHasShadow: Bool = true {
    didSet{
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }
  
  ///The curvaceousness of the ends of the track bar and the slider buttons. `1.0` by default.
  @IBInspectable open var curvaceousness: CGFloat = 1.0 {
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
  
  ///The frame of the `RangeSlider` instance.
  override open var frame: CGRect {
    didSet {
      updateLayerFrames()
    }
  }
  
  // MARK: - Lifecycle
  
  /**
   Initializes the `RangeSlider` instance with the specified frame.
   
   - returns: The new `RangeSlider` instance.
   */
  override public init(frame: CGRect) {
    super.init(frame: frame)
    addContentViews()
  }
  
  /**
   Initializes the `RangeSlider` instance from the storyboard.
   
   - returns: The new `RangeSlider` instance.
   */
  required public init(coder: NSCoder) {
    super.init(coder: coder)!
    addContentViews()
  }
  
  func addContentViews(){
    trackLayer.rangeSlider = self
    trackLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(trackLayer)
    
    lowerThumbLayer.rangeSlider = self
    lowerThumbLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(lowerThumbLayer)
    
    upperThumbLayer.rangeSlider = self
    upperThumbLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(upperThumbLayer)
  }
  
  // MARK: Member Functions
  
  
  ///Updates all of the layer frames that make up the `RangeSlider` instance.
  open func updateLayerFrames() {
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
  
  func positionForValue(_ value: Double) -> Double {
    return Double(bounds.width - thumbWidth) * (value - minimumValue) /
      (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
  }
  
  func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
    return min(max(value, lowerValue), upperValue)
  }
  
  /**
   Triggers on touch of the `RangeSlider` and checks whether either of the slider buttons have been touched and sets their `highlighted` property to true.
   
   - returns: A bool indicating if either of the slider buttons were inside of the `UITouch`.
 */
  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    previousLocation = touch.location(in: self)
    
    if lowerThumbLayer.frame.contains(previousLocation) {
      lowerThumbLayer.highlighted = true
    } else if upperThumbLayer.frame.contains(previousLocation) {
      upperThumbLayer.highlighted = true
    }
    
    return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
  }
  
  /**
   Triggers on a continued touch of the `RangeSlider` and updates the value corresponding with the new button location.
   
   - returns: A bool indicating success.
   */
  
  override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)
    
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
    
    sendActions(for: .valueChanged)
        
    return true
  }
  
  /**
   Triggers on the end of touch of the `RangeSlider` and sets the button layers `highlighted` property to `false`.
   */
  override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    lowerThumbLayer.highlighted = false
    upperThumbLayer.highlighted = false
  }
}
