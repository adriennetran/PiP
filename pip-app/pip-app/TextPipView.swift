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
	
	var textModel: TextPip!
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	
	// init: CGPoint -> ?
	// I/O: takse a CGPoint and passes it to super.init as the views position
	//		sets the image of the node, and initializes the textField used for
	//		entry to the model
	
	init (point: CGPoint, vC: ViewController) {
		super.init(point: point, image: UIImage(named: "textPip-image")!, vC: vC)
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 80, self.frame.height)
		
		textField = UITextField(frame: CGRectMake(75, 75, 315, 45))
		textField.borderStyle = UITextBorderStyle.RoundedRect
		textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
		textField.font = UIFont(name: textField.font!.fontName, size: 24)
		self.addSubview(textField)
		
		pipInputView.frame = CGRectMake(frame.width-40, 0, 40, frame.height)
		pipOutputView.frame = CGRectMake(0, 0, 40, frame.height)
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return textModel
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// setTextModel: TextPip -> nil
	// I/O: creates connection between the model and view
	
	func setTextModel(basePip: TextPip) {
		self.textModel = basePip
	}
	
	// textFieldDidChage: UITextField -> nil
	// I/O: takes in a UITextField, field, whose content has just changed.
	// Note: Use this to pass the content of field to the model
	
	func textFieldDidChange(field: UITextField) {
		textModel.updateText(field.text)
	}
	
	override func updatePip() {
		textField.text = textModel.getOutput().text
		println(textModel.getOutput())
	}
}