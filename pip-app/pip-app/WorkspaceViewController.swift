//
//  WorkspaceViewController.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import UIKit
import CoreMotion
import MobileCoreServices
//import Photos


class WorkspaceViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    lazy var motionManager = CMMotionManager()

	
	@IBOutlet var scrollView: UIScrollView!
	var containerView: UIView!
	var staticScreenElements: [(view: UIView, pos: CGPoint)] = []
	
	var pipViewBeingDragged: BasePipView!
	var armViewBeingCreated: ArmView!

    
    // this gets called on ViewController.addPipView, if the pipType is an ImagePip
    
// image pip view
//    func didTapImageView(tap: UITapGestureRecognizer){
//        println("inside didtapimageview")
//        capture(tap)
//        
//        // Presents Camera View Controller
//        // let captureDetails = storyboard!.instantiateViewControllerWithIdentifier("CameraVC")! as? CameraVC3
//        // presentViewController(captureDetails!, animated: true, completion: nil)
//    }
//    
    func capture(tap: UITapGestureRecognizer) {
        
        println("capture")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            println("Button capture")
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = false
            
            println("post button capture")
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
//    func textFieldShouldReturn(userText: UITextField!) -> Bool {
//        self.view.endEditing(true)
//        userText.resignFirstResponder()
//        return true;
//    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            println("curipview")
            println(curPipView)
            var curPipView2 = curPipView as? ImagePipView
            
            // to do: align photo with image pip
            curPipView2!.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage

            println("black layer")
            
            // black layer
            curPipView2!.blackLayer.frame = CGRectMake(0, 0, curPipView2!.photoImageView.bounds.width, curPipView2!.photoImageView.bounds.height)
            curPipView2!.blackLayer.bounds = curPipView2!.photoImageView.layer.bounds
            curPipView2!.blackLayer.backgroundColor = UIColor.blackColor().CGColor
            curPipView2!.blackLayer.opacity = 0.0
            
            curPipView2!.colorLayer.frame = CGRectMake(0, 0, curPipView2!.photoImageView.bounds.width, curPipView2!.photoImageView.bounds.height)
            curPipView2!.colorLayer.bounds = curPipView2!.photoImageView.layer.bounds
//            curPipView2!.colorLayer.backgroundColor = UIColor.blackColor().CGColor
//            curPipView2!.colorLayer.opacity = 0.0
            
            curPipView2!.photoImageView.layer.addSublayer(curPipView2!.colorLayer)
            curPipView2!.photoImageView.layer.addSublayer(curPipView2!.blackLayer)
            
            var curModel = curPipView2!.getModel() as? ImagePip
            
            
            if (curModel?.output.accelStatus == true){
                println("GET ACCEL IS TRUE")
                var blurredImage = curPipView2!.applyBlurEffect(curPipView2!.photoImageView.image!)
                curPipView2!.photoImageView.image = blurredImage
            }
            
            println("changed pip view black")
            self.dismissViewControllerAnimated(false, completion: nil)
    }

    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia((kUTTypeImage as? String)!, sourceType: .Camera)
    }
    func cameraSupportsMedia(mediaType: String,
        sourceType: UIImagePickerControllerSourceType) -> Bool{

            let availableMediaTypes =
            UIImagePickerController.availableMediaTypesForSourceType(sourceType) as!
                [String]?
    
            if let types = availableMediaTypes{
                for type in types{
                    if type == mediaType{
                        return true
                    }
                }
            }
        
            return false
    }


	var trashCanButton: UIView!
    
    var beenHereBefore = false
    var controller: UIImagePickerController?
    
//    func viewDidAppear_Camera(animated: Bool) {
//        println("inside viewToAppear")
//        super.viewDidAppear(animated)
//        
//        if beenHereBefore{
//            /* Only display the picker once as the viewDidAppear: method gets
//            called whenever the view of our view controller gets displayed */
//            return;
//        } else {
//            beenHereBefore = true
//        }
//        
//        if isCameraAvailable() && doesCameraSupportTakingPhotos(){
//            
//            controller = UIImagePickerController()
//            
//            if let theController = controller{
//                theController.sourceType = .Camera
//                
//                theController.mediaTypes = [kUTTypeImage as! String]
//                
//                theController.allowsEditing = true
//                theController.delegate = self
//                
//                presentViewController(theController, animated: true, completion: nil)
//            }
//            
//        } else {
//            println("Camera is not available")
//        }
//        
//    }


