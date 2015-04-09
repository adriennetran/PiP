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
	
	var colorModel: ColorPip!
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGPoint -> ?
	// I/O: takes a CGPoint, point, which is passed, along with the Pip's image
	//		up to super.init. Initializes colorPickerView.
	
	init(point: CGPoint, vC: ViewController){
		super.init(point: point, image: UIImage(named: "colorPip-image")!, vC: vC)
	}
	
	
	// setTextModel: TextPip -> nil
	// I/O: creates connection between the model and view
	
	func setColorModel(basePip: ColorPip) {
		self.colorModel = basePip
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return colorModel
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