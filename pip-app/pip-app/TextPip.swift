//
//  TextPip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class TextOutput{
//    saves information from past Pips

    // if there aren't data types that combine the two
    var text: String!
    var color: UIColor!
	
	init(){
		text = ""
		color = UIColor.blackColor()
	}
	
	func getText() -> String{
		return text
	}
    
    func setText(newText: String){
        text = newText
    }
    
    func getColor() -> UIColor{
        return color
    }
    
    func setColor(newColor: UIColor){
        color = newColor
    }
}

class TextPip: BasePip {
    
    // of type text
    var output: TextOutput!
    
    // TextPip's constructor
	init(vc: ViewController, id: Int){
		super.init(vc: vc, pipType: PipType.Text, id: id)
		
		output = TextOutput()
    }

    
    func updateText(newVal: String){
		output.setText(newVal)
    }
    
	// getOutput: nil -> TextOutput
	// I/O: updates the output field of the object
	
    func getOutput() -> TextOutput{
        
        for item in inputPipIDs{
			
			let inPip = _mainPipDirectory.getPipByID(item).model
			
            switch inPip.getPipType(){

			case .Text:
				let castItem: TextPip! = inPip as? TextPip
				
				if castItem != nil {
					let newString = output.getText() + castItem.getOutput().getText()
					output.setText(newString)
				}
				
			case .Color:
				let castItem: ColorPip! = inPip as? ColorPip
				
				if castItem != nil {
					let setColor = castItem.output.color
					println(setColor)
					output.setColor(setColor)
				}
			default: // Switch Pip
				let castItem: SwitchPip! = inPip as? SwitchPip
				
				if castItem != nil {
					output.setText("\(castItem.getOutput())")
				}
            }
            
        }
		
        return output
        
    }
}