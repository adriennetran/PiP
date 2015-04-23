//
//  cameraViewController.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/23/15.
//  Copyright (c) 2015 Adrienne Tran. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices


class cameraViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let imgpip = ImagePip(id: 24)
    
    @IBOutlet weak var myImageView: UIImageView!
    let picker = UIImagePickerController()
    
    @IBAction func shootPhoto(sender: UIBarButtonItem){
    }

    @IBAction func photofromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        presentViewController(picker, animated: true, completion: nil)//4
    }
    
    
    /* We will use this variable to determine if the viewDidAppear:
    method of our view controller is already called or not. If not, we will
    display the camera view */
    var beenHereBefore = false
    var controller: UIImagePickerController?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
//    func imagePickerController(picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
//            
//            println("Picker returned successfully")
//            
//            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
//            
//            if let type:AnyObject = mediaType{
//                
//                if type is String{
//                    let stringType = type as! String
//                    
//                    if stringType == kUTTypeMovie as! String{
//                        let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
//                        if let url = urlOfVideo{
//                            println("Video URL = \(url)")
//                        }
//                    }
//                        
//                    else if stringType == kUTTypeImage as! String{
//                        /* Let's get the metadata. This is only for images. Not videos */
//                        let metadata = info[UIImagePickerControllerMediaMetadata]
//                            as? NSDictionary
//                        if let theMetaData = metadata{
//                            let image = info[UIImagePickerControllerOriginalImage]
//                                as? UIImage
//                            if let theImage = image{
//                                println("Image Metadata = \(theMetaData)")
//                                println("Image = \(theImage)")
//                            }
//                        }
//                    }
//                    
//                }
//            }
//            
//            picker.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("Picker was cancelled")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isCameraAvailable() -> Bool{
        println("inside cameraVC - camera is available")
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
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
    
    func doesCameraSupportTakingPhotos() -> Bool{
        println("inside cameraVC - camera does support taking photos")
        return cameraSupportsMedia(kUTTypeImage as! String, sourceType: .Camera)
    }
    
    var imagePicker: UIImagePickerController!
    
    func takePhoto(recognizer: UITapGestureRecognizer){
        println("inside viewToAppear")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
//        super.viewDidAppear(true)
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

    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        picker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        println("inside viewToAppear")
        super.viewDidAppear(animated)
        
        if beenHereBefore{
            /* Only display the picker once as the viewDidAppear: method gets
            called whenever the view of our view controller gets displayed */
            return;
        } else {
            beenHereBefore = true
        }
        
        if isCameraAvailable() && doesCameraSupportTakingPhotos(){
            
            controller = UIImagePickerController()
            
            if let theController = controller{
                theController.sourceType = .Camera
                
                theController.mediaTypes = [kUTTypeImage as! String]
                
                theController.allowsEditing = true
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
            
        } else {
            println("Camera is not available")
        }
        
    }
    
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
    }
    

    
}