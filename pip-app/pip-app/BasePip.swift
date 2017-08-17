//
//  BasePip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

enum PipType: Int {
	case Text
	case Color
	case Button
	case Switch
	case Accel
	case Image
	case Audio
	case Math
}

class BasePipOutput: CustomStringConvertible {
	var description: String {
		return "BasePipOutput. NOTE: description not overridden."
	}
}

class BasePip {
	
	// Pip Type enum
    let pipType: PipType! // let so never changes
    let pipID: Int!
	
    // Input Pips represented as an array of type pip
	// These are the pips WHOSE OUTPUT IS BEING RECEIVED
	var inputPipIDs: [Int]!
	// These are the pips BEING OUTPUT TO
	var outputPipIDs: [Int]!
    
    
	
	init(pipType: PipType, id: Int){
		self.pipType = pipType
		self.pipID = id
		
		inputPipIDs = []
		outputPipIDs = []
		
	}
	
	// pipToBeDestroyed: nil -> nil
	// I/O: called when the user deletes a pip.
	//		removes all connections
	
	func pipToBeDestroyed() {
		for ele in self.inputPipIDs {
			// means this is the output
			_mainPipDirectory.breakConnection(ele, outPipID: self.pipID)
		}
		
		for ele in self.outputPipIDs {
			_mainPipDirectory.breakConnection(self.pipID, outPipID: ele)
		}
	}
	
	// ---------------
	//    Accessors
	// ---------------
	
	// getPipType: nil -> PipType
	// I/O: accessor for pipType
	
	func getPipType() -> PipType{
		return pipType!
	}
	
	// getPipID: nil -> Int
	// I/O: accessor for pipID
	
	func getPipID() -> Int{
		return pipID!
	}
    
	// ---------------
	//    Mutators
	// ---------------
	
	// setInput: Int -> nil
	// I/O: adds inputPipID to this pip's list of inputs as long as
	//		inputPipID is not already an input, or is not this pip's ID
	
	func setInput(_ inputPipID: Int){
		if !inputPipIDs.contains(inputPipID) && !(inputPipID == self.pipID){
			self.inputPipIDs.append(inputPipID)
		}
    }
	
	// setOutput: Int -> nil
	// I/O: adds outputPipID to this pip's list of outputs as long as
	//		outputPipID is not already an output, or is not this pip's ID
	func setOutput(_ outputPipID: Int){
		if !outputPipIDs.contains(outputPipID) && !(outputPipID == self.pipID){
			self.outputPipIDs.append(outputPipID)
		}
	}
	
	// removeInput: Int -> nil
	// I/O: removes inputPipID from this pip's list of inputs
	
	func removeInput(_ inputPipID: Int) {
        if let index = inputPipIDs.index(of: inputPipID) {
			self.inputPipIDs.remove(at: index)
		}
	}
	
	// removeOutput: Int -> nil
	// I/O: removes inputPipID from this pip's list of inputs
	
	func removeOutput(_ outputPipID: Int) {
        if let index = outputPipIDs.index(of: outputPipID) {
			self.outputPipIDs.remove(at: index)
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
