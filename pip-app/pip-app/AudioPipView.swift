
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

//protocol PhotoLibraryDelegate {
//    func capture()
//}

class AudioPipView: BasePipView, NSURLConnectionDelegate, UIScrollViewDelegate, UINavigationControllerDelegate{
    
    // main changer
    // inherits photoImageView: UIImageView from BasePip
    
    // for image pip
    // TO DO: FIGURE OUT A WAY TO SAVE UNBLURRED+ BLURRED IMAGE
    var photoImageView = UIImageView(frame: CGRectMake(12, 32, 75, 68))
    
    var textView = UIView(frame: CGRectMake(40, 120, 200, 200))
    
    var blurImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    var blackLayer = CALayer()
    var colorLayer = CALayer()
    var textLayer = CATextLayer()
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "soundPip-image")!, id: id)
        
        photoImageView.frame = CGRectMake((self.frame.width / 2) - 35, 32, 70, 68)
        photoImageView.layer.cornerRadius = 15
        photoImageView.layer.masksToBounds = true
        
        
        textView.frame = photoImageView.frame
        
        //        self.photoImageView.alpha = 1.0
        
        photoImageView.backgroundColor = UIColor.whiteColor()
        addSubview(photoImageView)
        addSubview(textView)
        photoImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        textLayer.frame = CGRectMake(0, 0, photoImageView.bounds.width, photoImageView.bounds.height)
        textLayer.font = CTFontCreateWithName("Helvetica", 12, nil)
        textLayer.wrapped = true
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textView.layer.addSublayer(textLayer)
        
        addGestureRecognizer(UITapGestureRecognizer(target: _mainPipDirectory.viewController, action: "capture:"))
        
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
        println ("updating audio View")
        let output = (getModel() as? AudioPip)?.getOutput()
        
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
            //            if (output?.getImage() != nil){
            if (self.photoImageView.image != nil){
                var blurredImage = self.applyBlurEffect(photoImageView.image!)
                self.photoImageView.image = blurredImage
            }
        }
        
        (getModel() as? ImagePip)?.updateReliantPips()
    }
    
    
}
