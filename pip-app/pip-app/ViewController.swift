//
//  ViewController.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	//Array of Pips which are currently in the workspace
	var activePips: [BasePipView] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		var testPipView = TextPipView(point: CGPointMake(25, 25))
		
		self.view.addSubview(testPipView)
		activePips.append(testPipView)
		
		self.view.userInteractionEnabled = true;
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

