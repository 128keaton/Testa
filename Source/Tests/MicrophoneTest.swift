//
//  MicrophoneTestViewController.swift
//  Testà
//
//  Created by Keaton Burleson on 10/23/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class MicrophoneTest: Test {
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder!
    private var levelTimer = Timer()
    private var lowPassResults: Double = 0.0

    
    override init(inViewController: UIViewController) {
        super.init(inViewController: inViewController)
        self.type = .Microphone
    }
    

    override func startTests() {
        prepareRecorder()
        startMicTest()
    }

    /**
     MARK: Failed Test Setters
     **/

    func micTestFailed() {
        guard let test = self.testData
            else {
                return
        }
        test.micTestPass = false
        self.testFail()
    }

    /**
     MARK: Test Specific Functions
     **/
    
    func startMicTest() {
        recorder.record()
        self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.levelTimerCallback), userInfo: nil, repeats: true)
    }

    func prepareRecorder() {
        let url: URL = URL(fileURLWithPath: "/dev/null")

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
        } catch _ {
            self.micTestFailed()
        }

        let settings = [
            AVSampleRateKey: 44100.0,
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ] as [String: Any]


        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
            self.micTestFailed()
        }

        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
    }

    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        print(recorder.averagePower(forChannel: 0))
        
        if recorder.averagePower(forChannel: 0) > -7 {
            recorder.stop()
            testSuccess()
        }
    }
}
