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
import AVFoundation
//import Photos


class WorkspaceViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    lazy var motionManager = CMMotionManager()

	
	@IBOutlet var scrollView: UIScrollView!
	var containerView: UIView!
	var staticScreenElements: [(view: UIView, pos: CGPoint)] = []
	
	var pipViewBeingDragged: BasePipView!
	var armViewBeingCreated: ArmView!
    
    var audioPlayer: AVAudioPlayer?
    
    var deleteSample: AVAudioPlayer!
    var moveSample: AVAudioPlayer!
    var handshakeSample: AVAudioPlayer!
    
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
    
    // capture is called in ImagePipView as a gesture recognizer
    func capture(_ tap: UITapGestureRecognizer) {
        
        print("capture")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            print("Button capture")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            print("post button capture")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [AnyHashable: Any]){
            print("Inside imagePickerController function in ViewController")
            print("curPipView")
            print(curPipView!)
            let curPipView2 = curPipView as? ImagePipView!
            
            // to do: align photo with image pip
            curPipView2!.photoImageView.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!

            print("black layer")
            
            // black layer
            curPipView2!.blackLayer.frame = CGRect(x: 0, y: 0, width: curPipView2!.photoImageView.bounds.width, height: curPipView2!.photoImageView.bounds.height)
            curPipView2!.blackLayer.bounds = curPipView2!.photoImageView.layer.bounds
            curPipView2!.blackLayer.backgroundColor = UIColor.black.cgColor
            curPipView2!.blackLayer.opacity = 0.0
            
            curPipView2!.colorLayer.frame = CGRect(x: 0, y: 0, width: curPipView2!.photoImageView.bounds.width, height: curPipView2!.photoImageView.bounds.height)
            curPipView2!.colorLayer.bounds = curPipView2!.photoImageView.layer.bounds
//            curPipView2!.colorLayer.backgroundColor = UIColor.blackColor().CGColor
//            curPipView2!.colorLayer.opacity = 0.0
            
            curPipView2!.photoImageView.layer.addSublayer(curPipView2!.colorLayer)
            curPipView2!.photoImageView.layer.addSublayer(curPipView2!.blackLayer)
            
            let curModel = curPipView2!.getModel() as? ImagePip
            
            // afer taking image, set image.
            
            curModel?.updateImage(curPipView2!.photoImageView.image!)
            print("called updateImage in ImagePip")
            curModel?.output.setImage(curPipView2!.photoImageView.image!)
            print("called setImage function in ViewController")
            
            print("setting image")
            
            
            // ImagePip output has an attribute 'accelStatus' that toggles according to whether there is an AccelPip input
            if (curModel?.output.accelStatus == true){
                print("GET ACCEL IS TRUE")
                let blurredImage = curPipView2!.applyBlurEffect(curPipView2!.photoImageView.image!)
                curPipView2!.photoImageView.image = blurredImage
            }
            
            print("changed pip view black")
            self.dismiss(animated: false, completion: nil)
    }

    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia((kUTTypeImage as? String)!, sourceType: .camera)
    }
    func cameraSupportsMedia(_ mediaType: String,
        sourceType: UIImagePickerControllerSourceType) -> Bool{

            let availableMediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType) 
    
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
    
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        let path = Bundle.main.path(forResource: file as String, ofType: type as String)
        let url = URL(fileURLWithPath: path!)
        
        //2
