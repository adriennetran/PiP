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
	class func makePipMenu(_ pos: CGPoint) -> CanvasMenuView{
		var menu = CanvasMenuView(offsetLocation: CGPoint(x: -UIScreen.main.bounds.width, y: 0),
			frame: CGRect(x: pos.x, y: pos.y, width: UIScreen.main.bounds.width, height: 500))
		
		menu.backgroundColor = UIColor.white
		menu.contentSize = CGSize(width: menu.frame.width, height: menu.frame.height)
		menu.isUserInteractionEnabled = true
		menu.layer.shadowColor = UIColor.black.cgColor
		menu.layer.shadowOffset = CGSize(width: 0, height: 5)
		menu.layer.shadowRadius = 5
		menu.layer.shadowOpacity = 0.70
		
		menu.layer.masksToBounds = false
		
		// Add Buttons here
		var typeInt: Int = 0
		
		var lastPipRightPos: Float = 0
		
		// HARDCODING MENU BUTTONS
		let imgScale: CGFloat = 0.7

		let switchImg = _mainPipDirectory.getImageForPipType(.Switch)
		let textImg = _mainPipDirectory.getImageForPipType(.Text)
		let colorImg = _mainPipDirectory.getImageForPipType(.Color)
		let accelImg = _mainPipDirectory.getImageForPipType(.Accel)
		let imageImg = _mainPipDirectory.getImageForPipType(.Image)
		let audioImg = _mainPipDirectory.getImageForPipType(.Audio)
		let mathImg = _mainPipDirectory.getImageForPipType(.Math)

		
		let switchFrame = CGRect(x: 45, y: 60, width: switchImg.size.width * imgScale, height: switchImg.size.height * imgScale)
		let textFrame = CGRect(x: 130, y: 80, width: textImg.size.width * imgScale, height: textImg.size.height * imgScale)
		let colorFrame = CGRect(x: 275, y: 60, width: colorImg.size.width * imgScale, height: colorImg.size.height * imgScale)
		let accelFrame = CGRect(x: 35, y: 170, width: accelImg.size.width * imgScale, height: accelImg.size.height * imgScale)
		let imageFrame = CGRect(x: 155, y: 170, width: imageImg.size.width * imgScale, height: imageImg.size.height * imgScale)
		let audioFrame = CGRect(x: 275, y: 173, width: audioImg.size.width * imgScale, height: audioImg.size.height * imgScale)
		let mathFrame = CGRect(x: 20, y: 285, width: mathImg.size.width * imgScale, height: mathImg.size.height * imgScale)
		
		let switchBtn = UIButton(frame: switchFrame)
		switchBtn.setImage(switchImg, for: UIControlState())
		switchBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		switchBtn.tag = PipType.Switch.rawValue
		
		let textBtn = UIButton(frame: textFrame)
		textBtn.setImage(textImg, for: UIControlState())
		textBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		textBtn.tag = PipType.Text.rawValue
		
		let colorBtn = UIButton(frame: colorFrame)
		colorBtn.setImage(colorImg, for: UIControlState())
		colorBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		colorBtn.tag = PipType.Color.rawValue
		
		let accelBtn = UIButton(frame: accelFrame)
		accelBtn.setImage(accelImg, for: UIControlState())
		accelBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		accelBtn.tag = PipType.Accel.rawValue
		
		let imageBtn = UIButton(frame: imageFrame)
		imageBtn.setImage(imageImg, for: UIControlState())
		imageBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		imageBtn.tag = PipType.Image.rawValue

		let audioBtn = UIButton(frame: audioFrame)
		audioBtn.setImage(audioImg, for: UIControlState())
		audioBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		audioBtn.tag = PipType.Audio.rawValue
		
		let mathBtn = UIButton(frame: mathFrame)
		mathBtn.setImage(mathImg, for: UIControlState())
		mathBtn.addTarget(menu, action: "buttonDelegateMethod:", for: .touchUpInside)
		mathBtn.tag = PipType.Math.rawValue
		

		menu.addSubview(switchBtn)
		menu.addSubview(textBtn)
		menu.addSubview(colorBtn)
		menu.addSubview(accelBtn)
		menu.addSubview(imageBtn)
		menu.addSubview(audioBtn)
		menu.addSubview(mathBtn)
		
		
		menu.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(300));

		menu.isHidden = true
		
		return menu
	}
	
	class func makeDataMenu(_ pos: CGPoint) -> CanvasMenuView{
		let menu = CanvasMenuView(offsetLocation: CGPoint(x: UIScreen.main.bounds.width, y: 0),
			frame: CGRect(x: pos.x, y: pos.y, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 0.8)))
		
		menu.backgroundColor = UIColor.white
		menu.contentSize = CGSize(width: menu.frame.width, height: menu.frame.height)
		menu.isUserInteractionEnabled = true
		menu.layer.shadowColor = UIColor.black.cgColor
		menu.layer.shadowOffset = CGSize(width: 0, height: 5)
		menu.layer.shadowRadius = 5
		menu.layer.shadowOpacity = 0.70
		
		menu.layer.masksToBounds = false
		
		menu.isHidden = true
		
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
	
	class func createButtonFromImage(_ img : UIImage, scale: Float) -> UIButton {
		let width = img.size.width * CGFloat(scale)
		let height = img.size.height * CGFloat(scale)
		let btn = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
		btn.setImage(img, for: UIControlState())
		return btn
	}
	
	// buttonDelegateMethod: nil -> nil
	// I/O: tells _mainPipDirectory to create appropriate Pip and closes the menu
	
	func buttonDelegateMethod(_ sender: UIButton) {
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
	
	func toggleActive(_ sender: UIButton) {
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
			offset = CGPoint.zero
		}
		
		frame.origin = CGPoint(x: offset.x + baseLocation.x, y: offset.y + baseLocation.y)
		self.isHidden = false
	}
	
	// slideOut: nil -> nil
	// I/O:  moves the veiw to offsetLocation with compensation for the view's
	//		 superview.offset
	
	func slideOut() {
		var offset: CGPoint!
		
		if var sView = (superview as? UIScrollView) {
			offset = sView.contentOffset
		} else {
			offset = CGPoint.zero
		}
		
		frame.origin = CGPoint(x: offset.x + offsetLocation.x, y: offset.y + offsetLocation.y)
		self.isHidden = true
	}
	
	// Input Functions
	// all are implemented to prevent the view from passing touches to the scroll view
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
}
