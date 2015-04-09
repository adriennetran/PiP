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
	
	// Reference
	var viewController: ViewController!
	
	// Pip Type enum
    private let pipType: PipType! // let so never changes
	private let pipID: Int
	
    // Input Pips represented as an array of type pip
	var inputPipIDs: [Int]!
	var outputPipIDs: [Int]!
	
	init(vc: ViewController, pipType: PipType, id: Int){
		self.pipType = pipType
		self.pipID = id
		
		inputPipIDs = []
		outputPipIDs = []
		
	}
	
	// ---------------
	//    Accessors
	// ---------------
	
	// getPipType: nil -> PipType
	// I/O: accessor for pipType
	
	func getPipType() -> PipType{
		return pipType
	}
	
	func getPipID() -> Int{
		return pipID
	}
    
	// ---------------
	//    Mutators
	// ---------------
	
	func setInput(inputPipID: Int){
		self.inputPipIDs.append(inputPipID)
    }
	
	func setOutput(outputPipID: Int){
		self.outputPipIDs.append(outputPipID)
	}
}