//        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
        } catch let error as NSError {
            print(error.description)
        }
        
        //4
        return audioPlayer!
    }
    
	override func viewDidLoad() {
        print("hello")
		super.viewDidLoad()
		
        // get camera data
        print("Camera is ")
        if isCameraAvailable() == false{
            print ("not ")
        }
        print("available")
    
        if doesCameraSupportTakingPhotos(){
            print("The camera supports taking photos")
        } else{
            print("The camera does not support taking photos")
        }
        
        // audio recording permissions
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            session.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("audio recording allowed")
                    } else {
                        print("We don't have permission to record audio")
                    }
                }
            }
        } catch let error as NSError {
            print("An error occurred in setting the audio " +
                "session category. Error = \(error)")
        }
        
		_mainPipDirectory.registerViewController(self)
		
		/* -------------------
			Scroll View Setup
		   ------------------- */
	
		containerView = UIView(frame: CGRect(x: 0, y: 0, width: 1440, height: 2880))
		scrollView.addSubview(containerView)
		containerView.setNeedsDisplay()
		
		scrollView.contentSize = containerView.bounds.size
		
		scrollView.backgroundColor = UIColor.white
		
		/*  -------------------
			 Menu's Setup
			------------------- */
		
		// Add Menus
		// first so that they are under buttons
		let pipMenuPos = CGPoint(x: 0, y: 0)
		var pipMenu = CanvasMenuView.makePipMenu(pipMenuPos)
		let pipMenuTuple: (view: UIView, pos: CGPoint) = (view: pipMenu, pos: pipMenuPos)
		staticScreenElements.append(pipMenuTuple)
		
		let dataMenuPos = CGPoint(x: 0, y: 0)
		var dataMenu = CanvasMenuView.makeDataMenu(dataMenuPos)
		let dataMenuTuple: (view: UIView, pos: CGPoint) = (view: dataMenu, pos: dataMenuPos)
		staticScreenElements.append(dataMenuTuple)
		
		
		scrollView.addSubview(pipMenu)
		scrollView.addSubview(dataMenu)
		
		/*  -------------------
			 Scroll View Setup
			------------------- */
		
		// Add Menu Buttons
		// second so that they are on top of menus
		
		// Pip Menu Button
		
		let pipMenuBtnPos = CGPoint(x: 0, y: 0)
		var pipMenuButton = UIButton(frame: CGRect(x: pipMenuBtnPos.x, y: pipMenuBtnPos.y, width: 120, height: 120))
		pipMenuButton.setImage(UIImage(named: "pipMenuButton"), for: UIControlState())
		pipMenuButton.addTarget(pipMenu, action: "toggleActive:", for: .touchUpInside)
		pipMenuButton.addTarget(self, action: #selector(WorkspaceViewController.setMenuButtonsInactive(_:)), for: .touchUpInside)
		let pipTuple: (view: UIView, pos: CGPoint) = (view: pipMenuButton, pos: pipMenuBtnPos)
		staticScreenElements.append(pipTuple)
		
		// User Data Button
		
		let userDataBtnPos = CGPoint(x: UIScreen.main.bounds.width - 120, y: 0)
		var userDataButton = UIButton(frame: CGRect(x: userDataBtnPos.x, y: userDataBtnPos.y, width: 120, height: 120))
		userDataButton.setImage(UIImage(named: "dataButton"), for: UIControlState())
		userDataButton.addTarget(dataMenu, action: "toggleActive:", for: .touchUpInside)
		userDataButton.addTarget(self, action: #selector(WorkspaceViewController.setMenuButtonsInactive(_:)), for: .touchUpInside)
		let userTuple: (view: UIView, pos: CGPoint) = (view: userDataButton, pos: userDataBtnPos)
		staticScreenElements.append(userTuple)
		
		// Network Button
		
		let networkBtnPos = CGPoint(x: 0, y: UIScreen.main.bounds.height - 120)
		var networkButton = UIButton(frame: CGRect(x: networkBtnPos.x, y: networkBtnPos.y, width: 120, height: 120))
		networkButton.setImage(UIImage(named: "networkButton"), for: UIControlState())
		networkButton.addTarget(self, action: #selector(WorkspaceViewController.menuButtonPressed(_:)), for: .touchUpInside)
		let netTuple: (view: UIView, pos: CGPoint) = (view: networkButton, pos: networkBtnPos)
		staticScreenElements.append(netTuple)
		
		// Settings Button
		
		let settingsBtnPos = CGPoint(x: UIScreen.main.bounds.width - 120,
			y: UIScreen.main.bounds.height - 120)
		var settingsButton = UIButton(frame: CGRect(x: settingsBtnPos.x, y: settingsBtnPos.y, width: 120, height: 120))
		settingsButton.setImage(UIImage(named: "settingsButton"), for: UIControlState())
		settingsButton.addTarget(self, action: #selector(WorkspaceViewController.menuButtonPressed(_:)), for: .touchUpInside)
		let settingsTuple: (view: UIView, pos: CGPoint) = (view: settingsButton, settingsBtnPos)
		staticScreenElements.append(settingsTuple)
		
		// Trash Can
		
		let trashCanPos = CGPoint(x: UIScreen.main.bounds.width/2 - 50,
			y: UIScreen.main.bounds.height - 110)
		trashCanButton = UIView(frame: CGRect(x: trashCanPos.x, y: trashCanPos.y, width: 100, height: 100))
		trashCanButton.backgroundColor = UIColor.black
		trashCanButton.isHidden = true
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
		
		self.view.isUserInteractionEnabled = true;
		scrollView.isUserInteractionEnabled = true;
		
		var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WorkspaceViewController.scrollViewDoubleTapped(_:)))
		doubleTapRecognizer.numberOfTapsRequired = 2
		doubleTapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(doubleTapRecognizer)
		
		var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WorkspaceViewController.scrollViewTapped(_:)))
		tapRecognizer.numberOfTapsRequired = 1
		tapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(tapRecognizer)
		
		var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WorkspaceViewController.scrollViewPan(_:)))
		panGestureRecognizer.delegate = self
		scrollView.addGestureRecognizer(panGestureRecognizer)
		
		let scrollViewFrame: CGRect = scrollView.frame
		let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
		let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
		let minScale: CGFloat = min(scaleWidth, scaleHeight)
		
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 1.5
		scrollView.zoomScale = 1.0
		
		/* ------------------------
			Tap Gesture Recognizer
		   ------------------------ */

	}

	
	// BUILTIN - not sure what to use for
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	func setPipBeingDragged(_ view: BasePipView) {
		pipViewBeingDragged = view
        
		scrollView.isScrollEnabled = false
	}
	
	func clearPipBeingDragged() {
		pipViewBeingDragged = nil
		scrollView.isScrollEnabled = true
	}
	
    
    /* The delegate message that will let us know that the player has finished playing an audio file */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer!,
        successfully flag: Bool) {
        print("Finished playing the song")
    }
	
	func scrollViewPan(_ recognizer: UIPanGestureRecognizer) {
        
        
        
		if pipViewBeingDragged != nil {
			
			if recognizer.state == .began {
				pipViewBeingDragged.updateLastLocation()
				
				_audioController.playSound(.move)
			}
			
			let lastLocation = pipViewBeingDragged.lastLocation
			
			let translation = recognizer.translation(in: scrollView)
			let translationScaled = CGPoint(x: translation.x / scrollView.zoomScale, y: translation.y / scrollView.zoomScale)
			pipViewBeingDragged.center = CGPoint(x: lastLocation.x + translationScaled.x, y: lastLocation.y + translationScaled.y)
			
			pipViewBeingDragged.updateArms()
			
			if recognizer.state == .ended {
				if stoppedBeingDragged(pipViewBeingDragged.frame) {
					
					_audioController.playSound(AudioClips.delete)
					
					_mainPipDirectory.deletePip(pipViewBeingDragged.pipId)
				}
				
				clearPipBeingDragged()
				
			}else{
				startedBeingDragged()
			}
			
			return
		}
		
		if armViewBeingCreated != nil {
			let locInView = recognizer.location(in: scrollView)
			let locInViewScaled = CGPoint(x: locInView.x / scrollView.zoomScale, y: locInView.y / scrollView.zoomScale)
			armViewBeingCreated.updateEnd(locInViewScaled)
			
			if recognizer.state == .ended {
				
				armStoppedBeingDragged(armViewBeingCreated)
				
			}
		}
	}

	// touchesBegan: 
	// I/O: used to exit/cancel any active screen elements
	//		active buttons, open menus etc.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
		for ele in staticScreenElements {
			if let menu = (ele.view as? CanvasMenuView){
				menu.toggleActive()
			}
		}
		
		scrollView.endEditing(true)
		
        return
	}
	

	// scrollViewDoubleTapped: UITapGestureRecognizer -> nil
	// I/O: called when the background is double tapped
	//		zooms the view in by 1.5%
	
	func scrollViewDoubleTapped(_ recognizer: UITapGestureRecognizer) {
		let pointInView = recognizer.location(in: containerView)
		
		let newZoomScale = min((scrollView.zoomScale * 1.5), scrollView.maximumZoomScale)
		
		let scrollViewSize = scrollView.bounds.size
		let w = scrollViewSize.width / newZoomScale
		let h = scrollViewSize.height / newZoomScale
		let x = pointInView.x - (w / 2.0)
		let y = pointInView.y - (h / 2.0)
		
		let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
		
		scrollView.zoom(to: rectToZoomTo, animated: true)
	}
	
	// scrollViewTapped: UITapGestureRecognizer -> nil
	// I/O: resets the state of active Pips, and closes all menus
	
	func scrollViewTapped(_ recognizer: UITapGestureRecognizer) {
			
		for ele in staticScreenElements {
			if let menu = (ele.view as? CanvasMenuView) {
				if menu.viewIsActive {
					menu.toggleActive()
					self.setMenuButtonsActive()
				}
			}
		}
		
	}
	
	// viewForZoomingInScrollView: UIScrollView -> UIView
	// I/O: returns containerView. Don't remember why.
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return containerView
	}
	
	// scrollViewDidZoom: UIScrollView -> ??
	// I/O: ???
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		return
	}
	
	// scrollViewDidScoll: UIScrollView -> nil
	// I/O: moves all static screen elements to stay relative to screen
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset: CGPoint = scrollView.contentOffset
		
		for ele in staticScreenElements {
			if let menuView = (ele.view as? CanvasMenuView) {
				var basePos: CGPoint!
				if menuView.viewIsActive {
					basePos = menuView.baseLocation
				} else {
					basePos = menuView.offsetLocation
				}
				
				menuView.frame = CGRect(x: basePos.x + offset.x, y: basePos.y + offset.y,
					width: ele.view.frame.width, height: ele.view.frame.height)
			} else {
				ele.view.frame = CGRect(x: ele.pos.x + offset.x, y: ele.pos.y + offset.y, width: ele.view.frame.width, height: ele.view.frame.height)
			}
		}
	}
	
	// pipStartedBeingDragged: nil -> nil
	// I/O: called by a pip when it first starts being dragged
	//		makes the trash can visible
	func startedBeingDragged() {
		trashCanButton.isHidden = false
	}
	
	// pipStoppedBeingDragged: nil -> nil
	// I/O: called by a pip when touchesEnded
	//		hides the trash can 
	func stoppedBeingDragged(_ rect: CGRect) -> Bool{
		trashCanButton.isHidden = true
		
		let pipRect: CGRect = scrollView.convert(rect, from: containerView)
		
		return pipRect.intersects(trashCanButton.frame)
	}
	
	func armStoppedBeingDragged(_ arm: ArmView) {
		for (id, pip) in _mainPipDirectory.getAllPips() {
			
			// if arm was successfully connected
			if pip.view.frame.contains(arm.end) && id != arm.startPipID{
        
                // play sound effect
                _audioController.playSound(AudioClips.handshake)
				
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
	
	func menuButtonPressed(_ sender: UIButton!){
		print("no menu to toggle yet")
	}
	
	// setMenuButtonsInactive: nil -> nil
	// I/O: delegate method of all menu buttons
	//		used to make them invisible and untouchable while a menu is open
	
	func setMenuButtonsInactive(_ sender: UIButton) {
		
		scrollView.isScrollEnabled = false
		
		for ele in staticScreenElements {
			if let buttonView = (ele.view as? UIButton) {
				buttonView.isEnabled = false
			}
		}
	}
	
	// setMenuButtonsActive: nil -> nil
	// I/O: called when menu's are deactivated
	//		used to make all menu buttons visible and active
	
	func setMenuButtonsActive(){
		
		scrollView.isScrollEnabled = true
		
		for ele in staticScreenElements {
			if let buttonView = (ele.view as? UIButton) {
				buttonView.isEnabled = true;
				buttonView.isHidden = false;
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
    func currPipView(_ pipView: BasePipView){
        curPipView = pipView
    }

    
    
	func addPipView(_ pipView: BasePipView) {
        print("Add pip view")
        
        var pipType: String = pipView.description.components(separatedBy: ".")[1].components(separatedBy: ":")[0]
        
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
        
        
        if var castPipView = (pipView as? AudioPipView){
            print("audio pip!")
            currPipView(castPipView)
        }

        
		containerView.addSubview(pipView)
		containerView.bringSubview(toFront: pipView)
	}
	
	// addArmView: ArmView -> nil
	// I/O: Adds armView to containerView and moves it all the way to the back
	//		called by PipDirectory.makeConnection()
	
	func addArmView(_ armView: ArmView) {
		containerView.addSubview(armView)
		//scrollView.sendSubviewToBack(armView)
		armView.setNeedsDisplay()
	}
	
	// removeArmView: ArmView -> nil
	// I/O: Removes armView from containerView
	
	func removeArmView(_ armView: ArmView) {
		armView.removeFromSuperview()
	}
	
	func addHandView(_ handView: HandView) {
		containerView.addSubview(handView)
	}
	
	func removeHandView(_ handView: HandView) {
		handView.removeFromSuperview()
	}
	
	// ------------
	//	Accessors
	// ------------
	
	func getContainerView() -> UIView {
		return containerView
	}
}

