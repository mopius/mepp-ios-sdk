//
//  AppDelegate.swift
//  MeppSDK-Demo-Swift
//
//  Created by Patrick Steiner on 22.09.16.
//  Copyright © 2016 Mopius. All rights reserved.
//

import UIKit
import MeppSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var meppBeaconManager: MeppBeaconManager?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        MeppSDK.setAppToken("A1B2C3D4", forHost: "example.com") { (successful) in
            if successful {
                // init beacon manager
                self.meppBeaconManager = MeppBeaconManager()
                self.meppBeaconManager!.delegate = self
                self.meppBeaconManager!.startMonitoring()
            }
        }
        
        return true
    }
}

extension AppDelegate: MeppBeaconManagerDelegate {
    func didFindNewContent(content: Content) {
        print("Did find content: \(content.contentType)")
    }
    
    func didChangeSessionStatus(status: String, critical: Bool) {
        print("Did change session status: \(status)")
    }
    
    func didDiscoverBeacons(beacons: [DiscoveredBeacon]) {
        // get discovered beacons
    }
}
