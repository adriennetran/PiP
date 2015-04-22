//
//  ViewController.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIScrollViewDelegate {
    lazy var motionManager = CMMotionManager()
	
	@IBOutlet var scrollView: UIScrollView!
	
	var containerView: UIView!
	var staticScreenElements: [(view: UIView, pos: CGPoint)] = []
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
        
        // get camera data
        print("Camera is ")
        if isCameraAvailable() == false{
            print ("not ")
        }
        println("available")
        
        //Get accelerometer data
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    println("X = \(data.acceleration.x)")
                    println("Y = \(data.acceleration.y)")
                    println("Z = \(data.acceleration.z)")
                }
            )
        } else{
            println("accelerometer is not available.")
        }
        
        
		_mainPipDirectory.registerViewController(self)
		
		/* -------------------
			Scroll View Setup
		   ------------------- */
	
		containerView = UIView(frame: CGRectMake(0, 0, 1440, 2880))
		scrollView.addSubview(containerView)
		
		var backgroundView = UIView(frame: CGRectMake(0, 0, 1440, 2880))
		backgroundView.backgroundColor = UIColor.whiteColor()
		containerView.addSubview(backgroundView)
		
		scrollView.contentSize = containerView.bounds.size
		
		/*  -------------------
			 Menu's Setup
			------------------- */
		
		// Add Menus
		// first so that they are under buttons
		let pipMenuPos = CGPoint(x: 0, y: 0)
		var pipMenu = CanvasMenuView.makePipMenu(pipMenuPos)
		let pipMenuTuple: (view: UIView, pos: CGPoint) = (view: pipMenu, pos: pipMenuPos)
		staticScreenElements.append(pipMenuTuple)
		
		
		scrollView.addSubview(pipMenu)
		
		/*  -------------------
			 Scroll View Setup
			------------------- */
		
		// Add Menu Buttons
		// second so that they are on top of menus
		let pipMenuBtnPos = CGPoint(x: 0, y: 0)
		var pipMenuButton = UIButton(frame: CGRectMake(pipMenuBtnPos.x, pipMenuBtnPos.y, 50, 50))
		pipMenuButton.backgroundColor = UIColor.redColor()
		pipMenuButton.addTarget(pipMenu, action: "toggleActive:", forControlEvents: .TouchUpInside)
		let pipTuple: (view: UIView, pos: CGPoint) = (view: pipMenuButton, pos: pipMenuBtnPos)
		staticScreenElements.append(pipTuple)
		
		let userDataBtnPos = CGPoint(x: UIScreen.mainScreen().bounds.width - 50, y: 0)
		var userDataButton = UIButton(frame: CGRectMake(userDataBtnPos.x, userDataBtnPos.y, 50, 50))
		userDataButton.backgroundColor = UIColor.yellowColor()
		userDataButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let userTuple: (view: UIView, pos: CGPoint) = (view: userDataButton, pos: userDataBtnPos)
		staticScreenElements.append(userTuple)
		
		let networkBtnPos = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height - 50)
		var networkButton = UIButton(frame: CGRectMake(networkBtnPos.x, networkBtnPos.y, 50, 50))
		networkButton.backgroundColor = UIColor.greenColor()
		networkButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let netTuple: (view: UIView, pos: CGPoint) = (view: networkButton, pos: networkBtnPos)
		staticScreenElements.append(netTuple)
		
		let settingsBtnPos = CGPoint(x: UIScreen.mainScreen().bounds.width - 50,
			y: UIScreen.mainScreen().bounds.height - 50)
		var settingsButton = UIButton(frame: CGRectMake(settingsBtnPos.x, settingsBtnPos.y, 50, 50))
		settingsButton.backgroundColor = UIColor.purpleColor()
		settingsButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let settingsTuple: (view: UIView, pos: CGPoint) = (view: settingsButton, settingsBtnPos)
		staticScreenElements.append(settingsTuple)
		
		scrollView.addSubview(pipMenuButton)
		scrollView.addSubview(userDataButton)
		scrollView.addSubview(networkButton)
		scrollView.addSubview(settingsButton)
		
		
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
	
	// touchesBegan: 
	// I/O: used to exit/cancel any active screen elements
	//		active buttons, open menus etc.
//	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//		println("!")
//		for ele in staticScreenElements {
//			if var menu = (ele.view as? CanvasMenuView){
//				menu.toggleActive()
//				println("!")
//			}
//		}
//        return
//	}
	
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
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let offset: CGPoint = scrollView.contentOffset
		
		for ele in staticScreenElements {
			if var menuView = (ele.view as? CanvasMenuView) {
				var basePos: CGPoint!
				if menuView.viewIsActive {
					basePos = menuView.baseLocation
				} else {
					basePos = menuView.offsetLocation
				}
				
				menuView.frame = CGRectMake(basePos.x + offset.x, basePos.y + offset.y,
					ele.view.frame.width, ele.view.frame.height)
			} else {
				ele.view.frame = CGRectMake(ele.pos.x + offset.x, ele.pos.y + offset.y, ele.view.frame.width, ele.view.frame.height)
			}
		}
	}
	
	func addPipView(pipView: BasePipView) {
		containerView.addSubview(pipView)
	}
	
	func menuButtonPressed(sender: UIButton!){
		println("no menu to toggle yet")
	}
}

