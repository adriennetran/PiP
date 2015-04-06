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
	
	init(point: CGPoint) {
		super.init(point: point, image: stateImages[0])
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
		if self.image? == stateImages[0]{
			self.image = stateImages[1]
		}else{
			self.image = stateImages[0]
		}
	}
	
}