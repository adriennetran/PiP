//
//  MathPipView.swift
//  pip-app
//
//  Created by Peter Slattery on 5/13/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class MathPipView: BasePipView, UITextFieldDelegate {
	
	var textField: UITextField!
	
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	init (point: CGPoint, id: Int) {
		super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Math), id: id)
		
		textField = UITextField(frame: CGRectMake(10, 27, 50, 50))
		textField.borderStyle = .RoundedRect
		textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
		textField.font = UIFont(name: textField.font!.fontName, size: 12)
		textField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		textField.textColor = UIColor.blackColor()
		self.addSubview(textField!)
		
		textField.delegate = self
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.endEditing(true)
		return false
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}
	
	// textFieldDidChage: UITextField -> nil
	// I/O: takes in a UITextField, field, whose content has just changed.
	// Note: Use this to pass the content of field to the model
	
	func textFieldDidChange(field: UITextField) {
		(getModel() as? MathPip)?.updateNumber(Float(field.text.toInt()!))
		(getModel() as? MathPip)?.updateReliantPips()
	}
	
	override func updateView() {
		let output = (getModel() as? MathPip)?.getOutput()
		textField.text = "\(output?.number)"
		(getModel() as? MathPip)?.updateReliantPips()
	}
	
	
}