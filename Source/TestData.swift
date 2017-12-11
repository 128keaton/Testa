//
//  TestData.swift
//  Toot
//
//  Created by Keaton Burleson on 8/29/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation


public class TestData: NSObject {
    public var cameraPass: Bool = true
    public var screenCracked: Bool = false
    public var headphonePass: Bool = true
    public var speakerPass: Bool = true
    public var lockButtonPass: Bool = true
    public var volumeButtonPass: Bool = true
    public var micTestPass: Bool = true
    public var screenGrade: ScreenGrade = .perfect
    public var cellular: Bool = false
    public var iOSVersion: String = "1.0"
    public var model: String = "iPhone 1,0"

    public func getFailedTests() -> [String: String] {
        var failedTests: [String: String] = [:]
        if self.cameraPass == false {
            failedTests["Camera Test"] = "One or both cameras failed to operate"
        }
        if self.iOSVersion == "" {
            failedTests["iOS Version"] = "iOS Version too low"
        }
        if self.speakerPass == false {
            failedTests["Speaker Test"] = "Audio failed to play through the speaker"
        }
        if self.headphonePass == false {
            failedTests["Headphone Test"] = "Audio failed to play through the headphones"
        }
        if self.micTestPass == false {
            failedTests["Microphone Test"] = "Microphone failed to detect audio"
        }
        if self.screenCracked == true {
            failedTests["Screen Cracked"] = "The Screen is cracked"
        }
        return failedTests
    }

    public func getPassedTests() -> [String: String] {
        var passedTests: [String: String] = [:]
        if self.cameraPass != false {
            passedTests["Camera Test"] = "Both cameras operated normally"
        }
        if self.iOSVersion != "" {
            passedTests["iOS Version"] = "iOS Version above minimum"
        }
        if self.speakerPass != false {
            passedTests["Speaker Test"] = "Audio played through the speaker"
        }
        if self.headphonePass != false {
            passedTests["Headphone Test"] = "Audio played through the headphones"
        }


        return passedTests
    }

    public func getCellularCapacity() -> String! {
        if self.cellular == true {
            return "Yes"
        }
        return "No"
    }

    public func didFail() -> Bool {
        if self.getFailedTests().keys.count == 0 {
            return false
        }
        return true
    }
}
public enum ScreenGrade: Int {
    case perfect = 0
    case fair = 1
    case poor = 2
}

