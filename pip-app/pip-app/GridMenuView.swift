//
//  GridMenuView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/13/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

// Protocol which requires a view be able to slide on and off screen.
// Used in conjunction with GridMenuView for the Workspace Menu's
protocol SlideInView {
	var offsetLocation: CGPoint! { get }
	
	var viewIsActive: Bool { get set }
	
	func toggleActive()
	func slideIn()
	func slideOut()
}

class CanvasMenuView: UIScrollView, SlideInView {
	
	/* ------------------
	*	Static Functions
	   ------------------ */
	class func makePipMenu(pos: CGPoint) -> CanvasMenuView{
		var menu = CanvasMenuView(offsetLocation: CGPoint(x: -UIScreen.mainScreen().bounds.width, y: 0),
			frame: CGRectMake(pos.x, pos.y, UIScreen.mainScreen().bounds.width, 500))
		
		menu.backgroundColor = UIColor.whiteColor()
		
		// Add Buttons here
		var typeInt: Int = 0
		while let type = PipType(rawValue: typeInt) {
			let img = _mainPipDirectory.getImageForPipType(type)
			
			let col = typeInt % 2
			let row = typeInt / 2
			
			let posX: Int = 20 + (200 * col)
			let posY: Int = 50 + (170 * row)
			let sizeX = img.size.width * 0.5
			let sizeY = img.size.height * 0.5
			
			let bFrame = CGRectMake(CGFloat(posX), CGFloat(posY), sizeX, sizeY)
			
			var btn = UIButton(frame: bFrame)
			btn.setImage(img, forState: .Normal)
			btn.addTarget(_mainPipDirectory, action: "createPipFromButtonTag:", forControlEvents: .TouchUpInside)
			btn.tag = typeInt
			
			menu.addSubview(btn)
			++typeInt
		}
		
		return menu
	}
	
	
	/* ------------------
	*	Start Class Def
	   ------------------ */
	
	var baseLocation: CGPoint!
	var offsetLocation: CGPoint!
	
	var viewIsActive: Bool = false
	
	init(offsetLocation: CGPoint, frame: CGRect) {
		super.init(frame: frame)
		
		self.baseLocation = frame.origin
		self.offsetLocation = offsetLocation
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	class func createButtonFromImage(img : UIImage, scale: Float) -> UIButton {
		let width = img.size.width * CGFloat(scale)
		let height = img.size.height * CGFloat(scale)
		var btn = UIButton(frame: CGRectMake(0, 0, width, height))
		btn.setImage(img, forState: UIControlState.Normal)
		return btn
	}
	
	func toggleActive() {
		
	}
	
	func toggleActive(sender: UIButton) {
		viewIsActive = !viewIsActive
		
		if viewIsActive {
			slideIn()
		}else{
			slideOut()
		}
	}
	
	func slideIn() {
		var offset: CGPoint!
		
		if var sView = (superview as? UIScrollView) {
			offset = sView.contentOffset
		} else {
			offset = CGPoint.zeroPoint
		}
		
		frame.origin = CGPoint(x: offset.x + baseLocation.x, y: offset.y + baseLocation.y)
	}
	
	func slideOut() {
		var offset: CGPoint!
		
		if var sView = (superview as? UIScrollView) {
			offset = sView.contentOffset
		} else {
			offset = CGPoint.zeroPoint
		}
		
		frame.origin = offsetLocation
	}
	
}