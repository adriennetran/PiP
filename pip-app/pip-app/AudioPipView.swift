
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
    
    var photoImageView = UIImageView(frame: CGRect(x: 40, y: 120, width: 200, height: 200))
    
    var textView = UIView(frame: CGRect(x: 40, y: 120, width: 200, height: 200))
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: _mainPipDirectory.getImageForPipType(.Audio), id: id)
        
        photoImageView.frame = CGRect(x: (self.frame.width / 2) - 35, y: 32, width: 70, height: 68)
		
        let fontName: CFString = "Helvetica" as CFString
		
		let buttonRadius: CGFloat = 31.0
		
		let interactButton = UIButton(frame: CGRect(x: 15.0, y: 20.0, width: CGFloat(buttonRadius * 2), height: CGFloat(buttonRadius * 2)))
		interactButton.backgroundColor = UIColor.red
		interactButton.addTarget(self, action: #selector(self.startRecordingAudio(_:)), for: .touchUpInside)
		
		interactButton.layer.cornerRadius = buttonRadius

		addSubview(interactButton)
		
        self.addSubview(self.photoImageView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.startRecordingAudio(_:))))
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRecordingAudio(_ tap: UITapGestureRecognizer) {
        
        let audioRecordingURL = self.audioRecordingPath() as URL
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioRecordingURL,
                                                settings: audioRecordingSettings() as! [String : Any])
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
        
    }
    
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    
    func audioRecordingPath() -> NSURL{
        let fileManager = FileManager.default
        
        let documentsFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsFolderURL[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("Recording.m4a")
        print(soundURL!)
        return soundURL as NSURL!
    }
    
    func audioRecordingSettings() -> NSDictionary{
        // Prepare audio recorder options
        return[
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            print("Successfully stopped the audio recording process")
            
            // lets try to retrieve data for recorded file
            
            let audioRecordingURL = self.audioRecordingPath() as URL
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioRecordingURL)
                guard let audioPlayer = audioPlayer else { return }
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error as NSError {
                print(error.description)
            }
            
        } else{
            print("stopping the audio recording failed")
        }
        audioRecorder = nil
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag{
            print("audio player stopped correctly")

        } else{
            print("audio player did not stop correctyl")
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
        print("updating audio View")
        let output = (getModel() as? AudioPip)?.getOutput()
        
        // color
        if (output?.getColor() != nil){
            print(output?.getColor())
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
                print("switch > audio: true")
//                self.blackLayer.opacity = 0.5
            } else{
                print("switch > audio: false")
//                self.blackLayer.opacity = 0.1
            }
        }
        
        // accel
        if (output?.getAccel() == true){
            print("accel > audio: true")
            //            if (output?.getImage() != nil){
            if (self.photoImageView.image != nil){
//                var blurredImage = self.applyBlurEffect(photoImageView.image!)
//                self.photoImageView.image = blurredImage
            }
        }
        
        (getModel() as? AudioPip)?.updateReliantPips()
    }
    
    
}
