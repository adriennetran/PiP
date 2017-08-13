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

enum AudioClips: Int {
	case delete
	case handshake
	case move
}

class AudioControllerDelegate {
	
	var clips: [AudioClips : AVAudioPlayer] = [:]
	
	var clipPaths: [AudioClips: [String]] = [:]
	
	init() {
		
		clipPaths[.delete] = ["PipSamples/01_deletionSounds/0", "PipSamples/01_deletionSounds/1", "PipSamples/01_deletionSounds/2"]
		clipPaths[.handshake] = ["PipSamples/02_handshakeSounds/0", "PipSamples/02_handshakeSounds/1", "PipSamples/02_handshakeSounds/2"]
		clipPaths[.move] = ["PipSamples/03_moveSounds/0", "PipSamples/03_moveSounds/1", "PipSamples/03_moveSounds/2"]
		
		clips[.delete] = setupAudioPlayerWithFile(clipPaths[.delete]![0], type: "wav")
		clips[.delete]?.prepareToPlay()
		clips[.handshake] = setupAudioPlayerWithFile(clipPaths[.handshake]![0], type: "wav")
		clips[.handshake]?.prepareToPlay()
		clips[.move] = setupAudioPlayerWithFile(clipPaths[.move]![0], type: "wav")
		clips[.move]?.prepareToPlay()
		
	}
	
	func playSound(_ clip: AudioClips){
		
		if let clip: AVAudioPlayer = clips[clip] {
			clip.play()
		}else{
			var soundClip = AVAudioPlayer()
			soundClip = self.setupAudioPlayerWithFile(clipPaths[clip]![0], type: "wav")
			clips[clip] = soundClip
			soundClip.prepareToPlay()
			soundClip.play()
		}
		
		// TO DO: Make Audio Random
//		if let paths = clipPaths[clip]{
//			if paths.count > 0 {
//				let randIndex: Int = Int(arc4random_uniform(UInt32(paths.count)))
//			
//				if let clipArray: [AVAudioPlayer] = clips[clip]{
//					let numClips: Int = clipArray.count
//					let clipAt: AVAudioPlayer? = clipArray[randIndex]
//					
//					if numClips > randIndex && clipAt != nil {
//						let clipToPlay = clips[clip]?[randIndex]
//						clipToPlay!.play()
//					}
//				}else{
//					var soundClip = AVAudioPlayer()
//					soundClip = self.setupAudioPlayerWithFile(paths[randIndex], type: "wav")
//					clips[clip]?.insert(soundClip, atIndex: randIndex)
//					
//					soundClip.prepareToPlay()
//					soundClip.play()
//				}
//			}
//		}
	}
	
	func setupAudioPlayerWithFile(_ file: String, type: String) -> AVAudioPlayer {
		let path = Bundle.main.path(forResource: file, ofType: type)
		let url = URL(fileURLWithPath: path!)
			
		var audioPlayer:AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
        } catch let error as NSError {
            print(error.description)
        }
		
		return audioPlayer!
	}
}
