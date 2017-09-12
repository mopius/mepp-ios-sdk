//
//  AppDelegate.swift
//  MeppSDK-Demo-Swift
//
//  Created by Patrick Steiner on 22.09.16.
//  Copyright © 2016 Mopius. All rights reserved.

import UIKit
import CoreLocation
import MeppSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var deviceStatusManager: MeppDeviceStatusManager?
    private var meppApiClient: MeppAPIClient?
    private var sessionManager: MeppSessionManager?
    private var meppManager: MeppManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupMepp()
        
        return true
    }
    
    private func setupMepp() {
        MeppSDK.setAppToken("A1B2C3D4", forHost: "api.mepp.at", completion: {(successful) in
            if successful {
                Log.debug("MEPP SDK setup done")
                self.meppApiClient = MeppAPIClient()
                
                self.meppManager = MeppManager(delegate: self)
                self.meppManager?.startMonitoring()
                
                self.meppApiClient?.nearestPlaces(latitude: 200, longitude: 200, limit: 0, completion: { (success, places, statusCode) in
                    print(places ?? "")
                })
                self.meppApiClient?.notificationDisplayed(contentId: "14")
                self.meppApiClient?.notificationClicked(contentId: "14")
            }
        })
    }
}

extension AppDelegate : MeppManagerDelegate{
    func didFindContent(_ content: Content){
        Log.debug("NEW CONTENT: \(content.description)")
    }
    func didChangeStatus(_ status: String, critical: Bool){
        Log.debug("STATUS: \(status)")
    }
    func geofencesDidChange(locations: [GeoLocation]){
        Log.debug("GEOFENCES DID CHANGE")
    }
    func didDiscoverBeacons(_ beacons: [CLBeacon]){
        // Log.debug("BEACONS DISCOVERED")
    }
    func shouldTrackAnalyticsEvent(_ event: AnalyticsEvent){
        Log.debug("ANALYTICS: \(event.description)")
    }
}

