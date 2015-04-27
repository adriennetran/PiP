//
//  LandingViewController.swift
//  pip-app
//
//  Created by Peter Slattery on 4/26/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class LandingViewController: UIViewController {
	
	@IBOutlet var startButton: UIButton!
	@IBOutlet var tutorialButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		startButton.addTarget(self, action: "startButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		tutorialButton.addTarget(self, action: "tutorialButtonPressed:", forControlEvents: .TouchUpInside)
	}
	
	// BUILTIN - not sure what to use for
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func startButtonPressed(sender: UIButton) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("workspace") as! WorkspaceViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func tutorialButtonPressed(sender: UIButton) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("tutorial") as! UIPageViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
}