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
		
		startButton.addTarget(self, action: #selector(LandingViewController.startButtonPressed(_:)), for: UIControlEvents.touchUpInside)
		tutorialButton.addTarget(self, action: #selector(LandingViewController.tutorialButtonPressed(_:)), for: .touchUpInside)
	}
	
	// BUILTIN - not sure what to use for
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func startButtonPressed(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "workspace") as! WorkspaceViewController
		self.present(vc, animated: true, completion: nil)
	}
	
	func tutorialButtonPressed(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "tutorialView") 
		self.present(vc, animated: true, completion: nil)
	}
}
