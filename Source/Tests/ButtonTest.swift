//
//  ButtonTestViewController.swift
//  Toot
//
//  Created by Keaton Burleson on 9/5/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class ButtonTest: Test {
    var buttonTries = 0
    var volumeMessage: UIAlertController? = nil
    
    /**
     MARK: Override Functions
     **/

    override init(inViewController: UIViewController) {
        super.init(inViewController: inViewController)
        self.type = .Button
    }
    
    func nextTest() {
        self.volumeButtonTest()
    }

    func testsComplete() {
        if self.testData?.volumeButtonPass == false || self.testData?.lockButtonPass == false {
            self.testFail()
        } else {
            self.testSuccess()
        }
    }

    /**
     MARK: Tests
     **/

    override func startTests() {
        lockAndHomeButtonTest()
    }

    func lockAndHomeButtonTest() {
        self.displayPrompt(body: "Please press the home and power button at the same time", title: "Message", yesText: "Okay", noText: "No", brokenState: true, completion: {
            if self.successful == true || self.debugMode == true {
                self.nextTest()
            } else {
                self.lockAndHomeButtonTestFailed()
            }
        })
    }

    func volumeButtonTest() {
        self.buildButtonObserver()
        self.displayPrompt(body: "Please press the volume down button, then the volume up button", title: "Message", yesText: "Okay", noText: "No", brokenState: true, completion: {
            if self.successful == true || self.debugMode == true {
                self.testsComplete()
            } else {
                self.volumeButtonTestFailed()
            }
        })

    }

    /**
     MARK: Failed Test Setters
     **/

    func volumeButtonTestFailed() {
        self.testData?.volumeButtonPass = false
    }

    func lockAndHomeButtonTestFailed() {
        self.testData?.lockButtonPass = false
    }

    /**
     MARK: Test Specific Functions
     **/

    func buildScreenshotObserver() {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot,
                                               object: nil,
                                               queue: mainQueue,
                                               using: { notification in
                                                   self.dismissCurrentAlert()
                                                   self.nextTest()
                                               })
    }

    func buildButtonObserver() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch {
            self.testFail()
        }
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }

    func volumeButtonPressed() {
        if buttonTries < 1 {
            buttonTries = buttonTries + 1
        } else {
            self.testsComplete()
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            volumeButtonPressed()
        }
    }


}
