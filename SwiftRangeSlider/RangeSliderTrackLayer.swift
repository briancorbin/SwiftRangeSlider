//
//  RangeSliderTrackLayer.swift
//  SwiftRangeSlider
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
  weak var rangeSlider: RangeSlider?
  
  override func draw(in ctx: CGContext) {
    if let slider = rangeSlider {
      // Clip
      let cornerRadius = bounds.height * slider.curvaceousness / 2.0
      let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
      ctx.addPath(path.cgPath)
      
      // Fill the track
      ctx.setFillColor(slider.trackTintColor.cgColor)
      ctx.addPath(path.cgPath)
      ctx.fillPath()
      
      // Fill the highlighted range
      ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
      let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
      let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
      let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
      ctx.fill(rect)
    }
  }
}
