//
//  SwitchPipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class SwitchPipView: BasePipView{
	
	let stateImages: [UIImage] = [UIImage(named: "switchPipOn-image")!, UIImage(named: "switchPipOff-image")!]
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	
	// init: CGPoint -> nil
	// I/O: takes a point which is passed, along with the Pip's image
	//		to super.init. 
	// TODO: gets initial state on creation from Model
	
	init(point: CGPoint, id: Int) {
		super.init(point: point, image: stateImages[0], id: id)
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
		
		pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
		pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}
	
	
	// onTouchesEnded: NSSet, UIEvent -> nil
	// I/O: called when a touch ends over this view. Triggers a state change of the button
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		buttonPressed()
	}
	
	
	// buttonPressed: nil -> nil
	// I/O: tells the model to change state. Updates image to reflect that state.
	// -------
	// TODO: get state from model. Don't assume
	
	func buttonPressed() {

		if let v = (getModel() as? SwitchPip)?.switchStateChange(){
			if v {
				self.image? = stateImages[0]
			}else{
				self.image? = stateImages[1]
			}
		}
	}
	
}