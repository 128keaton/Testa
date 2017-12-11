//
//  CameraTestViewController.swift
//  Toot
//
//  Created by Keaton Burleson on 8/28/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class CameraTest: Test {
    private var captureSession: AVCaptureSession?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    private var mode: CameraMode = .rear

    override init(inViewController: UIViewController) {
        super.init(inViewController: inViewController)
        self.type = .Camera
    }

    
    override func startTests() {
        switchCamera()
        setInstructionalText(message: "Rear Camera")
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(toggleMode), userInfo: nil, repeats: true)
    }
    
    /**
     MARK: Failed Test Setters
     **/

    func cameraTestFailed() {
        guard let test = self.testData
            else {
                return
        }
        test.cameraPass = false
        testFail()
    }

    /**
     MARK: Test Specific Functions
     **/
    
    // Starts the Camera testing.
    private func startCameraTest() {
        if previewView != nil{
            previewView?.layer.addSublayer(cameraPreviewLayer!)
            captureSession?.startRunning()
        }else{
            fatalError("previewView must be passed")
        }
    }
    
    // Finishes the camera testing
    public func finishCameraTest(){
        displayPrompt(body: "Did both cameras work?") {
            if self.successful || self.debugMode{
                self.testSuccess()
            }else{
                self.cameraTestFailed()
            }
        }
    }
    
    
    // Flips the camera to either front or back
    func switchCamera() {
        cameraPreviewLayer?.removeFromSuperlayer()
        cameraPreviewLayer = nil
        var captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if mode == .frontFacing {
            var devices: [AVCaptureDevice]? = nil
            if #available(iOS 10.0, *) {
                let discoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front)
                devices = discoverySession.devices
            } else {
               devices = AVCaptureDevice.devices(for: AVMediaType.video)
            }
            
            for device in devices!{
                if device.position == .front{
                    captureDevice = device
                }
            }
           
            setInstructionalText(message: "Front Camera")
        } else {
            setInstructionalText(message: "Rear Camera")
        }

        do {
            // Capture device should only be nil whenever you are testing on a computer without a webcam.
            if captureDevice != nil {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
            }

        } catch {
            print(error)
            testFail()
        }
        
        if captureSession != nil {
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer?.frame = (previewView?.layer.bounds)!

            startCameraTest()
        }

    }

    // Toggles the camera mode from front facing to rear facing or vice versa
    @objc func toggleMode() {
        if mode == .frontFacing {
            mode = .rear
        } else {
            mode = .frontFacing
        }
        switchCamera()
    }

}
enum CameraMode: Int {
    case frontFacing = 1
    case rear = 0
}
