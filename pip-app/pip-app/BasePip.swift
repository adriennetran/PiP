//
//  BasePip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

class BasePip {
	
	// Pip Type enum
    
    enum PipType{
        case Text
        case Color
        case Button
        case Switch
    }
    
    // Input Pips represented as an array of type pip
    var inputPips: Array
    
	// getPipType
	
    func setInput(inputPip: BasePip){
        inputPips.append(inputPip)
    }
    
    let type: PipType! // let so never changes
	
}
