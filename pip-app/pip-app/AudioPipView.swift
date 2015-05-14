
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
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Audio), id: id)
        
        photoImageView.frame = CGRectMake((self.frame.width / 2) - 35, 32, 70, 68)
		
        let fontName: CFStringRef = "Helvetica"
		
		var buttonRadius: CGFloat = 31.0
		
		var interactButton = UIButton(frame: CGRectMake(15.0, 20.0, CGFloat(buttonRadius * 2), CGFloat(buttonRadius * 2)))
		interactButton.backgroundColor = UIColor.redColor()
		interactButton.addTarget(self, action: "startRecordingAudio:", forControlEvents: nil)
		
		interactButton.layer.cornerRadius = buttonRadius

		addSubview(interactButton)
		
        self.addSubview(self.photoImageView)
        
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

        } else{
            println("audio player did not stop correctyl")
        }
        audioPlayer = nil
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