//	@IBOutlet weak var userText: UITextField!
    
	override func viewDidLoad() {
        println("hello")
		super.viewDidLoad()
//        self.userText.delegate = self

        
        // get camera data
        print("Camera is ")
        if isCameraAvailable() == false{
            print ("not ")
        }
        println("available")
    
        if doesCameraSupportTakingPhotos(){
            println("The camera supports taking photos")
        } else{
            println("The camera does not support taking photos")
        }
        
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
        
        
		_mainPipDirectory.registerViewController(self)
		
		/* -------------------
			Scroll View Setup
		   ------------------- */
	
		containerView = UIView(frame: CGRectMake(0, 0, 1440, 2880))
		scrollView.addSubview(containerView)
		containerView.setNeedsDisplay()
		
		scrollView.contentSize = containerView.bounds.size
		
		scrollView.backgroundColor = UIColor.whiteColor()
		
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
		
		// Pip Menu Button
		
		let pipMenuBtnPos = CGPoint(x: 0, y: 0)
		var pipMenuButton = UIButton(frame: CGRectMake(pipMenuBtnPos.x, pipMenuBtnPos.y, 120, 120))
		pipMenuButton.setImage(UIImage(named: "pipMenuButton"), forState: UIControlState.Normal)
		pipMenuButton.addTarget(pipMenu, action: "toggleActive:", forControlEvents: .TouchUpInside)
		pipMenuButton.addTarget(self, action: "setMenuButtonsInactive:", forControlEvents: .TouchUpInside)
		let pipTuple: (view: UIView, pos: CGPoint) = (view: pipMenuButton, pos: pipMenuBtnPos)
		staticScreenElements.append(pipTuple)
		
		// User Data Button
		
		let userDataBtnPos = CGPoint(x: UIScreen.mainScreen().bounds.width - 120, y: 0)
		var userDataButton = UIButton(frame: CGRectMake(userDataBtnPos.x, userDataBtnPos.y, 120, 120))
		userDataButton.setImage(UIImage(named: "dataButton"), forState: .Normal)
		userDataButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let userTuple: (view: UIView, pos: CGPoint) = (view: userDataButton, pos: userDataBtnPos)
		staticScreenElements.append(userTuple)
		
		// Network Button
		
		let networkBtnPos = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height - 120)
		var networkButton = UIButton(frame: CGRectMake(networkBtnPos.x, networkBtnPos.y, 120, 120))
		networkButton.setImage(UIImage(named: "networkButton"), forState: .Normal)
		networkButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let netTuple: (view: UIView, pos: CGPoint) = (view: networkButton, pos: networkBtnPos)
		staticScreenElements.append(netTuple)
		
		// Settings Button
		
		let settingsBtnPos = CGPoint(x: UIScreen.mainScreen().bounds.width - 120,
			y: UIScreen.mainScreen().bounds.height - 120)
		var settingsButton = UIButton(frame: CGRectMake(settingsBtnPos.x, settingsBtnPos.y, 120, 120))
		settingsButton.setImage(UIImage(named: "settingsButton"), forState: .Normal)
		settingsButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let settingsTuple: (view: UIView, pos: CGPoint) = (view: settingsButton, settingsBtnPos)
		staticScreenElements.append(settingsTuple)
		
		// Trash Can
		
		let trashCanPos = CGPoint(x: UIScreen.mainScreen().bounds.width/2 - 50,
			y: UIScreen.mainScreen().bounds.height - 110)
		trashCanButton = UIView(frame: CGRectMake(trashCanPos.x, trashCanPos.y, 100, 100))
		trashCanButton.backgroundColor = UIColor.blackColor()
		trashCanButton.hidden = true
		let trashTuple: (view: UIView, pos: CGPoint) = (view: trashCanButton, trashCanPos)
		staticScreenElements.append(trashTuple)
        
        
		// Add Buttons to scrollView
		
		scrollView.addSubview(pipMenuButton)
		scrollView.addSubview(userDataButton)
		scrollView.addSubview(networkButton)
		scrollView.addSubview(settingsButton)
		scrollView.addSubview(trashCanButton)
		
		
		/* ------------------------
			Tap Gesture Recognizer
		   ------------------------ */
		
		self.view.userInteractionEnabled = true;
		scrollView.userInteractionEnabled = true;
		
		var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
		doubleTapRecognizer.numberOfTapsRequired = 2
		doubleTapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(doubleTapRecognizer)
		
		var tapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewTapped:")
		tapRecognizer.numberOfTapsRequired = 1
		tapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(tapRecognizer)
		
		var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "scrollViewPan:")
		panGestureRecognizer.delegate = self
		scrollView.addGestureRecognizer(panGestureRecognizer)
		
		let scrollViewFrame: CGRect = scrollView.frame
		let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
		let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
		let minScale: CGFloat = min(scaleWidth, scaleHeight)
		
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 1.5
		scrollView.zoomScale = minScale
		
		/* ------------------------
			Tap Gesture Recognizer
		   ------------------------ */

	}

	
	// BUILTIN - not sure what to use for
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	func setPipBeingDragged(view: BasePipView) {
		pipViewBeingDragged = view
		scrollView.scrollEnabled = false
	}
	
	func clearPipBeingDragged() {
		pipViewBeingDragged = nil
		scrollView.scrollEnabled = true
	}
	
	
	func scrollViewPan(recognizer: UIPanGestureRecognizer) {
		if pipViewBeingDragged != nil {
			
			if recognizer.state == .Began {
				pipViewBeingDragged.updateLastLocation()
			}
			
			let lastLocation = pipViewBeingDragged.lastLocation
			
			let translation = recognizer.translationInView(scrollView)
			let translationScaled = CGPoint(x: translation.x / scrollView.zoomScale, y: translation.y / scrollView.zoomScale)
			pipViewBeingDragged.center = CGPointMake(lastLocation.x + translationScaled.x, lastLocation.y + translationScaled.y)
			
			pipViewBeingDragged.updateArms()
			
			if recognizer.state == .Ended {
				if stoppedBeingDragged(pipViewBeingDragged.frame) {
					_mainPipDirectory.deletePip(pipViewBeingDragged.pipId)
				}
				
				clearPipBeingDragged()
				
			}else{
				startedBeingDragged()
			}
			
			return
		}
		
		if armViewBeingCreated != nil {
			armViewBeingCreated.updateEnd(recognizer.locationInView(scrollView))
			
			if recognizer.state == .Ended {
				
				armStoppedBeingDragged(armViewBeingCreated)
				
			}
		}
	}

	// touchesBegan: 
	// I/O: used to exit/cancel any active screen elements
	//		active buttons, open menus etc.
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
		for ele in staticScreenElements {
			if var menu = (ele.view as? CanvasMenuView){
				menu.toggleActive()
			}
		}
		
		scrollView.endEditing(true)
		
        return
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
	
	// scrollViewTapped: UITapGestureRecognizer -> nil
	// I/O: resets the state of active Pips, and closes all menus
	
	func scrollViewTapped(recognizer: UITapGestureRecognizer) {
			
		for ele in staticScreenElements {
			if var menu = (ele.view as? CanvasMenuView) {
				if menu.viewIsActive {
					menu.toggleActive()
					self.setMenuButtonsActive()
				}
			}
		}
		
	}
	
	// viewForZoomingInScrollView: UIScrollView -> UIView
	// I/O: returns containerView. Don't remember why.
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return containerView
	}
	
	// scrollViewDidZoom: UIScrollView -> ??
	// I/O: ???
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		return
	}
	
	// scrollViewDidScoll: UIScrollView -> nil
	// I/O: moves all static screen elements to stay relative to screen
	
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
	
	// pipStartedBeingDragged: nil -> nil
	// I/O: called by a pip when it first starts being dragged
	//		makes the trash can visible
	func startedBeingDragged() {
		trashCanButton.hidden = false
	}
	
	// pipStoppedBeingDragged: nil -> nil
	// I/O: called by a pip when touchesEnded
	//		hides the trash can 
	func stoppedBeingDragged(rect: CGRect) -> Bool{
		trashCanButton.hidden = true
		
		let pipRect: CGRect = scrollView.convertRect(rect, fromView: containerView)
		
		return CGRectIntersectsRect(pipRect, trashCanButton.frame)
	}
	
	func armStoppedBeingDragged(arm: ArmView) {
		for (id, pip) in _mainPipDirectory.getAllPips() {
			
			// if arm was successfully connected
			if pip.view.frame.contains(arm.end) && id != arm.startPipID{
				arm.endPipID = id
				arm.makeConnection()
				
				armViewBeingCreated = nil
				
				return
			}
		}
		
		armViewBeingCreated.removeFromSuperview()
		armViewBeingCreated = nil
	}
	
	// menuButtonPressed: UIButton -> nil
	// I/O: unused for now, will be used to implement other menus
	
	func menuButtonPressed(sender: UIButton!){
		println("no menu to toggle yet")
	}
	
	// setMenuButtonsInactive: nil -> nil
	// I/O: delegate method of all menu buttons
	//		used to make them invisible and untouchable while a menu is open
	
	func setMenuButtonsInactive(sender: UIButton) {
		
		scrollView.scrollEnabled = false
		
		for ele in staticScreenElements {
			if var buttonView = (ele.view as? UIButton) {
				buttonView.enabled = false
			}
		}
	}
	
	// setMenuButtonsActive: nil -> nil
	// I/O: called when menu's are deactivated
	//		used to make all menu buttons visible and active
	
	func setMenuButtonsActive(){
		
		scrollView.scrollEnabled = true
		
		for ele in staticScreenElements {
			if var buttonView = (ele.view as? UIButton) {
				buttonView.enabled = true;
				buttonView.hidden = false;
			}
		}
	}
	
	/* --------------------------------------------------------
	 * THIS COMMENT IS UNDER NO CIRCUMSTANCES TO BE MODIFIED
	 * MOVED, DELETED, OR IN ANY WAY ALTERED
	 * FOR ALL TIME LET IT BE KNOWN THAT
	 * PETER SLATTERY IS PROGRAMMING GOD
	 * --------------------------------------------------------
	*/
	
	// addPipView: BasePipView -> nil
	// I/O: adds pipView to containerView
	//		called by PipDirectory.createPipOfType()
    
    var curPipView : BasePipView? // TO DO: VERY MESSY.
    func currPipView(pipView: BasePipView){
        curPipView = pipView
    }
    
