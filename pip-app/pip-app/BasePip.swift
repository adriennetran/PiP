//
//  BasePip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

enum PipType{
	case Text, Color, Button, Switch
}

class BasePip {
	
	// Pip Type enum
    private let pipType: PipType! // let so never changes
    
    // Input Pips represented as an array of type pip
	var inputPips: [BasePip]!
	
	init(pipType: PipType){
		self.pipType = pipType
	}
	
	// getPipType: nil -> PipType
	// I/O: accessor for pipType
	
	func getPipType() -> PipType{
		return pipType
	}
    
	// getPipType
	
    func setInput(inputPip: BasePip){
		inputPips.append(inputPip)
    }
}
