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
			frame: CGRectMake(pos.x, pos.y, UIScreen.mainScreen().bounds.width, 500))
		
		menu.backgroundColor = UIColor.whiteColor()
		menu.contentSize = CGSize(width: 700, height: 200)
		menu.userInteractionEnabled = true
		menu.layer.shadowColor = UIColor.blackColor().CGColor
		menu.layer.shadowOffset = CGSizeMake(0, 5)
		menu.layer.shadowRadius = 5
		menu.layer.shadowOpacity = 0.70
		
		menu.layer.masksToBounds = false
		
		// Add Buttons here
		var typeInt: Int = 0
		
		var lastPipRightPos: Float = 0
		
		// HARDCODING MENU BUTTONS
		let imgScale: CGFloat = 0.7
//		
//		let switchImg = _mainPipDirectory.getImageForPipType(.Switch);
//		let textImg = _mainPipDirectory.getImageForPipType(.Text);
//		let colorImg = _mainPipDirectory.getImageForPipType(.Color);
//		let accelImg = _mainPipDirectory.getImageForPipType(.Accel);
//		let imageImg = _mainPipDirectory.getImageForPipType(.Image);
//        let soundImg = _mainPipDirectory.getImageForPipType(.Audio);
//=======
		let switchImg = _mainPipDirectory.getImageForPipType(.Switch)
		let textImg = _mainPipDirectory.getImageForPipType(.Text)
		let colorImg = _mainPipDirectory.getImageForPipType(.Color)
		let accelImg = _mainPipDirectory.getImageForPipType(.Accel)
		let imageImg = _mainPipDirectory.getImageForPipType(.Image)
		let audioImg = _mainPipDirectory.getImageForPipType(.Audio)
		let mathImg = _mainPipDirectory.getImageForPipType(.Math)
//>>>>>>> ba85a77f856e88a22a20757346d7a620a0670493
		
		let switchFrame = CGRectMake(45, 60, switchImg.size.width * imgScale, switchImg.size.height * imgScale)
		let textFrame = CGRectMake(130, 80, textImg.size.width * imgScale, textImg.size.height * imgScale)
		let colorFrame = CGRectMake(275, 60, colorImg.size.width * imgScale, colorImg.size.height * imgScale)
		let accelFrame = CGRectMake(35, 170, accelImg.size.width * imgScale, accelImg.size.height * imgScale)
		let imageFrame = CGRectMake(155, 170, imageImg.size.width * imgScale, imageImg.size.height * imgScale)
//<<<<<<< HEAD
//        let soundFrame = CGRectMake(45, 60, soundImg.size.width * imgScale, soundImg.size.height * imgScale)
//=======
		let audioFrame = CGRectMake(275, 173, audioImg.size.width * imgScale, audioImg.size.height * imgScale)
		let mathFrame = CGRectMake(20, 285, mathImg.size.width * imgScale, mathImg.size.height * imgScale)
//>>>>>>> ba85a77f856e88a22a20757346d7a620a0670493
		
		let switchBtn = UIButton(frame: switchFrame)
		switchBtn.setImage(switchImg, forState: .Normal)
		switchBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		switchBtn.tag = PipType.Switch.rawValue
		
		let textBtn = UIButton(frame: textFrame)
		textBtn.setImage(textImg, forState: .Normal)
		textBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		textBtn.tag = PipType.Text.rawValue
		
		let colorBtn = UIButton(frame: colorFrame)
		colorBtn.setImage(colorImg, forState: .Normal)
		colorBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		colorBtn.tag = PipType.Color.rawValue
		
		let accelBtn = UIButton(frame: accelFrame)
		accelBtn.setImage(accelImg, forState: .Normal)
		accelBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		accelBtn.tag = PipType.Accel.rawValue
		
		let imageBtn = UIButton(frame: imageFrame)
		imageBtn.setImage(imageImg, forState: .Normal)
		imageBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		imageBtn.tag = PipType.Image.rawValue
//<<<<<<< HEAD

//        let soundBtn = UIButton(frame: soundFrame)
//        soundBtn.setImage(soundImg, forState: .Normal)
//        soundBtn.addTarget(_mainPipDirectory, action: "createPipFromButtonTag:", forControlEvents: .TouchUpInside)
//        soundBtn.tag = PipType.Audio.rawValue
//
//=======
//		
		let audioBtn = UIButton(frame: audioFrame)
		audioBtn.setImage(audioImg, forState: .Normal)
		audioBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		audioBtn.tag = PipType.Audio.rawValue
		
		let mathBtn = UIButton(frame: mathFrame)
		mathBtn.setImage(mathImg, forState: .Normal)
		mathBtn.addTarget(menu, action: "buttonDelegateMethod:", forControlEvents: .TouchUpInside)
		mathBtn.tag = PipType.Math.rawValue
		
//>>>>>>> ba85a77f856e88a22a20757346d7a620a0670493
		menu.addSubview(switchBtn)
		menu.addSubview(textBtn)
		menu.addSubview(colorBtn)
		menu.addSubview(accelBtn)
		menu.addSubview(imageBtn)
////<<<<<<< HEAD
//        menu.addSubview(soundBtn)
////=======
		menu.addSubview(audioBtn)
		menu.addSubview(mathBtn)
//>>>>>>> ba85a77f856e88a22a20757346d7a620a0670493
		
		
		menu.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat(300));
		/*while let type = PipType(rawValue: typeInt) {
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
		}*/
		
		//menu.contentSize = CGSize(width: CGFloat(lastPipRightPos + 50), height: menu.contentSize.height)
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
	
	// buttonDelegateMethod: nil -> nil
	// I/O: tells _mainPipDirectory to create appropriate Pip and closes the menu
	
	func buttonDelegateMethod(sender: UIButton) {
		_mainPipDirectory.createPipFromButtonTag(sender)
		toggleActive()
	}
	
	// toggleActive: nil -> nil
	// I/O: toggles the value of viewIsActive, and slides the view In/Out as appropriate
	
	func toggleActive() {
		viewIsActive = !viewIsActive
		
		if viewIsActive {
			slideIn()
		}else{
			slideOut()
			_mainPipDirectory.viewController.setMenuButtonsActive()
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
	
	// Input Functions
	// all are implemented to prevent the view from passing touches to the scroll view
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		
	}
	
	override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
		
	}
	
	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		
	}
	
}