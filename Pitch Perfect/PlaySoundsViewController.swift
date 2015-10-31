//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sarah Howe on 5/13/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 8.0, *)
class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    func resetAllAudio()
    {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }

    
    @IBAction func stopAudio(sender: UIButton)
    {
        resetAllAudio()
    }
    
    @IBAction func playSlowAudio(sender: UIButton)
    {
        playAudioAtRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton)
    {
        playAudioAtRate(2.0)
    }
    
    func playAudioAtRate(rate: Float)
    {
        resetAllAudio()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton)
    {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        resetAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do
        {
            try audioEngine.start()
        }
        catch _ {
        }
        audioPlayerNode.play()
    }

    @IBAction func playDarthVaderAudio(sender: UIButton)
    {
        playAudioWithVariablePitch(-1000)
    }
}
