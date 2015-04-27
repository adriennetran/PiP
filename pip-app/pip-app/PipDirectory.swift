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
	
	var viewController: WorkspaceViewController!
	
	var activeInputPipID, activeOutputPipID: Int!
	
	init() {
		pipDirectory = [:]
	}
	
	func registerViewController(vC: WorkspaceViewController){
		viewController = vC
	}
    
    var viewController2: CameraVC3!
    
    func registerViewController2(vC: CameraVC3){
        viewController2 = vC
    }
	
	// -------
	// PIP CREATION
	// -------
	
	// createPipOfType: PipType -> (BasePip, BasePipView)
	// I/O: creates the model and view of the given PipType
	//		and links them together
	
	func createPipOfType(pType: PipType){
		
		let screenCenter = viewController.scrollView.center
		let offset = viewController.scrollView.contentOffset
		var createPos = CGPoint(x: screenCenter.x + offset.x, y: screenCenter.y + offset.y)
		createPos = viewController.containerView.convertPoint(createPos, fromCoordinateSpace: viewController.scrollView)
		
		var tuple: (model: BasePip, view: BasePipView)!
		
		switch pType{
            
        case .Image:
            
            // Create View and Model
            var imageModel: ImagePip = ImagePip(id: lastPipID)
            var imageView: ImagePipView = ImagePipView(point: CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2), id: lastPipID)
            
            // Add tuple to array
            tuple = (model: imageModel, view: imageView)
            
        case .Accel:
            
            // Create View and Model
            var accelModel: AccelPip = AccelPip(id: lastPipID)
            var accelView: AccelPipView = AccelPipView(point: CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2), id: lastPipID)
            
            // Add tuple to array
            tuple = (model: accelModel, view: accelView)
            
			
		case .Text:
			
			// Create View and Model
			var textModel: TextPip = TextPip(id: lastPipID)
			var textView: TextPipView = TextPipView(point: createPos, id: lastPipID)
			
			tuple = (model: textModel, view: textView)
			
		case .Color:
			
			// Create View and Model
			var colorModel = ColorPip(id: ++lastPipID)
			var colorView = ColorPipView(point: createPos, id: lastPipID)
			
			tuple = (model: colorModel, view: colorView)
			
		default: // creates .Switch
			
			// Create View and Model
			var switchModel = SwitchPip(id: lastPipID)
			var switchView = SwitchPipView(point: createPos, id: lastPipID)
			
			tuple = (model: switchModel, view: switchView)
		}
		
		tuple.view.frame.origin = CGPoint(x: tuple.view.frame.origin.x - (tuple.view.frame.width/2), y: tuple.view.frame.origin.y - (tuple.view.frame.height/2))
		
		pipDirectory[lastPipID] = tuple
		
		viewController?.addPipView(tuple.view)
		
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
        case .Accel:
            return UIImage(named: "mathPip-image")!
        case .Image:
            return UIImage(named: "imagePip-image")!
		case .Color:
			return UIImage(named: "colorPip-image")!
		case .Text:
			return UIImage(named: "textPip-image")!
		default:
			return UIImage(named: "switchPipOn-image")!
		}
	}
	
	// ---------------
	//  Deletion
	// ---------------
	
	func deletePip(pipID: Int) {
		var pip: (model: BasePip, view: BasePipView) = getPipByID(pipID)
		
		// remove all connections between pip and other pips
		pip.model.pipToBeDestroyed()
		
		// remove pip from its superview
		pip.view.removeFromSuperview()
		
		// remove pip from pipDirectory
		pipDirectory[pipID] = nil
	}
	
	func deleteHand(hand: HandView) {
		var inPip = hand.inPipID
		var outPip = hand.outPipID
		
		breakConnection(inPip, outPipID: outPip)
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// getPipByID: Int -> (BasePip, BasePipView)
	// I/O: given an ID, returns the tuple representing the pip
	
	func getPipByID(id: Int) -> (model: BasePip, view: BasePipView){
		return pipDirectory[id]!
	}
	
	func getAllPips() -> [Int: (model: BasePip, view: BasePipView)] {
		return pipDirectory
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
			
			makeConnection(activeInputPipID!, outPipID: activeOutputPipID)
		}
	}
	
	
	// setActiveOutputPip: BasePipView -> nil
	// I/O: called when a BasePipView object's pipInputView is tapped
	//		sets activeInputPip, and, if activeOutputPip has a value
	//		conects the two nodes
	
	func setActiveInputPip(pipID: Int){
		activeInputPipID = pipID
		
		if activeOutputPipID != nil && activeInputPipID != activeOutputPipID{
			
			makeConnection(activeInputPipID!, outPipID: activeOutputPipID!)
		}
	}
	
	// clearActiveInOut: nil -> nil
	// I/O: called when the user taps the canvas, sets both activePip variables to nil
	
	func clearActiveInOut() {
		activeInputPipID = nil
		activeOutputPipID = nil
	}
	
	// makeConnection: Int, Int -> nil
	// I/O: makes a link from inPip to outPip
	
	func makeConnection(inPipID: Int, outPipID: Int) {
		let inPip: (model: BasePip, view:BasePipView) = pipDirectory[inPipID]!
		let outPip: (model: BasePip, view:BasePipView) = pipDirectory[outPipID]!
		
		inPip.model.setOutput(outPipID)
		outPip.model.setInput(inPipID)
		
		pipDirectory[inPipID]! = inPip
		pipDirectory[outPipID]! = outPip
		
		activeOutputPipID = nil
		activeInputPipID = nil
		
		outPip.view.updateView()
		
		// Arm Construction
		
		var inPipArmLoc: CGPoint = inPip.view.getArmPosForInput(viewController.getContainerView())
		var outPipArmLoc: CGPoint = outPip.view.getArmPosForOutput(viewController.getContainerView())
		
		var avgPos: CGPoint = CGPoint(x: (inPip.view.center.x + outPip.view.center.x) / 2, y: (inPip.view.center.y + outPip.view.center.y) / 2)
		
		var newHand: HandView = HandView(pos: avgPos, inPipID: inPipID, outPipID: outPipID)
		
		var inArm: ArmView = ArmView(start: inPipArmLoc, end: newHand.center, pipFromID: inPipID)
		var outArm: ArmView = ArmView(start: outPipArmLoc, end: newHand.center, pipFromID: outPipID)
		
		inArm.setHand(newHand)
		outArm.setHand(newHand)
		
		viewController.addHandView(newHand)
		viewController.addArmView(inArm)
		viewController.addArmView(outArm)
		
		inPip.view.addArm(inArm, toPipID: outPipID, isInputArm: true)
		outPip.view.addArm(outArm, toPipID: inPipID, isInputArm: false)
		
		newHand.setArms(inArm, armB: outArm)
	}
	
	// breakConnection: Int, Int -> nil
	// I/O: breaks a link between two pips
	
	func breakConnection(inPipID: Int, outPipID: Int) {
		let inPip: (model: BasePip, view:BasePipView) = pipDirectory[inPipID]!
		let outPip: (model: BasePip, view:BasePipView) = pipDirectory[outPipID]!
		
		inPip.model.removeOutput(outPipID)
		outPip.model.removeInput(inPipID)
		
		let inArm: ArmView = inPip.view.removeArm(outPipID, isInputArm: true)
		let outArm: ArmView = outPip.view.removeArm(inPipID, isInputArm: false)
		
		inArm.handView.removeFromSuperview()
		inArm.handView = nil
		outArm.handView = nil
		
		viewController.removeArmView(inArm)
		viewController.removeArmView(outArm)
		
		outPip.view.updateView()
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