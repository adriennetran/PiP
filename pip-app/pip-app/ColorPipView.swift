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
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGPoint -> ?
	// I/O: takes a CGPoint, point, which is passed, along with the Pip's image
	//		up to super.init. Initializes colorPickerView.
	
	init(point: CGPoint, id: Int){
		super.init(point: point, image: UIImage(named: "colorPip-image")!, id: id)
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
		
		pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
		pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
		
		var blueFrame = UIView(frame: CGRectMake(frame.width/2 - 30, 60, 60, 60))
		blueFrame.backgroundColor = UIColor.blueColor()
		blueFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "blueTouched:"))
		addSubview(blueFrame)
		
		var greenFrame = UIView(frame: CGRectMake(frame.width/2 + 30, 120, 60, 60))
		greenFrame.backgroundColor = UIColor.greenColor()
		greenFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "greenTouched:"))
		addSubview(greenFrame)
		
		var redFrame = UIView(frame: CGRectMake(frame.width/2 - 90, 120, 60, 60))
		redFrame.backgroundColor = UIColor.redColor()
		redFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "redTouched:"))
		addSubview(redFrame)
	}
	
//	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//		
//	}
	
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
	
	// updateView: nil -> nil
	// I/O: updates the model and forces the view to reflect it
	
	override func updateView() {
		(getModel() as? ColorPip)?.updateReliantPips()
	}

}