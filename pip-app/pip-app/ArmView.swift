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
	
	var start: CGPoint!
	var end: CGPoint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		start = CGPoint(x: frame.origin.x, y: frame.origin.y)
		end = CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height)
		
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// init: CGPoint, CGPoint -> ArmView
	// I/O: creates a frame to contain both CGPoints, start and end
	
	init(start: CGPoint, end: CGPoint) {
		let nFrame = CGRectMake(min(start.x, end.x), min(start.y, end.y), abs((start.x - end.x)), abs(start.y - end.y))
		super.init(frame: nFrame)
		
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		self.start = start
		self.end = end
		
		userInteractionEnabled = false
	}
	
	// updateFrame: nil -> nil
	// I/O: creates a frame to contain both start and end
	
	func updateFrame() {
		let nFrame = CGRectMake(min(start.x, end.x), min(start.y, end.y), abs((start.x - end.x)), abs(start.y - end.y))
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
		let startConv: CGPoint = self.convertPoint(start, fromView: superview?)
		let endConv: CGPoint = self.convertPoint(end, fromView: superview?)
		
		// Set Line to Draw
		CGContextMoveToPoint(context, startConv.x, startConv.y)
		CGContextAddLineToPoint(context, endConv.x, endConv.y)
		
		// Draw Arm
		CGContextStrokePath(context)
	}
}