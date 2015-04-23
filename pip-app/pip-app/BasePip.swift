//
//  BasePip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

enum PipType: Int{
	case Text, Color, Button, Switch
}

class BasePip {
	
	// Pip Type enum
    private let pipType: PipType! // let so never changes
	private let pipID: Int
	
    // Input Pips represented as an array of type pip
	var inputPipIDs: [Int]!
	var outputPipIDs: [Int]!
	
	init(pipType: PipType, id: Int){
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
	
	// getPipID: nil -> Int
	// I/O: accessor for pipID
	
	func getPipID() -> Int{
		return pipID
	}
    
	// ---------------
	//    Mutators
	// ---------------
	
	// setInput: Int -> nil
	// I/O: adds inputPipID to this pip's list of inputs as long as
	//		inputPipID is not already an input, or is not this pip's ID
	
	func setInput(inputPipID: Int){
		if !contains(inputPipIDs, inputPipID) && !(inputPipID == self.pipID){
			self.inputPipIDs.append(inputPipID)
		}
    }
	
	// setOutput: Int -> nil
	// I/O: adds outputPipID to this pip's list of outputs as long as
	//		outputPipID is not already an output, or is not this pip's ID
	func setOutput(outputPipID: Int){
		if !contains(outputPipIDs, outputPipID) && !(outputPipID == self.pipID){
			self.outputPipIDs.append(outputPipID)
		}
	}
	
	// modelDidChange: nil -> nil
	// I/O: called anytime the model's data is modified
	//		updates the view to reflect changes
	func modelDidChange(){
		_mainPipDirectory.getPipByID(pipID).view.updateView()
	}
	
	// updateReliantPips: nil -> nil
	// I/O: loops through outputPipIDs, and updates them to reflect changes
	//		to this pip.
	func updateReliantPips(){
		for pID in outputPipIDs {
			_mainPipDirectory.updatePip(pID)
		}
	}
}
