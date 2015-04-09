//
//  ColorPip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class ColorOutput{
	
	var color: UIColor!
	
    init(){
        color = UIColor.blackColor()
    }
    
    func getColor() -> UIColor{
        return color
    }
    
    func setColor(newColor: UIColor){
        color = newColor
    }
}

class ColorPip: BasePip{
	
	var output: ColorOutput!
	
	init(vc: ViewController, id: Int){
		super.init(vc: vc, pipType: PipType.Color, id: id)
		
		output = ColorOutput()
		
    }
    
    func updateColor(newVal: UIColor){
        output.setColor(newVal)
		updateReliantPips()
    }
    
    // getOutput loops through the array of inputPips and processes each, storing the information in output
    
    // Input: Array of input pips
    
    func getOutput() -> ColorOutput{
        // format
        
        // Takes in the last input
        // color -> text
        // Output is always of same type of Pip
        
        for item in inputPipIDs{
			
			let inPip = _mainPipDirectory.getPipByID(item).model
            
            switch inPip.getPipType(){
                
            case .Text:
               
                return output
                
            case .Color:
                let castItem: ColorPip! = inPip as? ColorPip
                
                if castItem != nil{
                    output.color = castItem.getOutput().getColor() // color of item.color
                }
            default:
                return output
            }
            
        }
        return output
        
    }
    
}
