//
//  SoundTestViewController.swift
//  Toot
//
//  Created by Keaton Burleson on 8/28/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer


public class SoundTest: Test {
    let services = Services()
    
    /**
     MARK: Override Functions
     **/

    override func startTests() {
        setVolumeToMax()
        speakerTest()
    }

    override init(inViewController: UIViewController) {
        super.init(inViewController: inViewController)
        self.type = .Sound
    }
    
    func nextTest() {
        self.headphoneTest()
    }

    func testsComplete() {
        if self.testData?.speakerPass == false || self.testData?.headphonePass == false {
            self.testFail()
        } else {
            self.testSuccess()
        }
    }

    /**
     MARK: Tests
     **/

    func speakerTest() {
        playAudio()
        self.displayPrompt(body: "Did the audio play?", title: "Question", yesText: "Yes", noText: "No", brokenState: false) {
            if self.successful || self.debugMode == true {
                self.nextTest()
            } else {
                self.speakerTestFailed()
            }
        }
    }

    func headphoneTest() {
        if services.headphonesConnected() == true {
            playAudio()
            displayPrompt(body: "Did the audio play?", title: "Question", yesText: "Yes", noText: "No", brokenState: false, completion: {
                if self.successful == true || self.debugMode == true {
                    self.testsComplete()
                } else {
                    self.headphoneTestFailed()
                }
            })

        } else {
            displayPrompt(body: "Please plug in headphones", title: "Message", yesText: "Retry", noText: "It is not working", brokenState: false, completion: {
                if self.successful == true || self.debugMode == true {
                    self.headphoneTest()
                } else {
                    self.headphoneTestFailed()
                }
            })
        }

    }
    /**
     MARK: Failed Test Setters
     **/

    func speakerTestFailed() {
        guard let test = self.testData
            else {
                return
        }
        test.speakerPass = false
    }

    func headphoneTestFailed() {
        guard let test = self.testData
            else {
                return
        }
        test.headphonePass = false
        self.testsComplete()
    }



    /**
    MARK: Test Specific Functions
    **/

    func playAudio() {
        AudioServicesPlaySystemSound(1103)
    }

    @objc func setVolumeToMax() {
        (MPVolumeView().subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as? UISlider)?.setValue(100, animated: false)
    }
}

