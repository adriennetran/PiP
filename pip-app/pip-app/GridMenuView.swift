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

// Custom UIScrollView
// Used to tell PipDirectory to create pips

class CanvasMenuView: UIScrollView, SlideInView {
	
	/* ------------------
	*	Static Functions
	   ------------------ */
	
	// Does all the initialization for PipMenu
	class func makePipMenu(pos: CGPoint) -> CanvasMenuView{
		var menu = CanvasMenuView(offsetLocation: CGPoint(x: -UIScreen.mainScreen().bounds.width, y: 0),
			frame: CGRectMake(pos.x, pos.y, UIScreen.mainScreen().bounds.width, 200))
		
		menu.backgroundColor = UIColor.grayColor()
		menu.contentSize = CGSize(width: 700, height: 200)
		menu.userInteractionEnabled = true
		menu.layer.shadowColor = UIColor.blackColor().CGColor
		menu.layer.shadowOffset = CGSizeMake(5, 5)
		menu.layer.shadowRadius = 5
		menu.layer.shadowOpacity = 1.0
		
		menu.layer.masksToBounds = false
		
		// Add Buttons here
		var typeInt: Int = 0
		
		var lastPipRightPos: Float = 0
		
		while let type = PipType(rawValue: typeInt) {
			let img = _mainPipDirectory.getImageForPipType(type)
			
			let sizeX = img.size.width * 0.5
			let sizeY = img.size.height * 0.5
			
			let posX: Float = 50 + lastPipRightPos
			let posY: Float = Float(menu.frame.height) - Float(sizeY) - 30
			
			
			lastPipRightPos = posX + Float(sizeX)
			
			let bFrame = CGRectMake(CGFloat(posX), CGFloat(posY), sizeX, sizeY)
			
			var btn = UIButton(frame: bFrame)
			btn.setImage(img, forState: .Normal)
			btn.addTarget(_mainPipDirectory, action: "createPipFromButtonTag:", forControlEvents: .TouchUpInside)
			btn.tag = typeInt
			
			menu.addSubview(btn)
			++typeInt
		}
		
		menu.hidden = true
		
		return menu
	}
	
	
	/* ------------------
	*	Start Class Def
	   ------------------ */
	
	// These two points allow the view to slide in and out
	var baseLocation: CGPoint!
	var offsetLocation: CGPoint!
	
	var viewIsActive: Bool = false
	
	// init: CGPoint, CGRect -> GridMenuView
	// I/O: creates a GridMenuView at frame, and sets base and offsetLocations
	//		based on the information given.
	
	init(offsetLocation: CGPoint, frame: CGRect) {
		super.init(frame: frame)
		
		self.baseLocation = frame.origin
		self.offsetLocation = offsetLocation
	}

	// REQUIRED - dont use
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// createButtonFromImage: UIImage, Float -> UIButton
	// I/O: creates a UIButton at (0,0) with an aspect ratio to fit img at the images size
	//		times scale, and returns this button
	
	class func createButtonFromImage(img : UIImage, scale: Float) -> UIButton {
		let width = img.size.width * CGFloat(scale)
		let height = img.size.height * CGFloat(scale)
		var btn = UIButton(frame: CGRectMake(0, 0, width, height))
		btn.setImage(img, forState: UIControlState.Normal)
		return btn
	}
	
	// toggleActive: nil -> nil
	// I/O: toggles the value of viewIsActive, and slides the view In/Out as appropriate
	
	func toggleActive() {
		viewIsActive = !viewIsActive
		
		if viewIsActive {
			slideIn()
		}else{
			slideOut()
		}
	}
	
	// toggleActive: UIButton -> nil
	// I/O: toggles the value of viewIsActive, and slides the view In/Out as appropriate
	
	func toggleActive(sender: UIButton) {
		viewIsActive = !viewIsActive
		
		if viewIsActive {
			slideIn()
		}else{
			slideOut()
		}
	}
	
	// slideIn: nil -> nil
	// I/O: moves the view to baseLocation with compensation for the view's superview.offset
	
	func slideIn() {
		var offset: CGPoint!
		
		if var sView = (superview as? UIScrollView) {
			offset = sView.contentOffset
		} else {
			offset = CGPoint.zeroPoint
		}
		
		frame.origin = CGPoint(x: offset.x + baseLocation.x, y: offset.y + baseLocation.y)
		self.hidden = false
	}
	
	// slideOut: nil -> nil
	// I/O:  moves the veiw to offsetLocation with compensation for the view's
	//		 superview.offset
	
	func slideOut() {
		var offset: CGPoint!
		
		if var sView = (superview as? UIScrollView) {
			offset = sView.contentOffset
		} else {
			offset = CGPoint.zeroPoint
		}
		
		frame.origin = CGPoint(x: offset.x + offsetLocation.x, y: offset.y + offsetLocation.y)
		self.hidden = true
	}
	
}