
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
import AVFoundation

// Create a subview which is the "images directory"

//let controller = CameraViewControllerTest(nibName: "ViewController", bundle: NSBundle.mainBundle())

//protocol PhotoLibraryDelegate {
//    func capture()
//}

class AudioPipView: BasePipView, NSURLConnectionDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    // main changer
    // inherits photoImageView: UIImageView from BasePip
    
    var photoImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
    var textView = UIView(frame: CGRectMake(40, 120, 200, 200))
    
//    var blurImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200))
    
//    var blackLayer = CALayer()
//    var colorLayer = CALayer()
    var redButtonLayer = CAShapeLayer()
    var textLayer = CATextLayer()
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "soundPip-image")!, id: id)
        
        photoImageView.frame = CGRectMake((self.frame.width / 2) - 35, 32, 70, 68)
//        photoImageView.layer.cornerRadius = 15
//        photoImageView.layer.masksToBounds = true
        
        
//        textView.frame = photoImageView.frame
//        
//        //        self.photoImageView.alpha = 1.0
//        
//        photoImageView.backgroundColor = UIColor.redColor()
//        addSubview(photoImageView)
//        
////        photoImageView.contentMode = UIViewContentMode.ScaleAspectFill
//        
//        textLayer.frame = CGRectMake(0, 0, photoImageView.bounds.width, photoImageView.bounds.height)
//        textLayer.font = CTFontCreateWithName("Helvetica", 12, nil)
////        textLayer.wrapped = true
////        textLayer.alignmentMode = kCAAlignmentCenter
////        textLayer.contentsScale = UIScreen.mainScreen().scale
//        textLayer.string = "Recording..."
        
        // text layer
        self.textLayer.frame = CGRectMake(0, 0, self.photoImageView.bounds.width, self.photoImageView.bounds.height)
        
        let fontName: CFStringRef = "Helvetica"
        self.textLayer.font = CTFontCreateWithName(fontName, 1, nil)
        
        self.textLayer.foregroundColor = UIColor.blackColor().CGColor
        self.textLayer.wrapped = true
        self.textLayer.alignmentMode = kCAAlignmentCenter
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        
        
        let radius: CGFloat = 23.0
        self.redButtonLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)  , cornerRadius: radius).CGPath
        self.redButtonLayer.position = CGPoint(x: CGRectGetMidX(self.frame) - 286 , y: CGRectGetMidY(self.frame) - 300 )
        self.redButtonLayer.fillColor = UIColor.redColor().CGColor
        
//        self.redButtonLayer.backgroundColor = UIColor.redColor().CGColor
//        self.redButtonLayer.cornerRadius = 40.0
//        self.redButtonLayer.frame = CGRectMake((self.frame.width / 2) - 35, 32, 20, 20)
        
        
        self.addSubview(self.photoImageView)
        
        self.photoImageView.layer.addSublayer(self.textLayer)
        self.photoImageView.layer.addSublayer(self.redButtonLayer)

       
        
//        addGestureRecognizer(UITapGestureRecognizer(target: _mainPipDirectory.viewController, action: "capture:"))
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "startRecordingAudio:"))
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRecordingAudio(tap: UITapGestureRecognizer) {
        var error: NSError?
        
        let audioRecordingURL = self.audioRecordingPath()
        audioRecorder = AVAudioRecorder(URL: audioRecordingURL, settings: audioRecordingSettings() as [NSObject : AnyObject], error: &error)
        
        if let recorder = audioRecorder{
            recorder.delegate = self
            
            // Prepare recorder and then start recording
            if recorder.prepareToRecord() && recorder.record(){
                println("Successfully started to record")

                self.textLayer.string = "Recording!"
                
                // Stop recording after 5 seconds
                let delayInSeconds = 5.0
                let delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), {
                    [weak self] in self!.audioRecorder!.stop()
                })
            } else{
                println("Failed to record")
                audioRecorder = nil
            }
        } else{
            println("Failed to create instance of the audio recorder")
        }
        
        
    }
    
    func audioRecordingPath() -> NSURL{
        let fileManager = NSFileManager()
        
        let documentsFolderURL = fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
        
        return documentsFolderURL!.URLByAppendingPathComponent("Recording.m4a")
    }
    
    func audioRecordingSettings() -> NSDictionary{
        // Prepare audio recorder options
        return[
            AVFormatIDKey: kAudioFormatMPEG4AAC as NSNumber,
            AVSampleRateKey: 16000.0 as NSNumber,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.Low.rawValue as NSNumber
        ]
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
            println("Successfully stopped the audio recording process")
            self.textLayer.string = "Finished recording"
            
            // lets try to retrieve data for recorded file
            var playbackError: NSError?
            var readingError: NSError?
            
            let fileData = NSData(contentsOfURL: audioRecordingPath(),
                options: .MappedRead,
                error: &readingError)
            
            // form an audio player and make it play recorded data
            audioPlayer = AVAudioPlayer(data: fileData, error: &playbackError)
            
            // instantiate audio player
            if let player = audioPlayer{
                player.delegate = self
                
                // prepare to play and start playing
                if player.prepareToPlay() && player.play(){
                    println("Started playing recorded audio")
                    self.textLayer.string = "Playing audio"
                } else{
                    println("Could not play recorded audio")
                }
            } else{
                println("failed to create audio player")
            }
            
        } else{
            println("stopping the audio recording failed")
        }
        self.audioRecorder = nil
    }
    
    func audioRecorderDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool){
        if flag{
            println("audio player stopped correctly")
            self.textLayer.string = "Done playing audio!"
        } else{
            println("audio player did not stop correctyl")
        }
        audioPlayer = nil
        self.textLayer.string = ""
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
//            self.colorLayer.backgroundColor = (output?.getColor())!.CGColor
//            self.colorLayer.opacity = 0.2
        }
        
        // text
        if (output?.getText() != nil){
//            self.textLayer.string = output?.getText()
        }
        
        
        // get switch signal
        if (output?.getSwitch() != nil){
            if (output?.getSwitch() == true){
                // update black
                println("switch > audio: true")
//                self.blackLayer.opacity = 0.5
            } else{
                println("switch > audio: false")
//                self.blackLayer.opacity = 0.1
            }
        }
        
        // accel
        if (output?.getAccel() == true){
            println("accel > audio: true")
            //            if (output?.getImage() != nil){
            if (self.photoImageView.image != nil){
//                var blurredImage = self.applyBlurEffect(photoImageView.image!)
//                self.photoImageView.image = blurredImage
            }
        }
        
        (getModel() as? AudioPip)?.updateReliantPips()
    }
    
    
}
