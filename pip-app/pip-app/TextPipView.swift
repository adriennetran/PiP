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
	
	
	// init: CGPoint -> ?
	// I/O: takse a CGPoint and passes it to super.init as the views position
	//		sets the image of the node, and initializes the textField used for
	//		entry to the model
	
	init (point: CGPoint, id: Int) {
		super.init(point: point, image: UIImage(named: "textPip-image")!, id: id)
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 80, self.frame.height)
		
		textField = UITextField(frame: CGRectMake(75, 75, 315, 45))
		textField.borderStyle = UITextBorderStyle.RoundedRect
		textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
		textField.font = UIFont(name: textField.font!.fontName, size: 24)
		textField.backgroundColor = UIColor.whiteColor()
		textField.textColor = UIColor.blackColor()
		self.addSubview(textField)
		
		pipInputView.frame = CGRectMake(frame.width-40, 0, 40, frame.height)
		pipOutputView.frame = CGRectMake(0, 0, 40, frame.height)
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// textFieldDidChage: UITextField -> nil
	// I/O: takes in a UITextField, field, whose content has just changed.
	// Note: Use this to pass the content of field to the model
	
	func textFieldDidChange(field: UITextField) {
		(getModel() as? TextPip)?.updateText(field.text)
	}
	
	override func updateView() {
		let output = (getModel() as? TextPip)?.getOutput()
		textField.text = output?.text
		textField.textColor = output?.color
		println("update view: \(textField.textColor)")
	}
}