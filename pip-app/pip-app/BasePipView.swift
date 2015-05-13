//
//  BasePipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class BasePipView: UIImageView, UIGestureRecognizerDelegate {
	
	var pipId: Int!
	
	var pipImage: UIImage!
	
	var longTouchdetected = false
	
	// Dictionaries to hold references to arm views
	// Arm views are subviews of the containerView
	// Dictionary is of form: toPipID : ArmView
	var inArms: [Int : ArmView] = [:]
	var outArms: [Int : ArmView] = [:]
	
	//Used for dragging
	var lastLocation: CGPoint = CGPointMake(0, 0)
	var panOverridden: Bool = false
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	// init: CGRect -> ? (it technically doesn't return a BasePipView
	// I/O: takes in a CGRect, frame, which represents the bounds and position of the view
	
	init(frame: CGRect, id: Int) {
		super.init(frame: frame)
		
		pipId = id
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		var longTouchRecognizer = UILongPressGestureRecognizer(target: self, action: "prepPan:")
		
		
		addGestureRecognizer(panRecognizer)
		addGestureRecognizer(longTouchRecognizer)
		
		pipImage = UIImage(named: "pip-logo")
		self.image = pipImage
		
		self.userInteractionEnabled = true;
	}
	
	// init: CGPoint, UIImage -> ?
	// I/O: takes in a CGPoint, point, and an UIImage, image, which are used to define
	//		the bounds of the view
	
	init(point: CGPoint, image: UIImage, id: Int) {
		super.init(frame: CGRectMake(point.x, point.y, image.size.width, image.size.height))
		
		pipId = id
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		var longTouchRecognizer = UILongPressGestureRecognizer(target: self, action: "prepPan:")
		longTouchRecognizer.minimumPressDuration = 0.35
		
		panRecognizer.delegate = self
		longTouchRecognizer.delegate = self
		
		addGestureRecognizer(panRecognizer)
		addGestureRecognizer(longTouchRecognizer)
		
		pipImage = image
		self.contentMode = UIViewContentMode.ScaleAspectFit
		self.image = pipImage
		
		self.userInteractionEnabled = true;
		
	}
	
	
    func changeInputViewColorOrange(){
		// self.pipInputView.backgroundColor = UIColor(red: (253.0/255.0), green: (159.0/255.0), blue: (47.0/255.0), alpha: 1.0);
    }

	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	
	// prepPan: UILongPressGestureRecognizer -> nil
	// I/O: tells the viewController to start dragging this pip
	//		updates view to show its being dragged
	
	func prepPan(recognizer: UILongPressGestureRecognizer) {
		if !panOverridden {
			if recognizer.state == .Began {
				_mainPipDirectory.viewController.setPipBeingDragged(self)
				
				showShadow()
			}else if recognizer.state == .Ended {
			
				hideShadow()
			}
		}
	}
	
	
	// showShadow: nil -> nil
	// I/O: shows drop shadow. Called at beginning of drag
	
	func showShadow() {
		layer.shadowOffset = CGSizeMake(5,5)
		layer.shadowOpacity = 0.5
	}
	
	
	// showShadow: nil -> nil
	// I/O: hides drop shadow. Called at end of drag
	
	func hideShadow() {
		layer.shadowOpacity = 0.0
		layer.shadowOffset = CGSizeMake(0, 0)
	}
	
	
	// updateLastLocation: nil -> nil
	// I/O: called by viewController on pipViewBeingDragged at beginning
	//		of drag.
	
	func updateLastLocation() {
		lastLocation = self.center
	}
	
	
	// updateArms: nil -> nil
	// I/O: updates all arms. Called when pip is dragged
	
	func updateArms() {
		for (inPip, armView) in inArms {
			armView.updateEnd(self.center)
		}
		
		for (outPip, armView) in outArms {
			armView.updateStart(self.center)
		}
	}
	
	
	// detectPan: UIPanGestureRecognizer -> nil
	// I/O: takes in recognizer. Only used if the pip is not being dragged.
	//		Passes info to viewController for arm display.
	
	func detectPan(recognizer: UIPanGestureRecognizer!){
		
		if !panOverridden && _mainPipDirectory.viewController.pipViewBeingDragged != self {
			
			if recognizer.state == .Began {
				_mainPipDirectory.viewController.scrollView.scrollEnabled = false
				
				var newArm: ArmView = ArmView(start: self.center, startPipID: self.pipId)
				superview?.addSubview(newArm)
				_mainPipDirectory.viewController.armViewBeingCreated = newArm
				superview?.bringSubviewToFront(self)
				
			}else if recognizer.state == .Ended {
				_mainPipDirectory.viewController.scrollView.scrollEnabled = true
			}
		}
		
	}

	
	
	// touchesBegan: NSSet, UIEvent -> nil
	// I/O: called when the user presses the UIView. This implementation
	//		tells the superview to bring this view to the front, and update
	//		lastLocation's value


    // [] - could be used to tell which node a connection is being made to
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        
		self.superview?.bringSubviewToFront(self)
        self.endEditing(true) // hide keyboard on touching any part of screen
	}
	
	// ---------------
	//  Accessors
	// ---------------

	func getModel() -> BasePip{
		return _mainPipDirectory.getPipByID(pipId!).model
	}
	
	func getArmPosForInput(inViewSpace: UIView) -> CGPoint{
		return inViewSpace.convertPoint(self.center, fromView: self)
	}
	
	func getArmPosForOutput(inViewSpace: UIView) -> CGPoint{
		return inViewSpace.convertPoint(self.center, fromView: self)
	}
	
	// ---------------
	//  Mutators
	// ---------------
	
	// setPipViewImage: UIImage -> nil
	// I/O: takes an UIImage, image, and sets pipImage to this value
	
	func setPipViewImage(image: UIImage){
		pipImage = image
		self.image = pipImage
	}
	
	// updatePip: nil -> nil
	// I/O: called when the model of a pip changes
	
	func updateView(){
	}
	
	// addArm: Int, Bool -> ArmView
	// I/O: takes an Int, toPipID, and a bool, isInputArm.
	//		creates an ArmView from this pip to toPipID,
	//		and appends it to the arm dictionary corresponding to
	//		isInputArm's value, finally returning the ArmView
	
	func addArm(newArm: ArmView, toPipID: Int, isInputArm: Bool){
		
		if isInputArm {
			inArms[toPipID] = newArm
		}else{
			outArms[toPipID] = newArm
		}
	}
	
	// removeArm: Int, Bool -> ArmView
	// I/O: takse an Int, toPipID, and a bool, isInputArm
	//		removes an ArmView from this pip, and from the 
	//		ArmView's superview
	
	func removeArm(toPip: Int, isInputArm: Bool) -> ArmView?{
		
		if isInputArm {
			if let arm = inArms[toPip] {
				inArms[toPip] = nil
				return arm
			}
		} else {
			if let arm = outArms[toPip] {
				outArms[toPip] = nil
				return arm
			}
		}
		return nil
	}
	
}