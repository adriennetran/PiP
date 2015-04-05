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
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	//init: CGRect -> ? (it technically doesn't return a BasePipView
	//I/O: takes in a CGRect, frame, which represents the bounds and position of the view
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		pipImage = UIImage(named: "pip-logo")
		self.image = pipImage
		
		
		
	}
	
	
}