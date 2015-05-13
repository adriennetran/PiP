//
//  MathPip.swift
//  pip-app
//
//  Created by Peter Slattery on 5/13/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation

class MathOutput: BasePipOutput {
	var number: Float!
	
	override init() {
		number = 0
	}
	
	override var description: String {
		return "\(number)"
	}
}

enum MathPipOperations: Int{
	//Operations are applied to all inputs in order
	case Add
	case Subtract
	case Multiply
	case Divide
}

class MathPip: BasePip {
	
	var output: MathOutput!
	
	var operation: MathPipOperations = .Add
	
	init(id: Int){
		super.init(pipType: PipType.Math, id: id)
		
		output = MathOutput()
	}
	
	func updateNumber(newVal: Float){
		output.number = newVal
		updateReliantPips()
	}
	
	func getOutput() -> MathOutput{
		
		for item in inputPipIDs{
			
			let inPip = _mainPipDirectory.getPipByID(item).model
			
			switch inPip.getPipType(){
			case .Accel:
				let castItem: AccelPip! = inPip as? AccelPip
				
				if castItem != nil {
					
				}
			case .Text:
				let castItem: TextPip! = inPip as? TextPip
				
				if castItem != nil {
					
				}
			case .Color:
				let castItem: ColorPip! = inPip as? ColorPip
				
				if castItem != nil {
					
				}
			default:
				
				if let castItem = inPip as? SwitchPip {
					
				}
				
			}
		}
		return output
	}
}