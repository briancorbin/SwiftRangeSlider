//
//  ViewController.swift
//  testingPod
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import RappleColorPicker

class ViewController: UIViewController, RappleColorPickerDelegate {
  
  @IBOutlet weak var rangeSlider: RangeSlider!
  @IBOutlet weak var curvaceousnessSlider: UISlider!
  @IBOutlet weak var curvaceousnessLabel: UILabel!
  @IBOutlet weak var trackBarThicknessLabel: UILabel!
  @IBOutlet weak var trackBarThicknessSlider: UISlider!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    curvaceousnessSlider.value = Float(rangeSlider.curvaceousness)
    curvaceousnessLabel.text = "Curvaceousness: \(rangeSlider.curvaceousness)"
    trackBarThicknessSlider.value = Float(rangeSlider.trackThickness)
    trackBarThicknessLabel.text = "Track Bar Thickness: \(rangeSlider.trackThickness)"
  }
  
  override func viewDidLayoutSubviews() {
    rangeSlider.updateLayerFrames()
  }
  
  @IBAction func rangeSliderValuesChanged(rangeSlider: RangeSlider) {
    print("\(rangeSlider.lowerValue), \(rangeSlider.upperValue)")
  }

  @IBAction func curvaceousnessValueChanged(slider: UISlider) {
    curvaceousnessLabel.text = "Curvaceousness: \(slider.value)"
    rangeSlider.curvaceousness = CGFloat(slider.value)
  }
  @IBAction func trackBarThicknessValueChanged(slider: UISlider) {
    trackBarThicknessLabel.text = "Track Bar Thickness: \(slider.value)"
    rangeSlider.trackThickness = CGFloat(slider.value)
  }
  
  @IBAction func trackTintColorButtonPressed(sender: AnyObject) {
    RappleColorPicker.openColorPallet(onViewController: self, origin: CGPointMake(50, 100), delegate: self, title: "Color", tag: 0)
  }
  
  @IBAction func trackHighlightTintColorButtonPressed(sender: AnyObject) {
    RappleColorPicker.openColorPallet(onViewController: self, origin: CGPointMake(50, 100), delegate: self, title: "Color", tag: 1)
  }
  
  @IBAction func thumbTintColorButtonPressed(sender: AnyObject) {
    RappleColorPicker.openColorPallet(onViewController: self, origin: CGPointMake(50, 100), delegate: self, title: "Color", tag: 2)
  }
  
  func colorSelected(color: UIColor, tag: Int) {
    switch tag {
    case 0:
      rangeSlider.trackTintColor = color
    case 1:
      rangeSlider.trackHighlightTintColor = color
    case 2:
      rangeSlider.thumbTintColor = color
    default:
      break
    }
  }
}

