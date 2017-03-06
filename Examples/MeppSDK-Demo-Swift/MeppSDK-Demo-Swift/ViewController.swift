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
        meppDeviceStatusManager?.requestAlwaysLocationAuthorization()
        
        // MEPP API Client
        meppAPIClient = MeppAPIClient()
        getAppConfig()
        fetchContentById(id: 1)
        fetchContentByHardware(uuid: "D33255DF-8AFD-4A52-99A2-C7DD8E42583F", major: "1", minor: "2")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        meppDeviceStatusManager?.startReachabilityNotifier()
        meppDeviceStatusManager?.startLocationNotifier()
        meppDeviceStatusManager?.startBluetoothNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        meppDeviceStatusManager?.stopReachabilityNotifier()
    }
    
    private func getAppConfig() {
        meppAPIClient?.appConfig({ (successful, appConfig, statusCode) in
            if successful {
                if let config = appConfig {
                    print("app config min sdk version: \(config.minSDK)")
                    print("app config maximum session time: \(config.maxSessionTime)")
                }
            }
        })
    }
    
    private func fetchContentById(id: Int) {
        meppAPIClient?.contentById(id, user: "swift-client", completion: { (successful, content, statusCode) in
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
        
        meppAPIClient?.contentByHardwareBeacon(beacon, user: "swift-client", completion: { (successful, entryContent, exitContent, statusCode) in
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
    func didChangeReachability(_ reachabilityStatus: ReachableStatus) {
        print("network reachability status changed")
    }
    
    func didChangeLocationAuthorization(_ status: LocationStatus) {
        print("location authorization status changed")
    }
    
    func didChangeBluetoothStatus(_ status: BluetoothStatus) {
        print("bluetooth status changed")
    }
}

