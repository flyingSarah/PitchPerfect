//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sarah Howe on 5/11/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgressLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        //hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgressLabel.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton)
    {
        recordingInProgressLabel.text = "Recording in Progress"
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as! String
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if(flag)
        {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            stopButton.hidden = true
            recordButton.enabled = true
            recordingInProgressLabel.text = "Recording failed. Tap to try again."
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        if(segue.identifier == "stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton)
    {
        recordingInProgressLabel.text = "Tap to Record"
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

