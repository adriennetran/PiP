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
		let nFrame = CGRect(x: min(start.x, end.x), y: min(start.y, end.y), width: abs((start.x - end.x)), height: abs(start.y - end.y))
		super.init(frame: nFrame)
		
		self.startPipID = pipFromID
		
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		self.start = start
		self.end = end
		
		isUserInteractionEnabled = false
		
		self.layer.masksToBounds = false
	}
	
	// init: CGPoint, int -> ArmView
	// I/O: used when arms are created. Takes in a start, and the inputPip's ID
	
	init(start: CGPoint, startPipID: Int) {
		super.init(frame: CGRect(x: start.x, y: start.y, width: 0, height: 0))
		
		self.startPipID = startPipID
		self.start = start
		self.end = start
		
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		self.layer.masksToBounds = false
	}
	
	func makeConnection() {
		if !(hasStart && hasEnd) {
			print("tried to make connection without start or end")
			return
		}
		
		let s = _mainPipDirectory.getPipByID(startPipID)
		let e = _mainPipDirectory.getPipByID(endPipID)
		
		updateFrame()
		
		s.view.addArm(self, toPipID: endPipID, isInputArm: false)
		s.model.setOutput(endPipID)
		
		e.view.addArm(self, toPipID: startPipID, isInputArm: true)
		e.model.setInput(startPipID)
		
		s.view.updateView()
		e.view.updateView()
		
		superview?.sendSubview(toBack: self)
		
	}
	
	func setHand(_ hand: HandView) {
		self.handView = hand
	}
	
	// updateFrame: nil -> nil
	// I/O: creates a frame to contain both start and end
	
	func updateFrame() {
		//Corners
		let tLeft = CGPoint(x: min(start.x-100, end.x-100), y: min(start.y, end.y) - 25)
		let tRight = CGPoint(x: max(start.x+100, end.x+100), y: tLeft.y)
		let bLeft = CGPoint(x: tLeft.x, y: max(start.y, end.y) + 25)
		
		let nFrame = CGRect(x: tLeft.x, y: tLeft.y, width: abs(tLeft.x - tRight.x), height: abs(tLeft.y - bLeft.y))
		self.frame = nFrame
		setNeedsDisplay()
	}
	
	// updateStart: CGPoint -> nil
	// I/O: sets start to newStart and updates the frame to reflect changes
	
	func updateStart(_ newStart: CGPoint) {
		start = newStart
		updateFrame()
	}
	
	// updateEnd: CGPoint -> nil
	// I/O: sets end to newEnd and updates the frame to reflect changes
	
	func updateEnd(_ newEnd: CGPoint) {
		end = newEnd
		updateFrame()
	}
	
	// override drawRect: CGRect -> nil
	// I/O: defines drawing behavior for arms
	override func draw(_ rect: CGRect) {
		
		// Drawing overhead
		let context = UIGraphicsGetCurrentContext()
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		// Set line width
		context?.setLineWidth(5.0)
		// Set Color
		let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
		
		let startColor: CGColor = _mainPipDirectory.getColorForPipType(_mainPipDirectory.getPipByID(startPipID).model.getPipType()).cgColor
		
		var endColor: CGColor!
		if hasEnd {
			endColor = _mainPipDirectory.getColorForPipType(_mainPipDirectory.getPipByID(endPipID).model.getPipType()).cgColor
		}else{
			endColor = startColor
		}
		
		// Convert start and end points to superview coordinate space
		let startConv: CGPoint = self.convert(start, from: superview)
		let endConv: CGPoint = self.convert(end, from: superview)
		let halfPoint: CGPoint = CGPoint(x: (startConv.x + endConv.x) / 2, y: (startConv.y + endConv.y) / 2)
		
		let startInfl = CGPoint(x: startConv.x + 200, y: startConv.y)
		let endInfl = CGPoint(x: endConv.x - 200, y: endConv.y)
		
		let hand = CGRect(x: (startConv.x + endConv.x)/2, y: (startConv.y + endConv.y)/2, width: 25, height: 25)
		
		// Set Line to Draw
		context?.move(to: CGPoint(x: startConv.x, y: startConv.y))
//		CGContextAddCurveToPoint(context, startInfl.x, startInfl.y, halfPoint.x, halfPoint.y, halfPoint.x, halfPoint.y)
        context?.addCurve(to: CGPoint(x: halfPoint.x, y:halfPoint.y), control1: CGPoint(x: startInfl.x, y: startInfl.y), control2: CGPoint(x: halfPoint.x, y: halfPoint.y))
		
		context?.setStrokeColor(startColor)
		context?.strokePath()
		
		context?.move(to: CGPoint(x: halfPoint.x, y: halfPoint.y))
//		CGContextAddCurveToPoint(context, halfPoint.x, halfPoint.y, endInfl.x, endInfl.y, endConv.x, endConv.y)
		context?.addCurve(to: CGPoint(x: endConv.x, y: endConv.y), control1: CGPoint(x: halfPoint.x, y: halfPoint.y), control2: CGPoint(x: endInfl.x, y: endInfl.y))
        // Draw Arm
		context?.setStrokeColor(endColor)
		context?.strokePath()
		//CGContextFillEllipseInRect(context, hand)
		
	}
}
