
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
    var photoImageView = UIImageView(frame: CGRect(x: 40, y: 120, width: 200, height: 200))
    var textLayer = CATextLayer()
    
    var colorBlock = UIImageView(frame: CGRect(x: 10, y: 220, width: 100, height: 100))
    
    // move to model
    var x: CGFloat?
    var y: CGFloat?
    var z: CGFloat?
    
    var arrayX: [CGFloat] = []
    var arrayY: [CGFloat] = []
    var arrayZ: [CGFloat] = []
    
    var sx: NSString?
    var sy: NSString?
    var sz: NSString?
    
    var motionManager = CMMotionManager()
    var accelValue: Bool = true
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Accel), id: id)
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + 120, height: self.frame.height)
        
//        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
//        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
        

        startAccelerometer(accelValue)
        
        // text layer
        self.textLayer.frame = CGRect(x: 0, y: 0, width: self.photoImageView.bounds.width, height: self.photoImageView.bounds.height)
        
        let fontName: CFString = "Helvetica" as CFString
        self.textLayer.font = CTFontCreateWithName(fontName, 4, nil)
        
        self.textLayer.foregroundColor = UIColor.black.cgColor
        self.textLayer.isWrapped = true
        self.textLayer.alignmentMode = kCAAlignmentCenter
        self.textLayer.contentsScale = UIScreen.main.scale
        
        
        self.colorBlock.backgroundColor = UIColor.brown
        
        self.addSubview(self.photoImageView)
        
//        self.photoImageView.layer.addSublayer(self.textLayer)
        self.arrayX = [0.0]
        self.arrayY = [0.0]
        self.arrayZ = [0.0]
        
    }
    
    // this is called when the AccelPipView is instantiated
    // input: true and false
    
    // handler calls gravityUpdated
	
	// startAccelerometer: Bool -> nil
	// I/O: checks to see if the accelerometer is available
	
    func startAccelerometer(_ val: Bool){
        if val == true{
            print("accelerometer starting")
            if motionManager.isAccelerometerAvailable{
                print("inside motion manager")
                let motionQueue = OperationQueue.current
                motionManager.deviceMotionUpdateInterval = 0.05
                motionManager.startDeviceMotionUpdates(to: motionQueue!,
                    withHandler: gravityUpdated as! CMDeviceMotionHandler)
            } else{
                print("accelerometer not available")
            }
        } else{
            print("start Accelerometer False")
            print("accelerometer stopping")
            motionManager.stopAccelerometerUpdates()
        }
    }
	
	
    
    // this fn is called in startAccelerometer and collects accel data and populates textLayer with it
    func gravityUpdated(_ motion: CMDeviceMotion!, error: NSError!) {
        
        if (accelValue == true){
        
        let grav : CMAcceleration = motion.gravity;
        
        let x = CGFloat(grav.x);
        let y = CGFloat(grav.y);
        
        var v = CGVector(dx: x, dy: y);
        
        self.x = CGFloat(grav.x)
        self.y = CGFloat(grav.y)
        self.z = CGFloat(grav.z)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 3
        numberFormatter.maximumFractionDigits = 3
        let sx = numberFormatter.string(from: NSNumber(value: Int(self.x!)))
        let sy = numberFormatter.string(from: NSNumber(value: Int(self.y!)))
        let sz = numberFormatter.string(from: NSNumber(value: Int(self.z!)))
        
        self.textLayer.string = sx! + " " + sy! + " " + sz!
        var r = self.z!*2
        var g = self.x!*2
        var b = self.y!*2
            
        self.arrayX.append(self.x!)
        self.arrayY.append(self.y!)
        self.arrayZ.append(self.z!)
        
            // make it so that this is only being updated when the view is present
        self.colorBlock.backgroundColor = UIColor(red:r, green:g,blue:b,alpha:1.0)
        
            
        // TO DO : HAVE CODE HERE THAT CHECKS WHETHER THIS ACCEL PIP GOES INTO A TEXT PIP
        // AND POPULATE THE TEXT PIP WITH SX, SY, SZ INFORMATION
            // textPipCast = inputPip as? TextPip
            // textPipCast.setText(SX, SY, SZ)
            
            
//        println(self.x)
//        println(self.y)
//        println(self.z)
        } else{
            print("ACCEL NOT AVAILABLE IN GRAVITY")
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
        print("updating imageView")
        let output = (getModel() as? AccelPip)?.getOutput()
        
        // text
//        if (output?.getText() != nil){
//            println("text > accel: N/A")
//        }
        
        // color- if present
//        if (output?.getColor() != nil){
//            println("color > accel: N/A")
////            self.addSubview(self.colorBlock)
//        }
        
        
        // get switch signal
//        if (output?.getSwitch() != nil){
//            if (output?.getSwitch() == true){
//                // turn on
//            } else{
//                println("switch > accel: false")
//                // turn off
//            }
//        }
        
        (getModel() as? AccelPip)?.updateReliantPips()
    }
    
    
}
