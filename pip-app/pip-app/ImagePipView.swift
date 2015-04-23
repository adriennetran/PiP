
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
let controller = CameraViewControllerTest()

protocol PhotoLibraryDelegate {
    func openPhotoLibrary(sender: ImagePipView)
}

class ImagePipView: BasePipView, NSURLConnectionDelegate{

    var delegate: PhotoLibraryDelegate?
    
    // required stuff.
//    required init(coder aDecoder: NSCoder){
//        fatalError("coder initializer not coded")
//    }
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "imagePip-image")!, id: id)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
        
        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
        
        var addPhotoButton = UIView(frame: CGRectMake(frame.width/2 - 30, 60, 60, 60))
        addPhotoButton.backgroundColor = UIColor.blueColor()
        
        addPhotoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addPhotoTouched:"))
        
//        var testButton = UIView(frame: CGRectMake(frame.width/2 - 30, 60, 100, 200))
//        testButton.backgroundColor = UIColor.greenColor()
//        testButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "controller.buttonDidTap:"))
//        addSubview(testButton)
        
        addSubview(addPhotoButton)
       
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func addPhotoTouched(recognizer: UITapGestureRecognizer){
        // call model.cameraViewController
        // pull up the camera screen
        println("PHOTO TOUCHED")
//        controller.viewDidAppear(true)
//        controller.btnCamera(self)
        controller.viewDidAppear(true)
        println("after photo touched")
        
//        controller.presentViewController(controller.photoPicker, animated: true, completion: nil)
        
        

        //        delegate?.openPhotoLibrary(self)
//        ViewController.viewDidAppear_Camera()
//        (getModel() as? ImagePip)?.cameraVC.takePhoto()
//        cameraVC.viewDidAppear(true)
//         (getModel() as? ImagePip)?.openPhotoLibrary()
//        delegate!.openPhotoLibrary()
        
        
//        var controller = CameraViewControllerTest()
        
        
    }
    
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
