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
	var activePips: [BasePipView] = []
	var containerView: UIView!
	
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
		
		
		/* ------------
			TEST PIPS
		   ------------ */
		
		var testSwitchPip = SwitchPipView(point: CGPointMake(75, 75))
		var testTextPip = TextPipView(point: CGPointMake(100, 100))
		
		containerView.addSubview(testSwitchPip)
		containerView.addSubview(testTextPip)
		
		activePips.append(testSwitchPip)
		activePips.append(testTextPip)
		
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
	
	
	// scrollViewDoubleTapped: UITapGestureRecognizer -> nil
	// I/O: 
	
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
}

