//
//  RangeSlider.swift
//  SwiftRangeSlider
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import QuartzCore

enum Knob {
  case Neither
  case Lower
  case Upper
  case Both
}

///Class that represents the RangeSlider object.
@IBDesignable open class RangeSlider: UIControl {
  
  // MARK: - Properties
  
  ///The minimum value selectable on the RangeSlider
  @IBInspectable open var minimumValue: Double = 0.0 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///The maximum value selectable on the RangeSlider
  @IBInspectable open var maximumValue: Double = 1.0 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///The minimum difference in value between the Knobs
  @IBInspectable open var minimumDistance: Double = 0.0 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///The current lower value selected on the RangeSlider
  @IBInspectable open var lowerValue: Double = 0.2 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///The current upper value selected on the RangeSlider
  @IBInspectable open var upperValue: Double = 0.8 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///The minimum value a Knob can change. Default and minimum of 0
  @IBInspectable open var stepValue: Double = 0.0 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
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
  
  ///the thickness of the track bar. `0.05` by default.
  @IBInspectable open var trackThickness: CGFloat = 0.05 {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///Whether the track thickness is true or proportional to its containers frame height
  @IBInspectable open var trueTrackThickness: Bool = false {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
    }
  }
  
  ///The diameter of the knob. '0.95' by default.
  @IBInspectable open var knobSize: CGFloat = 0.95 {
    didSet {
      updateLayerFramesAndPositions()
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsDisplay()
    }
  }
  
  ///Whether the knob size is true or proportional to its containers frame height
  @IBInspectable open var trueKnobSize: Bool = false {
    didSet {
      updateLayerFramesAndPositions()
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsDisplay()
    }
  }
  
  ///The color of the slider buttons. `White` by default.
  @IBInspectable open var knobTintColor: UIColor = UIColor.white {
    didSet {
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsDisplay()
    }
  }
  
  ///The thickness of the slider buttons border. `0.1` by default.
  @IBInspectable open var knobBorderThickness: CGFloat = 0.1 {
    didSet {
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsDisplay()
    }
  }
  
  ///The color of the knob borders. `UIColor.gray` by default.
  @IBInspectable open var knobBorderTintColor: UIColor = UIColor.gray {
    didSet {
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsLayout()
    }
  }
  
  ///The size to multiply the knob by on selection. `1.0` by default.
  @IBInspectable open var selectedKnobDiameterMultiplier: CGFloat = 1.0 {
    didSet {
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsLayout()
    }
  }
  
  ///Whether or not the slider buttons have a shadow. `true` by default.
  @IBInspectable open var knobHasShadow: Bool = true {
    didSet{
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsDisplay()
    }
  }
  
  ///The curvaceousness of the ends of the track bar and the slider buttons. `1.0` by default.
  @IBInspectable open var curvaceousness: CGFloat = 1.0 {
    didSet {
      trackLayer.setNeedsDisplay()
      lowerKnobLayer.setNeedsDisplay()
      upperKnobLayer.setNeedsDisplay()
    }
  }
  
  ///Whether or not you can drag the highligh area to move both Knobs at the same time.
  @IBInspectable open var dragTrack: Bool = false
  
  var previousLocation = CGPoint()
  var previouslySelectedKnob = Knob.Neither
  
  let trackLayer = RangeSliderTrackLayer()
  let lowerKnobLayer = RangeSliderKnobLayer()
  let upperKnobLayer = RangeSliderKnobLayer()
  
  var TrackThickness: CGFloat {
    get {
      return trueTrackThickness ? trackThickness : trackThickness * bounds.height
    }
  }
  
  var KnobSize: CGFloat {
    get {
      return trueKnobSize ? knobSize : knobSize * bounds.height
    }
  }
  
  ///The frame of the `RangeSlider` instance.
  override open var frame: CGRect {
    didSet {
      updateTrackLayerFrameAndKnobPositions()
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
    
    lowerKnobLayer.frame = CGRect(x: 0, y: 0, width: KnobSize, height: KnobSize)
    lowerKnobLayer.rangeSlider = self
    lowerKnobLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(lowerKnobLayer)
    
    upperKnobLayer.frame = CGRect(x: 0, y: 0, width: KnobSize, height: KnobSize)
    upperKnobLayer.rangeSlider = self
    upperKnobLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(upperKnobLayer)
  }
  
  // MARK: Member Functions
  
  open func updateLayerFramesAndPositions() {
    lowerKnobLayer.frame = CGRect(x: 0, y: 0, width: KnobSize, height: KnobSize)
    upperKnobLayer.frame = CGRect(x: 0, y: 0, width: KnobSize, height: KnobSize)
    updateTrackLayerFrameAndKnobPositions()
  }
  
  ///Updates all of the layer frames that make up the `RangeSlider` instance.
  open func updateTrackLayerFrameAndKnobPositions() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    let newTrackDy = (frame.height - TrackThickness) / 2
    trackLayer.frame = CGRect(x: 0, y: newTrackDy, width: frame.width, height: TrackThickness)
    trackLayer.setNeedsDisplay()
    
    let lowerKnobCenter = positionForValue(lowerValue)
    lowerKnobLayer.position = lowerKnobCenter
    lowerKnobLayer.setNeedsDisplay()
    
    let upperKnobCenter = positionForValue(upperValue)
    upperKnobLayer.position = upperKnobCenter
    upperKnobLayer.setNeedsDisplay()
    CATransaction.commit()
  }
  
