
//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit
//import MobileCoreServices
import CoreMotion

// Create a subview which is the "images directory"

//let controller = CameraViewControllerTest(nibName: "ViewController", bundle: NSBundle.mainBundle())

class AccelPipView: BasePipView, NSURLConnectionDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    // for image pip
    var photoImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    var textLayer = CATextLayer()
    
    var colorBlock = UIImageView(frame: CGRectMake(10, 220, 100, 100))
    
    // move to model
    var x: CGFloat?
    var y: CGFloat?
    var z: CGFloat?
    
    var motionManager = CMMotionManager()
    var accelValue: Bool = true
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "mathPip-image")!, id: id)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
        
        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
        
        startAccelerometer(accelValue)
        
        // text layer
        self.textLayer.frame = CGRectMake(0, 0, self.photoImageView.bounds.width, self.photoImageView.bounds.height)
        
        let fontName: CFStringRef = "Helvetica"
        self.textLayer.font = CTFontCreateWithName(fontName, 4, nil)
        
        self.textLayer.foregroundColor = UIColor.blackColor().CGColor
        self.textLayer.wrapped = true
        self.textLayer.alignmentMode = kCAAlignmentCenter
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        
        
        self.colorBlock.backgroundColor = UIColor.brownColor()
        
        self.addSubview(self.photoImageView)
        self.addSubview(self.colorBlock)
        
        self.photoImageView.layer.addSublayer(self.textLayer)
        
    }
    
    func startAccelerometer(val: Bool){
        if val == true{
            println("accelerometer starting")
            if motionManager.accelerometerAvailable{
                println("inside motion manager")
                let motionQueue = NSOperationQueue.currentQueue()
                motionManager.deviceMotionUpdateInterval = 0.05
                motionManager.startDeviceMotionUpdatesToQueue(motionQueue,
                    withHandler: gravityUpdated)
            } else{
                println("accelerometer not available")
            }
        } else{
            println("start Accelerometer False")
            println("accelerometer stopping")
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func gravityUpdated(motion: CMDeviceMotion!, error: NSError!) {
        
        if (accelValue == true){
        
        let grav : CMAcceleration = motion.gravity;
        
        let x = CGFloat(grav.x);
        let y = CGFloat(grav.y);
        
        var v = CGVectorMake(x, y);
        
        self.x = CGFloat(grav.x)
        self.y = CGFloat(grav.y)
        self.z = CGFloat(grav.z)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.minimumFractionDigits = 3
        numberFormatter.maximumFractionDigits = 3
        let sx = numberFormatter.stringFromNumber(self.x!)
        let sy = numberFormatter.stringFromNumber(self.y!)
        let sz = numberFormatter.stringFromNumber(self.z!)
        
        self.textLayer.string = sx! + " " + sy! + " " + sz!
        var r = self.z!*2
        var g = self.x!*2
        var b = self.y!*2
        
        self.colorBlock.backgroundColor = UIColor(red:r, green:g,blue:b,alpha:1.0)
        
//        println(self.x)
//        println(self.y)
//        println(self.z)
        } else{
            println("ACCEL NOT AVAILABLE IN GRAVITY")
        }
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // accessors
    override func getModel() -> BasePip {
        return _mainPipDirectory.getPipByID(pipId).model
    }
    
    
    override func updateView(){
        println ("updating imageView")
        let output = (getModel() as? AccelPip)?.getOutput()
        
        // text
        if (output?.getText() != nil){
            println("text > accel: N/A")
        }
        
        
        // get switch signal
        if (output?.getSwitch() != nil){
            if (output?.getSwitch() == true){
                // turn on
            } else{
                println("switch > accel: false")
                // turn off
            }
        }
        
        (getModel() as? AccelPip)?.updateReliantPips()
    }
    
    
}
