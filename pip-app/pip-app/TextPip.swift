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
    
    // not included: sound
    
    var myswitch: Int?
	
	init(){
		
	}
	
	func getText() -> String{
		return text
	}
    
    func setText(newText: String){
        text = newText
    }
}

class TextPip: BasePip {
    
    // of type text
    var output: TextOutput!
    
    // TextPip's constructor
    init(){
		super.init(pipType: PipType.Text)
    }

    
    func updateText(newVal: String){
        output.setText(newVal)
        
    }
    
    // getOutput loops through the array of inputPips and processes each, storing the information in output
    
    // Input: Array of input pips
    
    func getOutput() -> TextOutput{
        // format
        
        // Takes in the last input
        // color -> text
        // Output is always of same type of Pip
        
        for item in inputPips{
            
            switch item.getPipType(){

			case .Text:
				let castItem: TextPip! = item as? TextPip
				
				if castItem != nil {
					output.text = castItem.getOutput().getText()
				}
                return output
				
//            case .Color:
//				let castItem: ColorPip! = item as? ColorPip
//				
//				if castItem != nil{
//					output.color = castItem.getOutput().getColor() // color of item.color
//				}
            default:
                return output
            }
            
        }
        return output
        
    }
}