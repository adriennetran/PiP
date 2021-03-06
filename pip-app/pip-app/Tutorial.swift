//
//  Tutorial.swift
//  pip-app
//
//  Created by Peter Slattery on 5/13/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController {
	
	let image = ["tutorialScreen0.png",
				"tutorialScreen1.png",
				"tutorialScreen2.png",
				"tutorialScreen3.png"]
	
	@IBOutlet var imageView: UIImageView!
	
	var currentImage = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "nextImage:"))
		
		imageView.image = UIImage(named: image[0])
		imageView.userInteractionEnabled = true
	}
	
	func nextImage(sender: UITapGestureRecognizer) {
		currentImage++
		
		if currentImage < image.count {
			imageView.image = UIImage(named: image[currentImage])
		}else{
			//switch back to home screen
			currentImage = 0
			imageView.image = UIImage(named: image[currentImage])
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateInitialViewController() as! UIViewController
			self.presentViewController(vc, animated: true, completion: nil)
		}
	}
	
	
	
}