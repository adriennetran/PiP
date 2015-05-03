
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
    // TO DO: FIGURE OUT A WAY TO SAVE UNBLURRED+ BLURRED IMAGE
    var photoImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    var textView = UIView(frame: CGRectMake(40, 120, 200, 200))
    
    var blurImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    var blackLayer = CALayer()
    var colorLayer = CALayer()
    var textLayer = CATextLayer()
    
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "imagePip-image")!, id: id)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
        
        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
        
//        self.photoImageView.alpha = 1.0
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyBlurEffect(image: UIImage) -> UIImage{
        var imageToBlur = CIImage(image: image)
        var blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter.setValue(imageToBlur, forKey: "inputImage")
        var resultImage = blurfilter.valueForKey("outputImage") as! CIImage
        var blurredImage = UIImage(CIImage: resultImage)
        self.blurImageView.image = blurredImage
        
        return blurredImage!
        
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
        
        // color
        if (output?.getColor() != nil){
            println(output?.getColor())
            self.colorLayer.backgroundColor = (output?.getColor())!.CGColor
            self.colorLayer.opacity = 0.2
        }
        
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
        
        // accel
        if (output?.getAccel() == true){
            println("accel > image: true")
            var blurredImage = self.applyBlurEffect(photoImageView.image!)
            self.photoImageView.image = blurredImage
        }
        
        (getModel() as? ImagePip)?.updateReliantPips()
    }
    
    
}
