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
	
	let pipImage: UIImage!
	
	//Used for dragging
	var lastLocation: CGPoint = CGPointMake(0, 0)
	
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	//init: CGRect -> ? (it technically doesn't return a BasePipView
	//I/O: takes in a CGRect, frame, which represents the bounds and position of the view
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
		addGestureRecognizer(panRecognizer)
		
		pipImage = UIImage(named: "pip-logo")
		self.image = pipImage
		
		self.userInteractionEnabled = true;
		
		
		
	}
	
	func detectPan(recognizer: UIPanGestureRecognizer!){
		println("2")
		var translation = recognizer.translationInView(self.superview!)
		self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		self.superview?.bringSubviewToFront(self)
		
		lastLocation = self.center
		
		println("1")
	}
	
	
}