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
	case Delete = "PipSamples/01_deletionSounds/char01A"
	case Handshake = "PipSamples/02_handshakeSounds/char01A"
	case Move = "PipSamples/02_handshakeSounds/char02C"
}

class AudioControllerDelegate {
	
	var clips: [AudioClips : AVAudioPlayer] = [:]
	
	init() {
		
	}
	
	func playSound(clip: AudioClips){
		
		if clips[clip] != nil {
			let clipToPlay = clips[clip]
			clipToPlay!.play()
		}else{
		
			var soundClip = AVAudioPlayer()
			soundClip = self.setupAudioPlayerWithFile(clip.rawValue, type: "wav")
			clips[clip] = soundClip
			soundClip.prepareToPlay()
			
			soundClip.play()
		}
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