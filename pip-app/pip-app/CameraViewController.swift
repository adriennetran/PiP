//
//  cameravc3.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/26/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class CameraVC3: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate{
    
    var imgPip: ImagePipView!
    var containerView: UIView!
    
    var photoImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoImageView.backgroundColor = UIColor.greenColor()
        _mainPipDirectory.registerViewController2(self)
        
        self.view.addSubview(photoImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    // : refactor later. double added
//    func addPipView(pipView: BasePipView) {
////        pipView.addGestureRecognizer(UITapGestureRecognizer(target: pipView, action: "capture:"))
//        println("addpipView of cameraVC3")
//        containerView.addSubview(pipView)
//        containerView.bringSubviewToFront(pipView)
//    }
    
    var beenHereBefore = false
    
    override func viewDidAppear(animated: Bool) {
        if beenHereBefore{
            /* Only display the picker once as the viewDidAppear: method gets
            called whenever the view of our view controller gets displayed */
            return;
        } else {
            beenHereBefore = true
        }
        
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
        
        
        println("after camera vc3 will appear")
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("Picker was cancelled")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        println("camera vc3 view will appear")
        super.viewWillAppear(animated)
    }
    

    // this is called after a photo is taken
    // saves the photo to photoImageView (which is already added to the view)
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    

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
    
}
    