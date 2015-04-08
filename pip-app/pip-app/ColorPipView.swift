//
//  ColorPipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

// Plan: Create a subview which is the 'eyedropper view'. 
// It takes a sample of the pixel color at its center and passes
// that value back up to the ColorPipView

class ColorPipView: BasePipView{
	
	var colorPickerView: ColorPickerView!
	
	
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGPoint -> ?
	// I/O: takes a CGPoint, point, which is passed, along with the Pip's image
	//		up to super.init. Initializes colorPickerView.
	
	init(point: CGPoint){
		super.init(point: point, image: UIImage(named: "colorPip-image")!)
		
		colorPickerView = ColorPickerView(point: CGPoint(x: 0, y: 0), parentView: self)
		self.addSubview(colorPickerView)
	}
	
	
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		let newColor: UIColor = getPixelColor(colorPickerView.center)
		colorPickerView.backgroundColor = newColor
		println("!")
	}
	
	
	// getPixelColor: nil -> nil
	// I/O: called when the view is moved
	//		gets the color of the pixel under the center of the view
	//		makes this color the new background color
	
	func getPixelColor(point: CGPoint) -> UIColor{
		
		let pixelData: CFDataRef = CGDataProviderCopyData(CGImageGetDataProvider(self.image?.CGImage))
		let data = CFDataGetBytePtr(pixelData)
		
		var pixelInfo: Int = ((Int(pipImage.size.width) * Int(self.center.x)) + Int(self.center.y)) * 4
		
		var r = CGFloat(data[pixelInfo])
		var g = CGFloat(data[pixelInfo+1])
		var b = CGFloat(data[pixelInfo+2])
		var a = CGFloat(data[pixelInfo+3])
		
		return UIColor(red: r, green: g, blue: b, alpha: a)
	}

}

// ---------------------
// ColorPickerView
// ---------------------

class ColorPickerView: UIImageView{
	
	//Constants
	let centerLocation: CGPoint = CGPoint(x: 0, y: 0)
	let maxDistFromCenter: Float = 50.0
	
	//Used to create new location on detectPan
	var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
	
	var parentView: UIImageView!
	
	
	// init: CGPoint -> ?
	// I/O: Takes in a CGPoint, point, which represents the center of the view
	//		Sets the view image, backgroundColor, and panRecognizer
	
	init(point: CGPoint, parentView: UIImageView){
		super.init(frame: CGRectMake(point.x, point.y, 93/2, 93/2))
		self.image = UIImage(named: "colorPip-picker")
		self.backgroundColor = UIColor.greenColor()
		
		self.parentView = parentView
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		addGestureRecognizer(panRecognizer)
		
		self.userInteractionEnabled = true
	}

	//Required
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	// detectPan: UIPanGestureRecognizer -> nil
	// I/O: moves the view when recognizer detects a pan gesture
	
	func detectPan(recognizer: UIPanGestureRecognizer!){
		var translation = recognizer.translationInView(self.superview!)
		self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
	}
	
	
	// touchesBegan: NSSet, UIEvent -> nil
	// I/O: resets lastLocation to self.center
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		self.superview?.bringSubviewToFront(self)
		lastLocation = self.center
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		println("2")
		self.superview?.touchesEnded(touches, withEvent: event)
	}
}