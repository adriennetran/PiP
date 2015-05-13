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
    
//    var colorBlock = UIImageView(frame: CGRectMake(10, 220, 100, 100))
	
	let centerOfColorWheel: CGPoint = CGPoint(x: 33, y: 47)
	let cPickerMaxDelta: CGFloat = 30
	
	var colorPickerView: ColorPickerView!
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGPoint -> ?
	// I/O: takes a CGPoint, point, which is passed, along with the Pip's image
	//		up to super.init. Initializes colorPickerView.
	
	init(point: CGPoint, id: Int){
		super.init(point: point, image: UIImage(named: "colorPip-image")!, id: id)
		
		colorPickerView = ColorPickerView(pos: centerOfColorWheel)
		self.addSubview(colorPickerView)
		colorPickerView.backgroundColor = UIColor.whiteColor()
	}
	
	// ---------------
	//  TEMPORARY -- GET RID OF THIS SHIT... FAST!!!
	// ---------------
	
	func blueTouched(recognizer: UITapGestureRecognizer){
		(getModel() as? ColorPip)?.updateColor(UIColor.blueColor())
	}
	
	func greenTouched(recognizer: UITapGestureRecognizer){
		(getModel() as? ColorPip)?.updateColor(UIColor.greenColor())
	}
	
	func redTouched(recognizer: UITapGestureRecognizer){
		(getModel() as? ColorPip)?.updateColor(UIColor.redColor())
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}
	
	
	func getColourFromPoint(point:CGPoint) -> UIColor {
		let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
		
		var pixelData:[UInt8] = [0, 0, 0, 0]
		
		let context = CGBitmapContextCreate(&pixelData, 1, 1, 8, 4, colorSpace, bitmapInfo)
		CGContextTranslateCTM(context, -point.x, -point.y);
		
		colorPickerView.hidden = true
		
		self.layer.renderInContext(context)
		
		colorPickerView.hidden = false
		
		var red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
		var green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
		var blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
		var alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
		
		var color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
		return color
	}
	
	// updateView: nil -> nil
	// I/O: updates the model and forces the view to reflect it
	
	override func updateView() {
		(getModel() as? ColorPip)?.updateReliantPips()
        
        let output = (getModel() as? ColorPip)?.getOutput()
        
        
        // color- if present
        if (output?.getAccel() != nil){
            println("accel > color")
            //            self.addSubview(self.colorBlock)
        }
	}
	
	func getColorFromPicker(point: CGPoint) -> UIColor{
		let color = self.getColourFromPoint(point)
		(getModel() as? ColorPip)?.updateColor(color)
		return color
	}

}

class ColorPickerView: UIImageView {
	
	var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
	
	init(pos: CGPoint) {
		let pickerImage = UIImage(named: "colorPipPicker-image")
		
		super.init(image: pickerImage)
		
		self.frame.origin = pos
		
		self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "viewBeingPanned:"))
		
		self.userInteractionEnabled = true
		
		self.layer.cornerRadius = self.frame.width / 2
		
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		if var sup = (superview as? BasePipView) {
			sup.panOverridden = true
		}
	}
	
	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		if var sup = (superview as? BasePipView) {
			sup.panOverridden = false
		}
	}
	
	func viewBeingPanned(sender: UIPanGestureRecognizer) {
		if sender.state == .Began {
			lastLocation = frame.origin
			if var sup = (superview as? BasePipView) {
				sup.panOverridden = true
			}
		}else if sender.state == .Ended {
			superview!.userInteractionEnabled = true
			if var sup = (superview as? BasePipView) {
				sup.panOverridden = false
			}
		}
		
		var newOrigin = CGPoint(x: lastLocation.x + sender.translationInView(superview!).x, y: lastLocation.y + sender.translationInView(superview!).y)
		
		if var sup = (superview as? ColorPipView) {
			if CGFloat(distance(newOrigin, sup.centerOfColorWheel)) >= sup.cPickerMaxDelta{
				let normalizedDelta = normalize(CGPoint(x: newOrigin.x - sup.centerOfColorWheel.x,
					y: newOrigin.y - sup.centerOfColorWheel.y))
				newOrigin = CGPoint(x: sup.centerOfColorWheel.x + (normalizedDelta.x * sup.cPickerMaxDelta),
					y: sup.centerOfColorWheel.x + (normalizedDelta.y * sup.cPickerMaxDelta))
			}
		}
		
		self.frame.origin = newOrigin
		
		if var sup = (superview as? ColorPipView) {
			self.backgroundColor = sup.getColorFromPicker(self.center)
		}
	}
	
	
}