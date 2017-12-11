//
//  Services.swift
//  Testa
//
//  Created by Keaton Burleson on 12/1/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import AVFoundation

public class Services {
    public func headphonesConnected() -> Bool {
        let route = AVAudioSession.sharedInstance().currentRoute

        for desc in route.outputs {
            if desc.portType == AVAudioSessionPortHeadphones {
                return true
            }
        }
        return false
    }
    
    public func deviceModel() -> String{
        if UIDevice.current.responds(to: #selector(getter: UIDevice.model)){
            let deviceModel = UIDevice.current.model
            return deviceModel
        }else{
            return "No model"
        }
    }
}
