
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
    var photoImageView = UIImageView(frame: CGRectMake(12, 32, 75, 68))
    
    var textView = UIView(frame: CGRectMake(40, 120, 200, 200))
    
    var blurImageView = UIImageView(frame: CGRectMake(24, 64, 75, 68))

//    UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    var blackLayer = CALayer()
    var colorLayer = CALayer()
    var textLayer = CATextLayer()

    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Image), id: id)
		
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
    
    // takes in an non-blurred image
    // applies a blur
    // sets that blurred image to attribute blurImageView
    // returns a UIImage
    func applyBlurEffect(image: UIImage) -> UIImage{
        println("applyBlurEffect0")
        
//        var imageToBlur = CIImage(image: image)
        var blurfilter = CIFilter(name: "CIGaussianBlur")
        println("applyBlurEffect1")
//        blurfilter.setValue(imageToBlur, forKey: "inputImage")
        blurfilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        println("applyBlurEffect2")
        blurfilter.setValue(50.0, forKey: kCIInputRadiusKey)
        println("applyBlurEffect2a")
        let resultImage = blurfilter.valueForKey("outputImage") as? CIImage
        
//        let displayImage = UIImage(CGImage: CIContext(options:nil).createCGImage(blurfilter.outputImage, fromRect:blurfilter.outputImage.extent()))!
        
        let context = CIContext(options: nil)
        if context != nil {
            var cgiImage = context.createCGImage(resultImage, fromRect: resultImage!.extent())
            var final = UIImage(CGImage: cgiImage)
            return final!
        }
        
       
        
        println("applyBlurEffect3")
//        let blurredImage = UIImage(CIImage: resultImage!)
        println("applyBlurEffect4")
//        self.blurImageView.image = displayImage
        println("applyBlurEffect5")
//        return blurredImage!
        return self.photoImageView.image!
        
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
        println ("updating imageView (ImagePipView)")
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
        
        
        if (output?.getAccel() == true){
            println("accel > image: true")
        if let img2 = output?.getImage(){
            if let image = self.photoImageView.image{
//                println("let image = self.photoImageView.image")
//                var blurredImage = self.applyBlurEffect(image)
//                println("blurredImage")
//                self.photoImageView.image = blurredImage
//                println("blurredImage2")
                
                var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
                // 2
                println("1")
                var blurView = UIVisualEffectView(effect: darkBlur)
                println("2")
                blurView.frame = self.photoImageView.bounds
                println("3")
                
                // 3
                self.photoImageView.addSubview(blurView)
                println("4")
            }
        }
        }

        
        // accel
//        if (output?.getAccel() == true){
//            println("accel > image: true")
//            if (output?.getImage() != nil) {
//                println("getImage is not nil")
//                
//                if let imgaa = self.photoImageView.image{
//                        
//                        
//                    println("photoimageview is not nil")
//                    println("photoImageView.image")
//                    println(photoImageView.image)
//                    println("after image value")
//                    println("image")
//                    println(imgaa)
//                    
////                    var img1 : UIImage = self.photoImageView.image!
//                    
//                    println("0")
//                    var ciimage :CIImage = CIImage(image: imgaa)
//                    println("1")
//                    var filter : CIFilter = CIFilter(name:"CIGaussianBlur")
//                    println("2")
//                    filter.setDefaults()
//                    filter.setValue(ciimage, forKey: kCIInputImageKey)
//                    
//                    filter.setValue(30, forKey: kCIInputRadiusKey)
//                    
//                    
//                    
//                    var outputImage : CIImage = filter.outputImage;
//                    
//                    var blurredImage :UIImage = UIImage(CIImage: outputImage)!
//                    self.photoImageView.image = blurredImage
//                    
//                    println("blurredImage")
//                    println(blurredImage)
//                    
                    

////                }
//                }
//            }
//        }
        
        (getModel() as? ImagePip)?.updateReliantPips()
    }
    
    
}