//    func gravityUpdated(motion: CMDeviceMotion!, error: NSError!) {
//        
//        let grav : CMAcceleration = motion.gravity;
//        
//        let x = CGFloat(grav.x);
//        let y = CGFloat(grav.y);
//        
//        var v = CGVectorMake(x, y);
//        
//        var accelPip = curPipView as? AccelPipView
//        accelPip!.x = CGFloat(grav.x)
//        accelPip!.y = CGFloat(grav.y)
//        accelPip!.z = CGFloat(grav.z)
//        
//        let numberFormatter = NSNumberFormatter()
//        numberFormatter.numberStyle = .DecimalStyle
//        numberFormatter.minimumFractionDigits = 3
//        numberFormatter.maximumFractionDigits = 3
//        let sx = numberFormatter.stringFromNumber(accelPip!.x!)
//        let sy = numberFormatter.stringFromNumber(accelPip!.y!)
//        let sz = numberFormatter.stringFromNumber(accelPip!.z!)
//        
////        accelPip!.textLayer.string = "\(accelPip!.x)"
//        accelPip!.textLayer.string = sx! + " " + sy! + " " + sz!
//        var r = accelPip!.x!*2
//        var g = accelPip!.y!*2
//        var b = accelPip!.z!*2
//        
////        println(r)
//        
//        accelPip!.colorBlock.backgroundColor = UIColor(red:r, green:g,blue:b,alpha:1.0)
//        
////        accelPip!.x.save(CGFloat(grav.x))
//        println(accelPip!.x)
//        println(accelPip!.y)
//        println(accelPip!.z)
////        println(x)
//        
//        
//    }
	
	func addPipView(pipView: BasePipView) {
        println("Add pip view")
        
        var pipType: String = pipView.description.componentsSeparatedByString(".")[1].componentsSeparatedByString(":")[0]
        
        // this returns fatal error: unexpectedly found nil while unwrapping an Optional value” errors in Swift error
        var curPipType = _mainPipDirectory.getPipByID(pipView.pipId).model.getPipType()
        
        // cast: to add in
       
        
        // get pip type
        if var castPipView = (pipView as? ImagePipView){
			
            // [messy] so we can have a reference to the pipView instance. when we update photoImageView
            currPipView(castPipView)
			
			/*
            // opens camera
            pipView2!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("capture:")))
            */
        }

        
		containerView.addSubview(pipView)
		containerView.bringSubviewToFront(pipView)
	}
	
	// addArmView: ArmView -> nil
	// I/O: Adds armView to containerView and moves it all the way to the back
	//		called by PipDirectory.makeConnection()
	
	func addArmView(armView: ArmView) {
		containerView.addSubview(armView)
		//scrollView.sendSubviewToBack(armView)
		armView.setNeedsDisplay()
	}
	
	// removeArmView: ArmView -> nil
	// I/O: Removes armView from containerView
	
	func removeArmView(armView: ArmView) {
		armView.removeFromSuperview()
	}
	
	func addHandView(handView: HandView) {
		containerView.addSubview(handView)
	}
	
	func removeHandView(handView: HandView) {
		handView.removeFromSuperview()
	}
	
	// ------------
	//	Accessors
	// ------------
	
	func getContainerView() -> UIView {
		return containerView
	}
}

