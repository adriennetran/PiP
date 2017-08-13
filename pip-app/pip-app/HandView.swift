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
	var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(pos: CGPoint, inPipID: Int, outPipID: Int) {
		super.init(frame: CGRect(x: pos.x - CGFloat(HandView.HAND_WIDTH / 2), y: pos.y - CGFloat(HandView.HAND_HEIGHT / 2), width: CGFloat(HandView.HAND_WIDTH), height: CGFloat(HandView.HAND_HEIGHT)))
		backgroundColor = UIColor.black
		
		self.inPipID = inPipID
		self.outPipID = outPipID
		
		let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HandView.detectPan(_:)))
		
		addGestureRecognizer(panRecognizer)
		lastLocation = self.center
	}
	
	init(pos: CGPoint, armA: ArmView, armB: ArmView, inPipID: Int, outPipID: Int) {
		super.init(frame: CGRect(x: pos.x - CGFloat(HandView.HAND_WIDTH / 2), y: pos.y - CGFloat(HandView.HAND_HEIGHT / 2), width: CGFloat(HandView.HAND_WIDTH), height: CGFloat(HandView.HAND_HEIGHT)))
		
		self.inPipID = inPipID
		self.outPipID = outPipID
		
		arms.append(armA)
		arms.append(armB)
		
		armA.end = center
		armB.end = center
		
		let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HandView.detectPan(_:)))
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
		
		addGestureRecognizer(panRecognizer)
		addGestureRecognizer(tapRecognizer)

		lastLocation = self.center
	}
	
	func setArms(_ armA: ArmView, armB: ArmView) {
		arms.append(armA)
		arms.append(armB)
		
		armA.updateEnd(center)
		armB.updateEnd(center)
	}
	
	func detectPan(_ sender: UIPanGestureRecognizer) {
		var translation = sender.translation(in: self.superview!)
		self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
		
		for arm in arms {
			arm.updateEnd(self.center)
		}
		
		if (sender.state == UIGestureRecognizerState.ended) {
			if _mainPipDirectory.viewController.stoppedBeingDragged(self.frame){
				_mainPipDirectory.deleteHand(self)
			}
		}else{
			_mainPipDirectory.viewController.startedBeingDragged()
		}
		
	}
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastLocation = self.center
        self.endEditing(true) // dismiss keyboard
    }
	
	func handToBeDeleted() {
		
	}
}
