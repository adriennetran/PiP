
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
    
    // main changer
    // inherits photoImageView: UIImageView from BasePip
    
    // for image pip
    var photoImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    var blackLayer = CALayer()
    var textLayer = CATextLayer()
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "imagePip-image")!, id: id)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
        
        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // accessors
    override func getModel() -> BasePip {
        return _mainPipDirectory.getPipByID(pipId).model
    }
    
    // takes image data chosen by user
//    func getLocalImage(image: UIImage){
//        
//    }
    
    override func updateView(){
        println ("updating imageView")
        let output = (getModel() as? ImagePip)?.getOutput()
        
        // text
        if (output?.getText() != nil){
            self.textLayer.string = output?.getText()
        }
        
        
        // get switch signal
        if (output?.getSwitch() != nil){
            if (output?.getSwitch() == true){
                // update black
                println("switch > image: true")
                self.blackLayer.opacity = 0.5
            } else{
                println("switch > image: false")
                self.blackLayer.opacity = 0.1
            }
        }
        
        (getModel() as? ImagePip)?.updateReliantPips()
    }
    
    
}
