
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
    var photoImageView = UIImageView(frame: CGRect(x: 12, y: 32, width: 75, height: 68))
    
    var textView = UIView(frame: CGRect(x: 40, y: 120, width: 200, height: 200))
    
    var blurImageView = UIImageView(frame: CGRect(x: 24, y: 64, width: 75, height: 68))

//    UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    var blackLayer = CALayer()
    var colorLayer = CALayer()
    var textLayer = CATextLayer()
    
    var blurView : UIVisualEffectView?

    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Image), id: id)
		
		photoImageView.frame = CGRect(x: (self.frame.width / 2) - 35, y: 32, width: 70, height: 68)
		photoImageView.layer.cornerRadius = 15
		photoImageView.layer.masksToBounds = true
		
		
		textView.frame = photoImageView.frame
        
//        self.photoImageView.alpha = 1.0
		
		photoImageView.backgroundColor = UIColor.white
		addSubview(photoImageView)
		addSubview(textView)
		photoImageView.contentMode = UIViewContentMode.scaleAspectFill
		
		textLayer.frame = CGRect(x: 0, y: 0, width: photoImageView.bounds.width, height: photoImageView.bounds.height)
		textLayer.font = CTFontCreateWithName("Helvetica" as CFString?, 12, nil)
		textLayer.isWrapped = true
		textLayer.alignmentMode = kCAAlignmentCenter
		textLayer.contentsScale = UIScreen.main.scale
		textView.layer.addSublayer(textLayer)
		
		addGestureRecognizer(UITapGestureRecognizer(target: _mainPipDirectory.viewController, action: Selector(("capture:"))))
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // takes in an non-blurred image
    // applies a blur
    // sets that blurred image to attribute blurImageView
    // returns a UIImage
    func applyBlurEffect(_ image: UIImage) -> UIImage{
        print("applyBlurEffect0")
        
//        var imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        print("applyBlurEffect1")
//        blurfilter.setValue(imageToBlur, forKey: "inputImage")
        blurfilter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        print("applyBlurEffect2")
        blurfilter?.setValue(50.0, forKey: kCIInputRadiusKey)
        print("applyBlurEffect2a")
        let resultImage = blurfilter?.value(forKey: "outputImage") as? CIImage
        
//        let displayImage = UIImage(CGImage: CIContext(options:nil).createCGImage(blurfilter.outputImage, fromRect:blurfilter.outputImage.extent()))!
        
        let context = CIContext(options: nil)
        if context != nil {
            let cgiImage = context.createCGImage(resultImage!, from: resultImage!.extent)
            let final = UIImage(cgImage: cgiImage!)
            return final
        }
        
       
        
        print("applyBlurEffect3")
//        let blurredImage = UIImage(CIImage: resultImage!)
        print("applyBlurEffect4")
//        self.blurImageView.image = displayImage
        print("applyBlurEffect5")
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
        print("updating imageView (ImagePipView)")
        let output = (getModel() as? ImagePip)?.getOutput()
        
        // color
        if (output?.getColor() != nil){
            print(output?.getColor())
            self.colorLayer.backgroundColor = (output?.getColor())!.cgColor
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
                print("switch > image: true")
                self.blackLayer.opacity = 0.5
            } else{
                print("switch > image: false")
                self.blackLayer.opacity = 0.1
            }
        }
        
        
        if (output?.getAccel() == true){
            print("accel > image: true")
        if (output?.getImage()) != nil{
            if self.photoImageView.image != nil{
//                println("let image = self.photoImageView.image")
//                var blurredImage = self.applyBlurEffect(image)
//                println("blurredImage")
//                self.photoImageView.image = blurredImage
//                println("blurredImage2")
                
                let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
                // 2
                print("1")
                self.blurView = UIVisualEffectView(effect: darkBlur)
                print("2")
                self.blurView!.frame = self.photoImageView.bounds
                print("3")
                
                // 3
                self.photoImageView.addSubview(self.blurView!)
                
                print("4")
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
