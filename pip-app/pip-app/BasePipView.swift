//
//  BasePipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class BasePipView: UIImageView {
	
	var pipImage: UIImage!
	
	//Used for dragging
	var lastLocation: CGPoint = CGPointMake(0, 0)
	
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGRect -> ? (it technically doesn't return a BasePipView
	// I/O: takes in a CGRect, frame, which represents the bounds and position of the view
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		addGestureRecognizer(panRecognizer)
		
		pipImage = UIImage(named: "pip-logo")
		self.image = pipImage
		
		self.userInteractionEnabled = true;
	}
	
	// init: CGPoint, UIImage -> ?
	// I/O: takes in a CGPoint, point, and an UIImage, image, which are used to define
	//		the bounds of the view
	
	init(point: CGPoint, image: UIImage) {
		super.init(frame: CGRectMake(point.x, point.y, image.size.width, image.size.height))
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		addGestureRecognizer(panRecognizer)
		
		pipImage = image
		self.image = pipImage
		
		self.userInteractionEnabled = true;
	}
	
	// setPipViewImage: UIImage -> nil
	// I/O: takes an UIImage, image, and sets pipImage to this value
	
	func setPipViewImage(image: UIImage){
		pipImage = image
		self.image = pipImage
	}
	
	
	// detectPan: UIPanGestureRecognizer -> nil
	// I/O: takes in recognizer and computes the distance the user has panned
	//		finally applying this vector to the uiview's center, effectively
	//		moving the view.
	
	func detectPan(recognizer: UIPanGestureRecognizer!){
		var translation = recognizer.translationInView(self.superview!)
		self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
	}
	
	// touchesBegan: NSSet, UIEvent -> nil
	// I/O: called when the user presses the UIView. This implementation
	//		tells the superview to bring this view to the front, and update
	//		lastLocation's value
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		self.superview?.bringSubviewToFront(self)
		lastLocation = self.center
	}
	
	
	
}