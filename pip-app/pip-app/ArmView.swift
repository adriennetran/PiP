//
//  ArmView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/20/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class ArmView: UIView {
	
	var startPipID: Int!
	var endPipID: Int!
	var handView: HandView!
	
	var start: CGPoint!
	var end: CGPoint!
	
	var hasStart: Bool {
		get {
			return startPipID != nil
		}
	}
	
	var hasEnd: Bool {
		get {
			return endPipID != nil
		}
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// init: CGPoint, CGPoint -> ArmView
	// I/O: creates a frame to contain both CGPoints, start and end
	
	init(start: CGPoint, end: CGPoint, pipFromID: Int) {
		let nFrame = CGRectMake(min(start.x, end.x), min(start.y, end.y), abs((start.x - end.x)), abs(start.y - end.y))
		super.init(frame: nFrame)
		
		self.startPipID = pipFromID
		
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		self.start = start
		self.end = end
		
		userInteractionEnabled = false
		
		self.layer.masksToBounds = false
	}
	
	// init: CGPoint, int -> ArmView
	// I/O: used when arms are created. Takes in a start, and the inputPip's ID
	
	init(start: CGPoint, startPipID: Int) {
		super.init(frame: CGRectMake(start.x, start.y, 0, 0))
		
		self.startPipID = startPipID
		self.start = start
		self.end = start
		
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		self.layer.masksToBounds = false
	}
	
	func makeConnection() {
		if !(hasStart && hasEnd) {
			println("tried to make connection without start or end")
			return
		}
		
		var s = _mainPipDirectory.getPipByID(startPipID)
		var e = _mainPipDirectory.getPipByID(endPipID)
		
		updateFrame()
		
		s.view.addArm(self, toPipID: endPipID, isInputArm: false)
		s.model.setOutput(endPipID)
		
		e.view.addArm(self, toPipID: startPipID, isInputArm: true)
		e.model.setInput(startPipID)
		
		s.view.updateView()
		e.view.updateView()
		
		superview?.sendSubviewToBack(self)
		
	}
	
	func setHand(hand: HandView) {
		self.handView = hand
	}
	
	// updateFrame: nil -> nil
	// I/O: creates a frame to contain both start and end
	
	func updateFrame() {
		//Corners
		let tLeft = CGPoint(x: min(start.x-100, end.x-100), y: min(start.y, end.y))
		let tRight = CGPoint(x: max(start.x+100, end.x+100), y: tLeft.y)
		let bLeft = CGPoint(x: tLeft.x, y: max(start.y, end.y))
		
		let nFrame = CGRectMake(tLeft.x, tLeft.y, abs(tLeft.x - tRight.x), abs(tLeft.y - bLeft.y))
		self.frame = nFrame
		setNeedsDisplay()
	}
	
	// updateStart: CGPoint -> nil
	// I/O: sets start to newStart and updates the frame to reflect changes
	
	func updateStart(newStart: CGPoint) {
		start = newStart
		updateFrame()
	}
	
	// updateEnd: CGPoint -> nil
	// I/O: sets end to newEnd and updates the frame to reflect changes
	
	func updateEnd(newEnd: CGPoint) {
		end = newEnd
		updateFrame()
	}
	
	// override drawRect: CGRect -> nil
	// I/O: defines drawing behavior for arms
	override func drawRect(rect: CGRect) {
		
		// Drawing overhead
		let context = UIGraphicsGetCurrentContext()
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		// Set line width
		CGContextSetLineWidth(context, 5.0)
		// Set Color
		let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
		let color = CGColorCreate(colorSpace, components)
		CGContextSetStrokeColorWithColor(context, color)
		
		// Convert start and end points to superview coordinate space
		let startConv: CGPoint = self.convertPoint(start, fromView: superview)
		let endConv: CGPoint = self.convertPoint(end, fromView: superview)
		
		let startInfl = CGPoint(x: startConv.x + 200, y: startConv.y)
		let endInfl = CGPoint(x: endConv.x - 200, y: endConv.y)
		
		let hand = CGRectMake((startConv.x + endConv.x)/2, (startConv.y + endConv.y)/2, 25, 25)
		
		// Set Line to Draw
		CGContextMoveToPoint(context, startConv.x, startConv.y)
		CGContextAddCurveToPoint(context, startInfl.x, startInfl.y, endInfl.x, endInfl.y, endConv.x, endConv.y)
		// Draw Arm
		CGContextStrokePath(context)
		//CGContextFillEllipseInRect(context, hand)
		
	}
}