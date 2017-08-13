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
	
	func registerViewController(_ vC: WorkspaceViewController){
		viewController = vC
	}
    
    var viewController2: CameraVC3!
    
    func registerViewController2(_ vC: CameraVC3){
        viewController2 = vC
    }
	
	// -------
	// PIP CREATION
	// -------
	
	// createPipOfType: PipType -> (BasePip, BasePipView)
	// I/O: creates the model and view of the given PipType
	//		and links them together
	
	func createPipOfType(_ pType: PipType){
		
		let screenCenter = viewController.scrollView.center
		let offset = viewController.scrollView.contentOffset
		var createPos = CGPoint(x: screenCenter.x + offset.x, y: screenCenter.y + offset.y)
		createPos = viewController.containerView.convert(createPos, from: viewController.scrollView)
		
		var tuple: (model: BasePip, view: BasePipView)!
		
		switch pType{
			
		case .Accel:
			
			// Create View and Model
			let accelModel: AccelPip = AccelPip(id: lastPipID)
			let accelView: AccelPipView = AccelPipView(point: createPos, id: lastPipID)
			
			// Add tuple to array
			tuple = (model: accelModel, view: accelView)
			
        case .Audio:
            // Create View and Model
            let audioModel: AudioPip = AudioPip(id: lastPipID)
            let audioView: AudioPipView = AudioPipView(point: createPos, id: lastPipID)
            
            // Add tuple to array
            tuple = (model: audioModel, view: audioView)
		
		case .Color:
			
			// Create View and Model
			let colorModel = ColorPip(id: lastPipID)
            lastPipID += 1
			let colorView = ColorPipView(point: createPos, id: lastPipID)
			
			tuple = (model: colorModel, view: colorView)
            
        case .Image:
            // Create View and Model
            let imageModel: ImagePip = ImagePip(id: lastPipID)
            let imageView: ImagePipView = ImagePipView(point: createPos, id: lastPipID)
            
            // Add tuple to array
            tuple = (model: imageModel, view: imageView)
			
		case .Math:
			// Create View and Model
			let mathModel: MathPip = MathPip(id: lastPipID)
			let mathView: MathPipView = MathPipView(point: createPos, id: lastPipID)
			
			tuple = (model: mathModel, view: mathView)
			
		case .Text:
			
			// Create View and Model
			let textModel: TextPip = TextPip(id: lastPipID)
			let textView: TextPipView = TextPipView(point: createPos, id: lastPipID)
			
			tuple = (model: textModel, view: textView)
			
		default: // creates .Switch
			
			// Create View and Model
			let switchModel = SwitchPip(id: lastPipID)
			let switchView = SwitchPipView(point: createPos, id: lastPipID)
			
			tuple = (model: switchModel, view: switchView)
		}
		
		tuple.view.frame.origin = CGPoint(x: tuple.view.frame.origin.x - (tuple.view.frame.width/2), y: tuple.view.frame.origin.y - (tuple.view.frame.height/2))
		
		pipDirectory[lastPipID] = tuple
		
		viewController?.addPipView(tuple.view)
		
		lastPipID += 1
	}
	
	// createPipFromButtonTag: UIButton -> nil
	// I/O: a function usable as a @selector for UIButton.addTarget
	//		allows programmatically created buttons to be used to create Pips
	@objc func createPipFromButtonTag(_ sender: UIButton!){
		createPipOfType(PipType(rawValue: sender.tag)!)
	}
	
	// getImageForPipType: PipType -> UIImage
	// I/O: returns the background image for a given pipType
	//		allow programmatic, and iterative creation of Pips
	//		READ: extra function = shorter code
	func getImageForPipType(_ type: PipType) -> UIImage{
		switch type{
        case .Accel:
            return UIImage(named: "accelerometerPip-image")!
		case .Audio:
			return UIImage(named: "audioPip-image")!
		case .Color:
			return UIImage(named: "colorPip-image")!
        case .Image:
            return UIImage(named: "imagePip-image")!
		case .Math:
			return UIImage(named: "mathPip-image")!
		case .Text:
			return UIImage(named: "textPip-image")!
		default:
			return UIImage(named: "switchPipOn-image")!
		}
	}
	
	func getColorForPipType(_ type: PipType) -> UIColor{
		switch type{
		case .Accel:
			return UIColor(red: (183 / 256), green: (237 / 256), blue: (36 / 256), alpha: 1.0)
		case .Image:
			return UIColor(red: (31 / 256), green: (175 / 256), blue: (255 / 256), alpha: 1.0)
		case .Color:
			return UIColor(red: (244 / 256), green: (105 / 256), blue: (105 / 256), alpha: 1.0)
		case .Text:
			return UIColor(red: (35 / 256), green: (247 / 256), blue: (161 / 256), alpha: 1.0)
		default:
			return UIColor(red: (239 / 256), green: (188 / 256), blue: (63 / 256), alpha: 1.0)
		}
	}
	// ---------------
	//  Deletion
	// ---------------
	
	func deletePip(_ pipID: Int) {
		let pip: (model: BasePip, view: BasePipView) = getPipByID(pipID)
		
		// remove all connections between pip and other pips
		pip.model.pipToBeDestroyed()
        // ^ TO DO: override in ImagePip- call super.pipToBeDestroyed
		
		// remove pip from its superview
		pip.view.removeFromSuperview()
		
		// remove pip from pipDirectory
		pipDirectory[pipID] = nil
	}
	
	func deleteHand(_ hand: HandView) {
		let inPip = hand.inPipID
		let outPip = hand.outPipID
		
		breakConnection(inPip!, outPipID: outPip!)
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// getPipByID: Int -> (BasePip, BasePipView)
	// I/O: given an ID, returns the tuple representing the pip
	
	func getPipByID(_ id: Int) -> (model: BasePip, view: BasePipView){
		return pipDirectory[id]!
	}
	
	func getAllPips() -> [Int: (model: BasePip, view: BasePipView)] {
		return pipDirectory
	}
	
	
	// ---------------
	//  Mutators
	// ---------------
	
	// breakConnection: Int, Int -> nil
	// I/O: breaks a link between two pips
	
	func breakConnection(_ inPipID: Int, outPipID: Int) {
		let inPip: (model: BasePip, view:BasePipView) = pipDirectory[inPipID]!
		let outPip: (model: BasePip, view:BasePipView) = pipDirectory[outPipID]!
		
		inPip.model.removeOutput(outPipID)
		outPip.model.removeInput(inPipID)
		
		if let arm = inPip.view.removeArm(outPipID, isInputArm: false) {
			viewController.removeArmView(arm)
		}
		if let arm2 = outPip.view.removeArm(inPipID, isInputArm: true) {
			viewController.removeArmView(arm2)
		}
		
		outPip.view.updateView()
	}
	
	// updatePip: Int -> nil
	// I/O: called by any Pip that changes on its inputs or outputs
	//		forces a Pip to check its inputs and change accordingly
	
	func updatePip(_ pID: Int){
		let type = getPipByID(pID).model.getPipType()
		switch type{
			//case .Button:
        case .Audio:
            (getPipByID(pID).model as? AudioPip)?.getOutput()
        case .Image:
            (getPipByID(pID).model as? ImagePip)?.getOutput()
            
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
