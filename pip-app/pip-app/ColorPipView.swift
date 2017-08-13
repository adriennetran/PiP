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
		super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Color), id: id)
		
		colorPickerView = ColorPickerView(pos: centerOfColorWheel)
		self.addSubview(colorPickerView)
		colorPickerView.backgroundColor = UIColor.white
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}
	
	
	func getColourFromPoint(_ point:CGPoint) -> UIColor {
		let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		
		var pixelData:[UInt8] = [0, 0, 0, 0]
		
		let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
		context?.translateBy(x: -point.x, y: -point.y);
		
		colorPickerView.isHidden = true
		
		self.layer.render(in: context!)
		
		colorPickerView.isHidden = false
		
		let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
		let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
		let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
		let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
		
		let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
		return color
	}
	
	// updateView: nil -> nil
	// I/O: updates the model and forces the view to reflect it
	
	override func updateView() {
		(getModel() as? ColorPip)?.updateReliantPips()
        
        let output = (getModel() as? ColorPip)?.getOutput()
        
        colorPickerView.backgroundColor = output?.color
        // color- if present
        if (output?.getAccel() != nil){
            print("accel > color")
            //            self.addSubview(self.colorBlock)
        }
	}
	
	func getColorFromPicker(_ point: CGPoint) -> UIColor{
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
		
		self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ColorPickerView.viewBeingPanned(_:))))
		
		self.isUserInteractionEnabled = true
		
		self.layer.cornerRadius = self.frame.width / 2
		
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let sup = (superview as? BasePipView) {
			sup.panOverridden = true
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let sup = (superview as? BasePipView) {
			sup.panOverridden = false
		}
	}
	
	func viewBeingPanned(_ sender: UIPanGestureRecognizer) {
		if sender.state == .began {
			lastLocation = frame.origin
			if var sup = (superview as? BasePipView) {
				sup.panOverridden = true
			}
		}else if sender.state == .ended {
			superview!.isUserInteractionEnabled = true
			if var sup = (superview as? BasePipView) {
				sup.panOverridden = false
			}
		}
		
		var newOrigin = CGPoint(x: lastLocation.x + sender.translation(in: superview!).x, y: lastLocation.y + sender.translation(in: superview!).y)
		
		if var sup = (superview as? ColorPipView) {
			if CGFloat(distance(newOrigin, b: sup.centerOfColorWheel)) >= sup.cPickerMaxDelta{
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
