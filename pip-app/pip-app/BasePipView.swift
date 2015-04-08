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
	
	//Reference to ViewController
	var viewController: ViewController!
	
	
	var pipImage: UIImage!
	
	var pipInputView: UIView!
	var pipOutputView: UIView!
	
	//Used for dragging
	var lastLocation: CGPoint = CGPointMake(0, 0)
	
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGRect -> ? (it technically doesn't return a BasePipView
	// I/O: takes in a CGRect, frame, which represents the bounds and position of the view
	
	init(frame: CGRect, vC: ViewController) {
		super.init(frame: frame)
		
		viewController = vC
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		addGestureRecognizer(panRecognizer)
		
		pipImage = UIImage(named: "pip-logo")
		self.image = pipImage
		
		self.userInteractionEnabled = true;
		
		pipInputView = UIView(frame: CGRectMake(pipImage.size.width - 20, 0, 20, pipImage.size.height))
		pipOutputView = UIView(frame: CGRectMake(0, 0, 20, pipImage.size.height))
		
		pipInputView.backgroundColor = UIColor.blackColor()
		pipOutputView.backgroundColor = UIColor.blackColor()
		
		addSubview(pipOutputView)
		addSubview(pipInputView)
	}
	
	// init: CGPoint, UIImage -> ?
	// I/O: takes in a CGPoint, point, and an UIImage, image, which are used to define
	//		the bounds of the view
	
	init(point: CGPoint, image: UIImage, vC: ViewController) {
		super.init(frame: CGRectMake(point.x, point.y, image.size.width, image.size.height))
		
		viewController = vC
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		addGestureRecognizer(panRecognizer)
		
		pipImage = image
		self.image = pipImage
		
		self.userInteractionEnabled = true;
		
		
		pipInputView = UIView(frame: CGRectMake(pipImage.size.width - 20, 0, 20, pipImage.size.height))
		pipOutputView = UIView(frame: CGRectMake(0, 0, 20, pipImage.size.height))
		
		pipInputView.backgroundColor = UIColor.blackColor()
		pipOutputView.backgroundColor = UIColor.blackColor()
		
		pipInputView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "inputViewTapped:"))
		pipOutputView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "outputViewTapped:"))
		pipInputView.userInteractionEnabled = true;
		pipOutputView.userInteractionEnabled = true;
		
		addSubview(pipInputView)
		addSubview(pipOutputView)
		
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
	
	
	// inputViewTapped: UITapGestureRecognizer -> nil
	// I/O: called by pipInputView's gesture recognizer,
	//		takes in recognizer and calls setActiveInputPip in viewController
	
	func inputViewTapped(recognizer: UITapGestureRecognizer!){
		viewController.setActiveInputPip(self)
	}
	
	
	// outputViewTapped: UITapGestureRecognizer -> nil
	// I/O: called by pipOutputView's gesture recognizer,
	//		takes in recognizer and calls setActiveOutputPip in viewController
	
	func outputViewTapped(recongizer: UITapGestureRecognizer!){
		viewController.setActiveOutputPip(self)
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