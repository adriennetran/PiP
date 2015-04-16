//
//  SwitchPip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class SwitchPip: BasePip {
	
	private var output = true
	
	init(id: Int){
		super.init(pipType: .Switch, id: id)
	}
	
	func switchStateChange() -> Bool{
		output = !output
		getOutput()
		updateReliantPips()
		return output
	}
	
	func getOutput() -> Bool{
		
		for item in inputPipIDs {
			let inPip = _mainPipDirectory.getPipByID(item).model
			
			switch inPip.getPipType(){
			case .Text:
				let castItem: TextPip! = inPip as? TextPip
				
				if castItem != nil{
					if castItem.getOutput().getText() != "" {
						output = true
					}else{
						output = false
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
						output = true
					}else{
						output = false
					}
					
				}
				
			default:	// Switch Pip
				let castItem: SwitchPip! = inPip as? SwitchPip
				
				if castItem != nil{
					output = output && castItem.getOutput()
				}
			}
		}
		
		return output
	}
	
}