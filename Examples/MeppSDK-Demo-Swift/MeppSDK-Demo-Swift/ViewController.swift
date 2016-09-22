//
//  ViewController.swift
//  MeppSDK-Demo-Swift
//
//  Created by Patrick Steiner on 22.09.16.
//  Copyright © 2016 Mopius. All rights reserved.
//

import UIKit
import MeppSDK

class ViewController: UIViewController {
    
    var meppAPIClient: MeppAPIClient?
    var meppDeviceStatusManager: MeppDeviceStatusManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MEPP Reachability
        meppDeviceStatusManager = MeppDeviceStatusManager()
        meppDeviceStatusManager?.delegate = self
        
        // MEPP API Client
        meppAPIClient = MeppAPIClient()
        getAppConfig()
        fetchContentById(1)
        fetchContentByHardware("D33255DF-8AFD-4A52-99A2-C7DD8E42583F", major: "1", minor: "2")
    }
    
    private func getAppConfig() {
        meppAPIClient?.appConfig({ (successful, appConfig) in
            if successful {
                if let config = appConfig {
                    print("app config min sdk version: \(config.minSDK)")
                    print("app config maximum session time: \(config.maxSessionTime)")
                }
            }
        })
    }
    
    private func fetchContentById(id: Int) {
        meppAPIClient?.contentById(id, user: "swift-client", completion: { (successful, content) in
            if successful {
                print("content name: \(content?.textRecord?.name)")
            }
        })
    }
    
    private func fetchContentByHardware(uuid: String, major: String, minor: String) {
        let beacon = Beacon()
        beacon.uuid = uuid
        beacon.major = major
        beacon.minor = minor
        
        meppAPIClient?.contentByHardware(beacon, user: "swift-client", completion: { (successful, entryContent, exitContent) in
            if successful {
                if let entryContent = entryContent {
                    print ("entry content: \(entryContent.textRecord?.name)")
                }
                
                if let exitContent = exitContent {
                    print ("exit content: \(exitContent.textRecord?.name)")
                }
            }
        })
    }
}

extension ViewController: MeppDeviceStatusManagerDelegate {
    func didChangeReachability(reachabilityStatus: ReachableStatus) {
        print("network reachability status changed")
    }
    
    func didChangeLocationAuthorization(status: LocationStatus) {
        print("location authorization status changed")
    }
    
    func didChangeBluetoothStatus(status: BluetoothStatus) {
        print("bluetooth status changed")
    }
}

