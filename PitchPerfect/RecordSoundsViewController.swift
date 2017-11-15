//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Zachary Rose on 11/15/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    // Sets the variable for AV
    var audioRecorder: AVAudioRecorder!

    
    // MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    // Function to handle changing state of recording buttons
    func configureRecordingActions(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
    
    // Function to handle the recording of Audio
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        configureRecordingActions(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // Function to stop the recording
    @IBAction func stopRecording(_ sender: Any) {
        
        configureRecordingActions(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false) 
    }
    
    
    // Function to send audio recording to PlaySoundsViewController
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    
    // MARK: Prepare new VC with audio
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

