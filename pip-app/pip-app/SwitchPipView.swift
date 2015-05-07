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

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buttonPressed:"))
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}

	
	// buttonPressed: nil -> nil
	// I/O: tells the model to change state. Updates image to reflect that state.
	
	func buttonPressed(sender: UITapGestureRecognizer) {
        println("button pressed! switch pip")
		if let v = (getModel() as? SwitchPip)?.switchStateChange(){
			if v.getState() {
				self.image? = stateImages[0]
			}else{
				self.image? = stateImages[1]
			}
		}
	}
	
	// updateView: nil -> nil
	// I/O: gets the model associated with the instance of SwitchPipView
	//		updates the view to match, and calls model.updateReliantPips
	
	override func updateView() {
		if var model = (_mainPipDirectory.getPipByID(pipId).model as? SwitchPip){
			if model.getOutput().getState(){
				self.image? = stateImages[0]
			}else{
				self.image? = stateImages[1]
			}
		}
		(getModel() as? SwitchPip)?.updateReliantPips()
	}
	
}