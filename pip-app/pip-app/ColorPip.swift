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
    init(){
        
    }
    var color: UIColor!
    var text: String!
    
    func getColor() -> UIColor{
        return color
    }
    
    func setColor(newColor: UIColor){
        color = newColor
    }
}

class ColorPip: BasePip{
    
    var output: ColorOutput!
    
    init(){
        super.init(pipType: PipType.Color)
        
    }
    
    func updateColor(newVal: UIColor){
        output.setColor(newVal)
    }
    
    func getOutput(){
        
    }
    
    // getOutput loops through the array of inputPips and processes each, storing the information in output
    
    // Input: Array of input pips
    
    func getOutput() -> ColorOutput{
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
                
            case .Color:
                let castItem: ColorPip! = item as? ColorPip
                
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
