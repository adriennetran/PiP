//
//  ViewController.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet var scrollView: UIScrollView!
	
	//Array of Pips which are currently in the workspace
	var activePips: [(model: BasePip, view: BasePipView)] = []
	var pipDirectory: [Int: (model: BasePip, view: BasePipView)]!
	
	var lastPipID: Int = 0
	
	var containerView: UIView!
	
	var activeOutputPipID: Int? = nil
	var activeInputPipID: Int? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
		/* -------------------
			Scroll View Setup
		   ------------------- */
		
		containerView = UIView(frame: CGRectMake(0, 0, 1440, 1440))
		scrollView.addSubview(containerView)
		
		var backgroundView = UIView(frame: CGRectMake(0, 0, 1440, 1440))
		backgroundView.backgroundColor = UIColor.whiteColor()
		containerView.addSubview(backgroundView)
		
		scrollView.contentSize = containerView.bounds.size
		
		
		/* ----------------------
			PIP DATA STRUCTURES
		   ---------------------- */
		
		pipDirectory = [:]
		
		/* ------------
			TEST PIPS
		   ------------ */
		
		createPipOfType(PipType.Text)
		createPipOfType(PipType.Switch)
		
		/* ------------------------
			Tap Gesture Recognizer
		   ------------------------ */
		
		self.view.userInteractionEnabled = true;
		scrollView.userInteractionEnabled = true;
		
		var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
		doubleTapRecognizer.numberOfTapsRequired = 2
		doubleTapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(doubleTapRecognizer)
		
		let scrollViewFrame: CGRect = scrollView.frame
		let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
		let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
		let minScale: CGFloat = min(scaleWidth, scaleHeight)
		
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 1.5
		scrollView.zoomScale = 0.5
	}

	
	// BUILTIN - not sure what to use for
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// createPipOfType: PipType -> (BasePip, BasePipView)
	// I/O: creates the model and view of the given PipType
	//		and links them together
	
	func createPipOfType(pType: PipType){
		switch pType{
			
		case .Text:
			
			// Create View and Model
			var textModel: TextPip = TextPip(vc: self, id: lastPipID)
			var textView: TextPipView = TextPipView(point: CGPoint(x: 25, y: 25), vC: self)
			
			// Link view and Model
			containerView.addSubview(textView)
			textView.setTextModel(textModel)
			
			// Add Tuple to array
			var tuple: (model: BasePip, view: BasePipView) = (model: textModel, view: textView)
			pipDirectory[lastPipID] = tuple
			
		case .Color:
			
			// Create View and Model
			var colorModel = ColorPip(vc: self, id: ++lastPipID)
			var colorView = ColorPipView(point: CGPoint(x: 25, y: 25), vC: self)
			
			// Link view and Model
			containerView.addSubview(colorView)
			colorView.setColorModel(colorModel)
			
			// Add Tuple to array
			var tuple: (model: BasePip, view: BasePipView) = (model: colorModel, view: colorView)
			pipDirectory[lastPipID] = tuple
			
		default: // creates .Switch
			
			// Create View and Model
			var switchModel = SwitchPip(vc: self, id: lastPipID)
			var switchView = SwitchPipView(point: CGPoint(x: 25, y: 25), vC: self)
			
			// Link view and Model
			containerView.addSubview(switchView)
			switchView.setSwitchModel(switchModel)
			
			// Add Tuple to Array
			var tuple: (model: BasePip, view: BasePipView) = (model: switchModel, view: switchView)
			pipDirectory[lastPipID] = tuple
		}
		
		lastPipID++
	}
	
	
	// scrollViewDoubleTapped: UITapGestureRecognizer -> nil
	// I/O: called when the background is double tapped
	//		zooms the view in by 1.5%
	
	func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
		let pointInView = recognizer.locationInView(containerView)
		
		var newZoomScale = min((scrollView.zoomScale * 1.5), scrollView.maximumZoomScale)
		
		let scrollViewSize = scrollView.bounds.size
		let w = scrollViewSize.width / newZoomScale
		let h = scrollViewSize.height / newZoomScale
		let x = pointInView.x - (w / 2.0)
		let y = pointInView.y - (h / 2.0)
		
		let rectToZoomTo = CGRectMake(x, y, w, h)
		
		scrollView.zoomToRect(rectToZoomTo, animated: true)
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return containerView
	}
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		return
	}
	
	
	// getPipByID: Int -> (BasePip, BasePipView)
	// I/O: given an ID, returns the tuple representing the pip
	
	func getPipByID(id: Int) -> (model: BasePip, view: BasePipView){
		return pipDirectory[id]!
	}
	
	
	// setActiveOutputPip: BasePipView -> nil
	// I/O: called when a BasePipView object's pipOutputView is tapped
	//		sets activeOutputPip, and, if activeInputPip has a value
	//		conects the two nodes
	
	func setActiveOutputPip(pip: BasePipView){
		activeOutputPipID = pip.getModel().getPipID()
		println("1")
		
		if activeInputPipID != nil && activeInputPipID != activeOutputPipID{
			
			let out: (model: BasePip, view: BasePipView) = pipDirectory[activeOutputPipID!]!
			let input: (model: BasePip, view: BasePipView) = pipDirectory[activeInputPipID!]!
			
			out.model.setOutput(activeInputPipID!)
			input.model.setInput(activeOutputPipID!)
			
			pipDirectory[activeOutputPipID!]! = out
			pipDirectory[activeInputPipID!]! = input
			
			activeOutputPipID = nil
			activeInputPipID = nil
			
			input.view.updatePip()
			println("!");
		}
	}
	
	
	// setActiveOutputPip: BasePipView -> nil
	// I/O: called when a BasePipView object's pipInputView is tapped
	//		sets activeInputPip, and, if activeOutputPip has a value
	//		conects the two nodes
	
	func setActiveInputPip(pip: BasePipView){
		activeInputPipID = pip.getModel().getPipID()
		println("2")
		if activeOutputPipID != nil && activeInputPipID != activeOutputPipID{
			
			let out: (model: BasePip, view: BasePipView) = pipDirectory[activeOutputPipID!]!
			let input: (model: BasePip, view: BasePipView) = pipDirectory[activeInputPipID!]!
			
			out.model.setOutput(activeInputPipID!)
			input.model.setInput(activeOutputPipID!)
			
			pipDirectory[activeOutputPipID!]! = out
			pipDirectory[activeInputPipID!]! = input
			
			activeOutputPipID = nil
			activeInputPipID = nil
			
			input.view.updatePip()
			
			println("@")
		}
	}
}