  func percentageForValue(_ value: Double) -> CGFloat {
    if minimumValue == maximumValue {
      return 0
    }
    
    let maxMinDiff = maximumValue - minimumValue
    let valueSubtracted = value - minimumValue
    
    return CGFloat(valueSubtracted / maxMinDiff)
  }
  
  /**
   Returns the position of the Knob to be placed on the slider given the value it should be on the slider
 */
  func positionForValue(_ value: Double) -> CGPoint {
    if maximumValue == minimumValue {
      return CGPoint(x: 0, y: 0)
    }
    
    let percentage = percentageForValue(value)
    
    let xPosition = bounds.width * percentage
    
//    let yPosition = bounds.height / 2
    let yPosition = trackLayer.frame.midY
    
    return CGPoint(x: xPosition, y: yPosition)
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
    
    if lowerKnobLayer.frame.contains(previousLocation) && upperKnobLayer.frame.contains(previousLocation) && (previouslySelectedKnob == Knob.Lower || previouslySelectedKnob == Knob.Neither) {
      lowerKnobLayer.highlighted = true
      previouslySelectedKnob = Knob.Lower
      animateKnob(knob: lowerKnobLayer, selected: true)
      return true
    }
    
    if lowerKnobLayer.frame.contains(previousLocation) && upperKnobLayer.frame.contains(previousLocation) && previouslySelectedKnob == Knob.Upper {
      upperKnobLayer.highlighted = true
      previouslySelectedKnob = Knob.Upper
      animateKnob(knob: upperKnobLayer, selected: true)
      return true
    }
    
    if lowerKnobLayer.frame.contains(previousLocation) {
      lowerKnobLayer.highlighted = true
      previouslySelectedKnob = Knob.Lower
      animateKnob(knob: lowerKnobLayer, selected: true)
      return true
    }
    
    if upperKnobLayer.frame.contains(previousLocation) {
      upperKnobLayer.highlighted = true
      previouslySelectedKnob = Knob.Upper
      animateKnob(knob: upperKnobLayer, selected: true)
      return true
    }
    
    if (dragTrack) {
      upperKnobLayer.highlighted = true
      lowerKnobLayer.highlighted = true
      animateKnob(knob: lowerKnobLayer, selected: true)
      animateKnob(knob: upperKnobLayer, selected: true)
      return true
    }
    
    return false
  }
  
  /**
   Triggers on a continued touch of the `RangeSlider` and updates the value corresponding with the new button location.
   
   - returns: A bool indicating success.
   */
  
  override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)
    
    let deltaLocation = Double(location.x - previousLocation.x)
    var deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - KnobSize)
    
    if abs(deltaValue) < stepValue {
      return true
    }
    
    if stepValue != 0 {
      deltaValue = deltaValue < 0 ? -stepValue : stepValue
    }
    
    previousLocation = location
    
    if lowerKnobLayer.highlighted && upperKnobLayer.highlighted {
      let gap = upperValue - lowerValue
      if (deltaValue > 0) {
        let newUpperValue = upperValue + deltaValue
        upperValue = boundValue(newUpperValue, toLowerValue: (lowerValue + max(minimumDistance, gap)), upperValue: maximumValue)
        let newLowerValue = lowerValue + deltaValue
        lowerValue = boundValue(newLowerValue, toLowerValue: minimumValue, upperValue: (upperValue - max(minimumDistance, gap)))
      } else {
        let newLowerValue = lowerValue + deltaValue
        lowerValue = boundValue(newLowerValue, toLowerValue: minimumValue, upperValue: (upperValue - max(minimumDistance, gap)))
        let newUpperValue = upperValue + deltaValue
        upperValue = boundValue(newUpperValue, toLowerValue: (lowerValue + max(minimumDistance, gap)), upperValue: maximumValue)
      }
    }
    else if lowerKnobLayer.highlighted {
      let newLowerValue = lowerValue + deltaValue
      lowerValue = boundValue(newLowerValue, toLowerValue: minimumValue, upperValue: (upperValue - minimumDistance))
    } else if upperKnobLayer.highlighted {
      let newUpperValue = upperValue + deltaValue
      upperValue = boundValue(newUpperValue, toLowerValue: (lowerValue + minimumDistance), upperValue: maximumValue)
    }
    
    sendActions(for: .valueChanged)
        
    return true
  }
  
  /**
   Triggers on the end of touch of the `RangeSlider` and sets the button layers `highlighted` property to `false`.
   */
  override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    if lowerKnobLayer.highlighted {
      lowerKnobLayer.highlighted = false
      animateKnob(knob: lowerKnobLayer, selected: false)
    }
    
    if upperKnobLayer.highlighted {
      upperKnobLayer.highlighted = false
      animateKnob(knob: upperKnobLayer, selected: false)
    }
  }
  
  func animateKnob(knob: RangeSliderKnobLayer, selected:Bool) {
    if selected {
      CATransaction.begin()
      CATransaction.setAnimationDuration(0.3)
      CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
      knob.transform = CATransform3DMakeScale(selectedKnobDiameterMultiplier, selectedKnobDiameterMultiplier, 1)
      CATransaction.setCompletionBlock({
      })
      CATransaction.commit()
    } else {
      CATransaction.begin()
      CATransaction.setAnimationDuration(0.3)
      CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
      knob.transform = CATransform3DIdentity
      CATransaction.setCompletionBlock({
      })
      CATransaction.commit()
    }
  }
}

































