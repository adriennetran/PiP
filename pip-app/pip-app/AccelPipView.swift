//
//  TextPipView.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class AccelPipView: BasePipView {
	
	var accelText: UITextView!
	
	//Required
	required init(coder aDecoder: NSCoder) {
		fatalError("coder initializer not coded")
	}
	
	
	// init: CGPoint -> ?
	// I/O: takse a CGPoint and passes it to super.init as the views position
	//		sets the image of the node, and initializes the textField used for
	//		entry to the model
	
	init (point: CGPoint, id: Int) {
		super.init(point: point, image: UIImage(named: "textPip-image")!, id: id)
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
		
//		textField = UITextField(frame: CGRectMake(75, 75, 315, 45))
//		textField.borderStyle = UITextBorderStyle.RoundedRect
//		textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
//		textField.font = UIFont(name: textField.font!.fontName, size: 24)
//		textField.backgroundColor = UIColor.whiteColor()
//		textField.textColor = UIColor.blackColor()
		self.addSubview(accelText)
		
		pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
		pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
        
        
	}
	
	// ---------------
	//  Accessors
	// ---------------
	
	// OVERRIDE
	override func getModel() -> BasePip {
		return _mainPipDirectory.getPipByID(pipId).model
	}
    
    /*
    lazy var motionManager = CMMotionManager()
    
    // TO DO- MOVE THIS.
    func viewDidLoad(){
//        super.viewDidLoad()
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "I'am a test label"
//        self.view.addSubview(label)
        
        //Get accelerometer data
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    //println("X = \(data.acceleration.x)")
                    //println("Y = \(data.acceleration.y)")
                    //println("Z = \(data.acceleration.z)")
            })
        } else{
            println("accelerometer is not available.")
        }
    }
*/
	
	// ---------------
	//  Accessors
	// ---------------
	
	// textFieldDidChage: UITextField -> nil
	// I/O: takes in a UITextField, field, whose content has just changed.
	// Note: Use this to pass the content of field to the model
	
//	func textFieldDidChange(field: UITextField) {
//		(getModel() as? TextPip)?.updateText(field.text)
//		(getModel() as? TextPip)?.updateReliantPips()
//	}
	
	// updateView: nil -> nil
	// I/O: updates the model and forces the view to reflect it
	
	override func updateView() {
		let output = (getModel() as? AccelPip)?.getOutput()
		accelText.text = output?.text
		accelText.textColor = output?.color
		(getModel() as? AccelPip)?.updateReliantPips()
	}
}