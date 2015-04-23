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
	
	var pipId: Int!
	
	var pipImage: UIImage!
	
	var longTouchdetected = false
	
	var pipInputView: UIView!
	var pipOutputView: UIView!
	
	// Dictionaries to hold references to arm views
	// Arm views are subviews of the containerView
	// Dictionary is of form: toPipID : ArmView
	var inArms: [Int : ArmView] = [:]
	var outArms: [Int : ArmView] = [:]
	
	//Used for dragging
	var lastLocation: CGPoint = CGPointMake(0, 0)
	
	
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
	
	init(point: CGPoint, image: UIImage, id: Int) {
		super.init(frame: CGRectMake(point.x, point.y, image.size.width, image.size.height))
		
		pipId = id
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		
		addGestureRecognizer(panRecognizer)
		
		pipImage = image
		self.contentMode = UIViewContentMode.ScaleAspectFit
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
    
    func changeInputViewColorOrange(){
        self.pipInputView.backgroundColor = UIColor(red: (253.0/255.0), green: (159.0/255.0), blue: (47.0/255.0), alpha: 1.0);
    }
	
	
	// detectPan: UIPanGestureRecognizer -> nil
	// I/O: takes in recognizer and computes the distance the user has panned
	//		finally applying this vector to the uiview's center, effectively
	//		moving the view.
	
	func detectPan(recognizer: UIPanGestureRecognizer!){
		var translation = recognizer.translationInView(self.superview!)
		self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
		
		for (toPip, armV) in inArms {
			armV.updateStart(getArmPosForInput(superview!))
		}
		
		for (toPip, armV) in outArms {
			armV.updateEnd(getArmPosForOutput(superview!))
		}
		
		if recognizer.state == UIGestureRecognizerState.Ended {
			_mainPipDirectory.viewController.pipStoppedBeingDragged(self)
		}else{
			_mainPipDirectory.viewController.pipStartedBeingDragged()
		}
		
		
	}
	
	
	// inputViewTapped: UITapGestureRecognizer -> nil
	// I/O: called by pipInputView's gesture recognizer,
	//		takes in recognizer and calls setActiveInputPip in viewController
	
	func inputViewTapped(recognizer: UITapGestureRecognizer!){
		_mainPipDirectory.setActiveInputPip(pipId)
	}
	
	
	// outputViewTapped: UITapGestureRecognizer -> nil
	// I/O: called by pipOutputView's gesture recognizer,
	//		takes in recognizer and calls setActiveOutputPip in viewController
	
	func outputViewTapped(recongizer: UITapGestureRecognizer!){
		_mainPipDirectory.setActiveOutputPip(pipId)
	}
	
	
	// touchesBegan: NSSet, UIEvent -> nil
	// I/O: called when the user presses the UIView. This implementation
	//		tells the superview to bring this view to the front, and update
	//		lastLocation's value
	
//	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        
		self.superview?.bringSubviewToFront(self)
		lastLocation = self.center
	}
	
	// [] - could be used to tell which node a connection is being made to
//	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent){
    
	}
	
	// ---------------
	//  Accessors
	// ---------------

	func getModel() -> BasePip{
		return _mainPipDirectory.getPipByID(pipId!).model
	}
	
	func getArmPosForInput(inViewSpace: UIView) -> CGPoint{
		return inViewSpace.convertPoint(frame.origin, fromView: inViewSpace)
	}
	
	func getArmPosForOutput(inViewSpace: UIView) -> CGPoint{
		return inViewSpace.convertPoint(frame.origin, fromView: inViewSpace)
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
	
	func removeArm(toPip: Int, isInputArm: Bool) -> ArmView{
		
		if isInputArm {
			let arm: ArmView = inArms[toPip]!
			inArms[toPip] = nil
			return arm
		} else {
			let arm: ArmView = outArms[toPip]!
			outArms[toPip] = nil
			return arm
		}
	}
	
}