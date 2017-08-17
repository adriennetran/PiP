//
//  SwitchPip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class SwitchOutput: BasePipOutput{
	var state: Bool = false;
	
	override var description: String{
		return state.description
	}
	
	func setTrue(){ state = true; }
	func setFalse(){ state = false; }
	func setState(_ newState : Bool){
		state = newState;
	}
	func getState() -> Bool { return state; }
}

class SwitchPip: BasePip {
	
	fileprivate var output: SwitchOutput = SwitchOutput();
	
	init(id: Int){
		super.init(pipType: PipType.Switch, id: id)
	}
	
	func switchStateChange() -> SwitchOutput{
		output.setState(!output.getState());
		getOutput()
		updateReliantPips()
		return output
	}
	
	func getOutput() -> SwitchOutput{
		
		for item in inputPipIDs {
			let inPip = _mainPipDirectory.getPipByID(item).model
			
			switch inPip.getPipType(){
			case .Text:
				let castItem: TextPip! = inPip as? TextPip
				
				if castItem != nil{
					if castItem.getOutput().getText() != "" {
						output.setTrue()
					}else{
						output.setFalse()
					}
				}
			case .Color:
				let castItem: ColorPip! = inPip as? ColorPip
				
				if castItem != nil{
					var a: CGFloat = 0.0
					var b: CGFloat = 0.0
					var value: CGFloat = 0.0
					var d: CGFloat = 0.0
					castItem.getOutput().getColor().getHue(&a, saturation: &b, brightness: &value, alpha: &d)
					
					if a >= 0.5 {
						output.setTrue()
					}else{
						output.setFalse()
					}
					
				}
				
			default:	// Switch Pip
				let castItem: SwitchPip! = inPip as? SwitchPip
				
				if castItem != nil{
					output.setState(output.getState() && castItem.getOutput().getState())
				}
			}
		}
		
		return output
	}
	
}
