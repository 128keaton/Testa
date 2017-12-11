//
//  Testa.swift
//  Testa
//
//  Created by Keaton Burleson on 12/1/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation

public class Testa: NSObject, TestDelegate {
    /**
     Set this to true to enable the 'skip' button on tests
    **/
    public var debugMode = false

    public var testData: TestData? = nil

    public var instructionLabel: UILabel? = nil
    public var previewView: UIView? = nil
    
    public private(set) var currentTest: Test? = nil
    
    public private(set) var completedTests: [TestType] = []
    
    private var viewController: UIViewController? = nil

    weak var delegate: TestaDelegate?
    
    public init(inViewController: UIViewController, delegate: TestaDelegate) {
        self.viewController = inViewController
        self.delegate = delegate
    }

    public func startScreenTest() {
        if self.viewController != nil {
            self.currentTest = ScreenTest(inViewController: self.viewController!)
            setupTestAndStart()
        }
    }
    
    public func startCameraTest() {
        if self.viewController != nil {
            self.currentTest = CameraTest(inViewController: self.viewController!)
            setupTestAndStart()
        }
    }
    
    public func startSoundTest() {
        if self.viewController != nil {
            self.currentTest = SoundTest(inViewController: self.viewController!)
            setupTestAndStart()
        }
    }
    
    public func startMicrophoneTest() {
        if self.viewController != nil {
            self.currentTest = MicrophoneTest(inViewController: self.viewController!)
            setupTestAndStart()
        }
    }
    
    public func startButtonTest() {
        if self.viewController != nil {
            self.currentTest = ButtonTest(inViewController: self.viewController!)
            setupTestAndStart()
        }
    }
    
    public func finishTest(){
        if (self.currentTest?.type == .Camera){
            (currentTest as! CameraTest).finishCameraTest()
        }else{
            print("This test cannot be forced to finish")
        }
    }
    
    private func setupTestAndStart(){
        currentTest?.instructionLabel = self.instructionLabel
        currentTest?.previewView = self.previewView
        currentTest?.testData = self.testData
        currentTest?.delegate = self
        currentTest?.debugMode = self.debugMode
        
        currentTest?.setupView()
        currentTest?.startTests()
    }
    
    public func updateViewController(viewController: UIViewController){
        self.viewController = viewController
    }
    
    public func updateDelegate(delegate: TestaDelegate){
        self.delegate = delegate
    }
    
    public func setCurrentTest(test: TestType){
        // you really only wanna use this function for debugging.
        switch test {
        case .Screen:
            startScreenTest()
        case .Button:
            startButtonTest()
        case .Camera:
            startCameraTest()
        case .Microphone:
            startMicrophoneTest()
        case .Sound:
            startSoundTest()
        default:
            print("Whoops!")
        }
    }
    
    func testCompleted(test: TestType, data: TestData, failed: Bool) {
        self.completedTests.append(test)
        self.testData = data
        delegate?.testCompleted(failed: failed)
    }
    
}
public protocol TestaDelegate: NSObjectProtocol{
    func testCompleted(failed: Bool)
}
