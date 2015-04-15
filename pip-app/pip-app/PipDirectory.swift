//
//  PipDirectory.swift
//  pip-app
//
//  Created by Peter Slattery on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

// SINGLETON - not required, but don't instantiate this anywhere else

var _mainPipDirectory: PipDirectory = PipDirectory()

class PipDirectory{
	
	var pipDirectory: [Int: (model: BasePip, view: BasePipView)]!
	
	var lastPipID: Int = 0
	
	var viewController: ViewController?
	
	var activeInputPipID, activeOutputPipID: Int!
	
	init() {
		pipDirectory = [:]
	}
	
	func registerViewController(vC: ViewController){
		viewController = vC
	}
	
	// -------
	// PIP CREATION
	// -------
	
	// createPipOfType: PipType -> (BasePip, BasePipView)
	// I/O: creates the model and view of the given PipType
	//		and links them together
	
	func createPipOfType(pType: PipType){
		switch pType{
			
		case .Text:
			
			// Create View and Model
			var textModel: TextPip = TextPip(id: lastPipID)
			var textView: TextPipView = TextPipView(point: CGPoint(x: 25, y: 150 + 150 * lastPipID), id: lastPipID)
			
			// Link view and Model
			viewController?.addPipView(textView)
			
			// Add Tuple to array
			var tuple: (model: BasePip, view: BasePipView) = (model: textModel, view: textView)
			pipDirectory[lastPipID] = tuple
			
		case .Color:
			
			// Create View and Model
			var colorModel = ColorPip(id: ++lastPipID)
			var colorView = ColorPipView(point: CGPoint(x: 25, y: 150 + 150 * lastPipID), id: lastPipID)
			
			// Link view and Model
			viewController?.addPipView(colorView)
			
			// Add Tuple to array
			var tuple: (model: BasePip, view: BasePipView) = (model: colorModel, view: colorView)
			pipDirectory[lastPipID] = tuple
			
		default: // creates .Switch
			
			// Create View and Model
			var switchModel = SwitchPip(id: lastPipID)
			var switchView = SwitchPipView(point: CGPoint(x: 25, y: 150 + 150 * lastPipID), id: lastPipID)
			
			// Link view and Model
			viewController?.addPipView(switchView)
			
			// Add Tuple to Array
			var tuple: (model: BasePip, view: BasePipView) = (model: switchModel, view: switchView)
			pipDirectory[lastPipID] = tuple
		}
		
		lastPipID++
	}
	
	// createPipFromButtonTag: UIButton -> nil
	// I/O: a function usable as a @selector for UIButton.addTarget
	//		allows programmatically created buttons to be used to create Pips
	@objc func createPipFromButtonTag(sender: UIButton!){
		createPipOfType(PipType(rawValue: sender.tag)!)
	}
	
	// getImageForPipType: PipType -> UIImage
	// I/O: returns the background image for a given pipType
	//		allow programmatic, and iterative creation of Pips
	//		READ: extra function = shorter code
	func getImageForPipType(type: PipType) -> UIImage{
		switch type{
		case .Color:
			return UIImage(named: "colorPip-image")!
		case .Text:
			return UIImage(named: "textPip-image")!
		default:
			return UIImage(named: "switchPipOn-image")!
		}
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// getPipByID: Int -> (BasePip, BasePipView)
	// I/O: given an ID, returns the tuple representing the pip
	
	func getPipByID(id: Int) -> (model: BasePip, view: BasePipView){
		return pipDirectory[id]!
	}
	
	
	// ---------------
	//  Mutators
	// ---------------
	
	// setActiveOutputPip: BasePipView -> nil
	// I/O: called when a BasePipView object's pipOutputView is tapped
	//		sets activeOutputPip, and, if activeInputPip has a value
	//		conects the two nodes
	
	func setActiveOutputPip(pipID: Int){
		activeOutputPipID = pipID
		
		if activeInputPipID != nil && activeInputPipID != activeOutputPipID{
			
			let out: (model: BasePip, view: BasePipView) = pipDirectory[activeOutputPipID!]!
			let input: (model: BasePip, view: BasePipView) = pipDirectory[activeInputPipID!]!
			
			out.model.setOutput(activeInputPipID!)
			input.model.setInput(activeOutputPipID!)
			
			pipDirectory[activeOutputPipID!]! = out
			pipDirectory[activeInputPipID!]! = input
			
			activeOutputPipID = nil
			activeInputPipID = nil
			
			input.view.updateView()
		}
	}
	
	
	// setActiveOutputPip: BasePipView -> nil
	// I/O: called when a BasePipView object's pipInputView is tapped
	//		sets activeInputPip, and, if activeOutputPip has a value
	//		conects the two nodes
	
	func setActiveInputPip(pipID: Int){
		activeInputPipID = pipID
		
		if activeOutputPipID != nil && activeInputPipID != activeOutputPipID{
			
			let out: (model: BasePip, view: BasePipView) = pipDirectory[activeOutputPipID!]!
			let input: (model: BasePip, view: BasePipView) = pipDirectory[activeInputPipID!]!
			
			out.model.setOutput(activeInputPipID!)
			input.model.setInput(activeOutputPipID!)
			
			pipDirectory[activeOutputPipID!]! = out
			pipDirectory[activeInputPipID!]! = input
			
			activeOutputPipID = nil
			activeInputPipID = nil
			
			input.view.updateView()
		}
	}
	
	// clearActiveInOut: nil -> nil
	// I/O: called when the user taps the canvas, sets both activePip variables to nil
	
	func clearActiveInOut() {
		activeInputPipID = nil
		activeOutputPipID = nil
	}
	
	// updatePip: Int -> nil
	// I/O: called by any Pip that changes on its inputs or outputs
	//		forces a Pip to check its inputs and change accordingly
	
	func updatePip(pID: Int){
		let type = getPipByID(pID).model.getPipType()
		switch type{
			//case .Button:
			
		case .Color:
			(getPipByID(pID).model as? ColorPip)?.getOutput()
		case .Text:
			(getPipByID(pID).model as? TextPip)?.getOutput()
		default:	//defaults to switch
			(getPipByID(pID).model as? SwitchPip)?.getOutput()
		}
		
		getPipByID(pID).view.updateView()
	}
}