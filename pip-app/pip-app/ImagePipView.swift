
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
        
        var addPhotoFrame = UIView(frame: CGRectMake(frame.width/2 - 30, 60, 60, 60))
        addPhotoFrame.backgroundColor = UIColor.blueColor()
        
        addPhotoFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addPhotoTouched:"))
        
        addSubview(addPhotoFrame)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func addPhotoTouched(recognizer: UITapGestureRecognizer){
        // call model.cameraViewController
        // pull up the camera screen
        println("PHOTO TOUCHED")
        delegate?.openPhotoLibrary(self)
        
//        ViewController.viewDidAppear_Camera()
//        (getModel() as? ImagePip)?.cameraVC.takePhoto()
//        cameraVC.viewDidAppear(true)
//         (getModel() as? ImagePip)?.openPhotoLibrary()
//        delegate!.openPhotoLibrary()
        
        
//        var controller = CameraViewControllerTest()
        println("after photo touched")
        
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
