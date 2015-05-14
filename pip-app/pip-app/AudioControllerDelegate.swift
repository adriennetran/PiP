//
//  AudioControllerDelegate.swift
//  pip-app
//
//  Created by Peter Slattery on 5/14/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var _audioController: AudioControllerDelegate = AudioControllerDelegate()

enum AudioClips: String {
	case Delete = "char01A.wav"
}

class AudioControllerDelegate {
	
	init() {
		
	}
	
	func playSound(clip: AudioClips){
		var soundClip = AVAudioPlayer()
		soundClip = self.setupAudioPlayerWithFile(clip.rawValue, type: "wav")
		soundClip.play()
	}
	
	func setupAudioPlayerWithFile(file: String, type: String) -> AVAudioPlayer {
		var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
		var url = NSURL.fileURLWithPath(path!)
		
		var error: NSError?
		
		var audioPlayer:AVAudioPlayer?
		audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
		
		return audioPlayer!
	}
}