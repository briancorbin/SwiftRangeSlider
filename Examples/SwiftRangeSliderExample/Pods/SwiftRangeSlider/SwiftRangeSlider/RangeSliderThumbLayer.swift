//
//  RangeSliderThumbLayer.swift
//  SwiftRangeSlider
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderThumbLayer: CALayer {
  var highlighted: Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }
  weak var rangeSlider: RangeSlider?
  
  override func draw(in ctx: CGContext) {
    if let slider = rangeSlider {
      let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
      let cornerRadius = thumbFrame.height * slider.curvaceousness / 2
      let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
      
      let shadowColor = UIColor.gray
      if (rangeSlider!.thumbHasShadow){
        ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 1.0, color: shadowColor.cgColor)
      }
      ctx.setFillColor(slider.thumbTintColor.cgColor)
      ctx.addPath(thumbPath.cgPath)
      ctx.fillPath()
      
      ctx.setStrokeColor(shadowColor.cgColor)
      ctx.setLineWidth((rangeSlider?.thumbBorderThickness)!)
      ctx.addPath(thumbPath.cgPath)
      ctx.strokePath()
      
      if highlighted {
        ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
      }
    }
  }
}
