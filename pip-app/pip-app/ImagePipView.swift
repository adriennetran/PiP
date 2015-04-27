
//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// Create a subview which is the "images directory"

//let controller = CameraViewControllerTest(nibName: "ViewController", bundle: NSBundle.mainBundle())

protocol PhotoLibraryDelegate {
    func capture()
}

class ImagePipView: BasePipView, NSURLConnectionDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    


//    var delegate: PhotoLibraryDelegate?
//    var addPhotoButton: UIView
    
    // required stuff.
//    required init(coder aDecoder: NSCoder){
//        fatalError("coder initializer not coded")
//    }
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "imagePip-image")!, id: id)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
        
        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)

        // acts as View controller
        var captureButton = UIView(frame: CGRectMake(frame.width/2 - 30, 60, 60, 60))
        captureButton.backgroundColor = UIColor.blueColor()
        
        println("before capture button recognizer")
        
//        captureButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapImageView:"))
        
        addSubview(captureButton)
       
        
    }
    
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func capture1(recognizer: UITapGestureRecognizer){
//        println("hello")
////        delegate?.capture()
//        println("hello2")
//
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
//            println("Button capture")
//            
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
//            imagePicker.mediaTypes = [kUTTypeImage]
//            imagePicker.allowsEditing = false
//            
//            println("post button capture")
//        
//        self.window?.rootViewController!.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//
//    }
//    
//    var photoImageView2 = UIImageView(frame: CGRectMake(40, 120, 200, 200))
//    
//    // handles output
//    func ImagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        println("i've got an image");
//        
//        photoImageView2.image = image
//        addSubview(photoImageView2)
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }
//    

    
    // accessors
    override func getModel() -> BasePip {
        return _mainPipDirectory.getPipByID(pipId).model
    }
    
    // takes image data chosen by user
    func getLocalImage(image: UIImage){
        
    }
    
    override func updateView(){
        (getModel() as? ImagePip)?.updateReliantPips()
    }
    
    
}
