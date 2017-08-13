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
		
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TutorialViewController.nextImage(_:))))
		
		imageView.image = UIImage(named: image[0])
		imageView.isUserInteractionEnabled = true
	}
	
	func nextImage(_ sender: UITapGestureRecognizer) {
		currentImage += 1
		
		if currentImage < image.count {
			imageView.image = UIImage(named: image[currentImage])
		}else{
			//switch back to home screen
			currentImage = 0
			imageView.image = UIImage(named: image[currentImage])
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateInitialViewController()! as UIViewController
			self.present(vc, animated: true, completion: nil)
		}
	}
	
	
	
}
