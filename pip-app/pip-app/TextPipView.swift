//
//  TextPipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class TextPipView: BasePipView, UITextFieldDelegate {
    
	var textField: UITextField?
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
    
	
	
	// init: CGPoint -> ?
	// I/O: takse a CGPoint and passes it to super.init as the views position
	//		sets the image of the node, and initializes the textField used for
	//		entry to the model
	
	init (point: CGPoint, id: Int) {
		super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Text), id: id)
		let scale: CGFloat = 1.5
		
		self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width * scale, frame.height * scale)
		
		textField = UITextField(frame: CGRectMake(10 * scale, 27 * scale, 150 * scale, 15 * scale))
		textField!.borderStyle = UITextBorderStyle.RoundedRect
		textField!.addTarget(self, action: "textFieldEditingBegun:", forControlEvents: UIControlEvents.EditingDidBegin)
		textField!.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
		textField!.addTarget(self, action: "textFieldEditingOver:", forControlEvents: UIControlEvents.EditingDidEnd)
		textField!.font = UIFont(name: textField!.font!.fontName, size: 12)
		textField!.backgroundColor = UIColor(red: 0.48, green: 0.76, blue: 0.43, alpha: 1.0)
		textField!.textColor = UIColor.blackColor()
		self.addSubview(textField!)
        
        textField!.delegate = self
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
	
	// textFieldEditingBegun: UITextField -> nil
	// I/O: reverts the state of the text field to its base output
	
	func textFieldEditingBegun(field: UITextField) {
		field.text = (getModel() as? TextPip)?.baseOutput
	}
	
	// textFieldDidChage: UITextField -> nil
	// I/O: takes in a UITextField, field, whose content has just changed.
	// Note: Use this to pass the content of field to the model
	
	func textFieldDidChange(field: UITextField) {
		(getModel() as? TextPip)?.updateText(field.text)
		(getModel() as? TextPip)?.updateReliantPips()
	}
	
	func textFieldEditingOver(field: UITextField) {
		updateView()
	}
	
	// updateView: nil -> nil
	// I/O: updates the model and forces the view to reflect it
	
	override func updateView() {
		let output = (getModel() as? TextPip)?.getOutput()
		textField!.text = output?.text
		textField!.textColor = output?.color
		(getModel() as? TextPip)?.updateReliantPips()
	}
}