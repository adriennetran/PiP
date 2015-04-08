//
//  TextPip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation

class TextOutput{
//    saves information from past Pips

    // if there aren't data types that combine the two
    var text: String
    var color: UIColor
    
    // not included: sound
    
    var myswitch: Int

}

class TextPip: BasePip {
    
    // of type text
    var output: TextOutput
    var inputPips: [BasePip]?
    
    // TextPip's constructor
    init(){
        type = PipType.Text
    }

    
    func updateText(newVal: String){
        output.text = newVal
    }
    
    // getOutput loops through the array of inputPips and processes each, storing the information in output
    
    // Input: Array of input pips
    
    func getOutput(inputPips: Array) -> TextOutput{
        // format
        
        // Takes in the last input
        // color -> text
        // Output is always of same type of Pip
        
        for item in inputPips{
            
            switch item.type{

            case .Text:
                output.text += (TextPip)(item).getOutput()
                
            case .Color:
                output.color = (ColorPip) (item).getOutput() // color of item.color
        
            }
            
        }
        
    }
}