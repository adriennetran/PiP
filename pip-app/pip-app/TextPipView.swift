//
//  TextPipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class TextPipView: BasePipView {
	
	var textField: UITextField!
	
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	init (point: CGPoint) {
		super.init(frame: CGRectMake(point.x, point.y, 400/2, 150/2))
		
		setPipViewImage(UIImage(named: "textPip-image")!)
		
		textField = UITextField(frame: CGRectMake(40, 38, 150, 20))
		textField.borderStyle = UITextBorderStyle.RoundedRect
		textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
		
		self.addSubview(textField)
	}
	
	// textFieldDidChage: UITextField -> nil
	// I/O: takes in a UITextField, field, whose content has just changed.
	// Note: Use this to pass the content of field to the model
	func textFieldDidChange(field: UITextField) {
		
	}
}