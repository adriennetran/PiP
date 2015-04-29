//
//  HandView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/27/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class HandView: UIView {
	
	//CONSTANTS
	static let HAND_WIDTH: Float = 50.0
	static let HAND_HEIGHT: Float = 50.0
	
	var arms: [ArmView] = []
	
	var inPipID, outPipID: Int!
	
	//Used for dragging
	var lastLocation: CGPoint = CGPointMake(0, 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(pos: CGPoint, inPipID: Int, outPipID: Int) {
		super.init(frame: CGRectMake(pos.x - CGFloat(HandView.HAND_WIDTH / 2), pos.y - CGFloat(HandView.HAND_HEIGHT / 2), CGFloat(HandView.HAND_WIDTH), CGFloat(HandView.HAND_HEIGHT)))
		backgroundColor = UIColor.blackColor()
		
		self.inPipID = inPipID
		self.outPipID = outPipID
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		
		addGestureRecognizer(panRecognizer)
		lastLocation = self.center
	}
	
	init(pos: CGPoint, armA: ArmView, armB: ArmView, inPipID: Int, outPipID: Int) {
		super.init(frame: CGRectMake(pos.x - CGFloat(HandView.HAND_WIDTH / 2), pos.y - CGFloat(HandView.HAND_HEIGHT / 2), CGFloat(HandView.HAND_WIDTH), CGFloat(HandView.HAND_HEIGHT)))
		
		self.inPipID = inPipID
		self.outPipID = outPipID
		
		arms.append(armA)
		arms.append(armB)
		
		armA.end = center
		armB.end = center
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		var tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
		
		addGestureRecognizer(panRecognizer)
		addGestureRecognizer(tapRecognizer)

		lastLocation = self.center
	}
	
	func setArms(armA: ArmView, armB: ArmView) {
		arms.append(armA)
		arms.append(armB)
		
		armA.updateEnd(center)
		armB.updateEnd(center)
	}
	
	func detectPan(sender: UIPanGestureRecognizer) {
		var translation = sender.translationInView(self.superview!)
		self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
		
		for arm in arms {
			arm.updateEnd(self.center)
		}
		
		if (sender.state == UIGestureRecognizerState.Ended) {
			if _mainPipDirectory.viewController.stoppedBeingDragged(self.frame){
				_mainPipDirectory.deleteHand(self)
			}
		}else{
			_mainPipDirectory.viewController.startedBeingDragged()
		}
		
	}
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		lastLocation = self.center
        self.endEditing(true) // dismiss keyboard
    }
	
	func handToBeDeleted() {
		
	}
}