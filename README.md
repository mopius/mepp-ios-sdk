# MEPP iOS SDK

- [Overview](#overview)
- [Installing iOS SDK](#installing-the-ios-sdk)
    - [CocoaPods](#cocoapods)
- [First Steps](#first-steps)
- [Interacting with Beacons](#interacting-with-beacons)
  - [Basic Setup](#basic-setup)
  - [Beacon Delegate Callbacks](#beacon-delegate-callbacks)
- [Communicating with the MEPP Rest API](#communicating-with-the-mepp-rest-api)
  - [MeppAPIClient](#meppapiclient)
    - [Get Application Configuration](#get-application-configuration)
    - [Get Content by ID](#get-content-by-id)
    - [Get Content by Hardware](#get-content-by-hardware)
- [Reachability](#reachability)
  - [Start and Stop Reachability Notification](#start-and-stop-reachability-notification)
  - [Reachability Delegate Callbacks](#reachability-delegate-callbacks)
- [Data Structure](#data-structure)
  - [AppConfig](#appconfig)
  - [Content](#content)
  - [MetaInfo](#metainfo)
  - [TextRecord](#textrecord)
  - [Beacon](#beacon)
- [Changelog](#changelog)

## Overview

This document shows you a quick way to start using the MEPP SDK in your apps.

## Installing the iOS SDK

To use the MEPP SDK in your project, the minimum deployment target must be iOS 8.0.

If your try to use this framework with an existing Swift project, make sure that you existing project uses Swift 2.3 (Legacy Swift). Swift >= 3.0 is currently not supported.

You have to set **Use Legacy Swift Language Version** to **Yes** in your existing or new Project.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

``` bash
$ gem install cocoapods
```

To integrate the MEPP SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

``` ruby
platform :ios, '8.0'
use_frameworks!

pod 'MeppSDK', :git => 'https://github.com/mopius/mepp-ios-sdk.git'

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
    end
  end
end
```

Then, run the following command:

``` bash
$ pod install
```

## First Steps

For your app to work correctly you have to add a new key to your project's plist file.

1.  In the project navigator, select your project.
2.  Select your projects **Info.plist** file
3.  Add the following key string pair to the file.

``` XML
<key>NSLocationAlwaysUsageDescription</key>
<string>Required for iOS >= 8 compatibilty</string>
```

The string can be empty, the content is not important.

Set the MEPP default properties.

**Swift**
``` Swift
import MeppSDK
```

**Objective-C**
``` Objective-C
@import MeppSDK;
```

**Swift**
``` Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  // Set API and Google Analytics Settings
  MeppSDK.setAppToken("A1B2C3D4", forHost: "example.com") { (successful) in
            // to something after MeppSDK is initialized
        }

	return true
}
```

**Objective-C**
``` Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MeppSDK setAppToken:@"A1B2C3D4" forHost:@"example.com" completion:^(BOOL successful) {
        // to something after MeppSDK is initialized
    }];

    return YES;
}
```

## Interacting with Beacons
In the following example we'll show you how to create a simple application to monitor beacons and get back content informations using the MEPP SDK.

### Basic Setup
In our example, we have used the **AppDelegate.swift** for simplicity. You would probably want to create your own class in a real application.

First we'll import the MEPP SDK.

**Swift**
``` Swift
import MeppSDK
```

**Objective-C**
``` Objective-C
@import MeppSDK;
```

We'll add the MeppBeaconManager object as a property.
MeppBeaconManager informs its delegates when a new content is available.

**Swift**
``` Swift
private var meppBeaconManager: MeppBeaconManager?
```

**Objective-C**
``` Objective-C
@property (readwrite, nonatomic, strong) MeppBeaconManager *beaconManager;
```

---

Make sure `AppDelegate` conforms to `MeppBeaconManagerDelegate` protocol.

---

We will use `application:didFinishLaunchingWithOptions:` to initiate the beacon manager and start the monitoring.
Make sure to only use the hostname, not the URL of the backend.

**Swift**
``` Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  // Set MeppSDK
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
```

**Objective-C**
``` Objective-C
[MeppSDK setAppToken:@"A1B2C3D4" forHost:@"example.com" completion:^(BOOL successful) {
        if (successful) {
            // init beacon manager
            self.beaconManager = [[MeppBeaconManager alloc] init];
            self.beaconManager.delegate = self;
            [self.beaconManager startMonitoring];
        }
    }];
```

### Beacon Delegate Callbacks

Now we'll add the delegate methods for the beacon manager.

**Swift**
``` Swift
extension AppDelegate: MeppBeaconManagerDelegate {
  func didFindNewContent(content: Content) {
        // new content
    }

    func didChangeSessionStatus(status: String, critical: Bool) {
        // get some session infos, for debugging purposes.
    }

    func didDiscoverBeacons(beacons: [DiscoveredBeacon]) {
        // get discovered beacons
    }

    func shouldTrackAnalyticsEvent(event: AnalyticsEvent) {
            // analytics tracking.
    }
}
```

**Objective-C**
``` Objective-C
- (void)didFindNewContent:(Content *)content {
    // new content
}

- (void)didChangeSessionStatus:(NSString *)status critical:(BOOL)critical {
    // get some session infos, for debugging purposes.
}

- (void)didDiscoverBeacons:(NSArray<DiscoveredBeacon *> *)beacons {
    // get discovered beacons
}

- (void)shouldTrackAnalyticsEvent:(AnalyticsEvent *)event {
    // analytics tracking.
}
```

## Communicating with the MEPP Rest API

The MEPP Rest API provides some resources to query/update our cloud platform.

The class responsible for communication with the API is MeppAPIClient.

You can initialize it by calling...

**Swift**
``` Swift
MeppAPIClient(appToken: "A1B1C3", apiHost: "example.com")
```

**Objective-C**
``` Objective-C
MeppAPIClient *apiClient = [[MeppAPIClient alloc] initWithAppToken:@"A1B1C3" apiHost:@"example.com"];
```

or

**Swift**
``` Swift
MeppAPIClient()
```

**Objective-C**
``` Objective-C
MeppAPIClient *apiClient = [[MeppAPIClient alloc] init];
```

if you had set the SDK properties before via `MeppSDK()`.

### MeppAPIClient

After initialization, the MeppAPIClient object acts as a facade between your app and the MEPP services. You can use it to get contents by id or hardware infos, application configurations and much more.

#### Get Application Configuration

**Swift**
``` Swift
meppAPIClient?.appConfig({ (successful, appConfig) in
            if successful {
                if let config = appConfig {
                    print("app config min sdk version: \(config.minSDK)")
                    print("app config maximum session time: \(config.maxSessionTime)")
                }
            }
        })
```

**Objective-C**
``` Objective-C
[apiClient appConfig:^(BOOL successful, AppConfig * _Nullable appConfig) {
        if (successful) {
            if (appConfig != nil) {
                NSLog(@"app config min sdk version: %@", appConfig.minSDK);
                NSLog(@"app config maximum session time: %@", appConfig.slcDistance);
            }
        }
    }];
```

#### Get Content by ID

**Swift**
``` Swift
meppAPIClient?.contentById(1, user: "swift-client", completion: { (successful, content) in
            if successful {
                print("content name: \(content?.textRecord?.name)")
            }
        })
```

**Objective-C**
``` Objective-C
[apiClient contentById:1 user:@"objc-client" completion:^(BOOL successful, Content * _Nullable content) {
        if (successful) {
            if (content.textRecord != nil) {
                TextRecord *textRecord = content.textRecord;

                if (textRecord.name != nil) {
                    NSLog(@"content name: %@", textRecord.name);
                }
            }
        }
    }];
```

### Get Content by Hardware

**Swift**
``` Swift
let beacon = Beacon()
        beacon.uuid = "D33255DF-8AFD-4A52-99A2-C7DD8E42583F"
        beacon.major = "1"
        beacon.minor = "2"

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
```

**Objective-C**
``` Objective-C
Beacon *beacon = [[Beacon alloc] init];
    beacon.uuid = @"D33255DF-8AFD-4A52-99A2-C7DD8E42583F";
    beacon.major = @"1";
    beacon.minor = @"2";

    [self.apiClient contentByHardware:beacon user:@"objc-client" completion:^(BOOL successful, Content * _Nullable entryContent, Content * _Nullable exitContent) {
        if (successful) {
            if (entryContent.textRecord != nil) {
                TextRecord *textRecord = entryContent.textRecord;

                if (textRecord.name != nil) {
                    NSLog(@"entry content name: %@", textRecord.name);
                }
            }
        }
    }];
```

## Reachability

The MEPP SDK also provides a class to get informations about the current Device status. You can monitor the network and API reachability. You can also monitor the bluetooth connection status of the device.

You can initialize it by calling...

**Swift**
``` Swift
MeppDeviceStatusManager()
```

**Objective-C**
``` Objective-C
[[MeppDeviceStatusManager alloc] init];
```

Also make sure that your class conforms to `MeppDeviceStatusManagerDelegate` protocol.

We will use `viewDidLoad` to initiate the device status manager.

**Swift**
``` Swift
meppDeviceStatusManager = MeppDeviceStatusManager()
meppDeviceStatusManager?.delegate = self
meppDeviceStatusManager?.requestAlwaysLocationAuthorization()
```

**Objective-C**
``` Objective-C
self.deviceStatusManager = [[MeppDeviceStatusManager alloc] init];
self.deviceStatusManager.delegate = self;
[self.deviceStatusManager requestAlwaysLocationAuthorization];
```

### Start and Stop Reachability Notification

We will use `viewWillAppear` to start the reachability notification.

**Swift**
``` Swift
meppDeviceStatusManager?.startReachabilityNotifier()
meppDeviceStatusManager?.startLocationNotifier()
meppDeviceStatusManager?.startBluetoothNotifier()
```

**Objective-C**
``` Objective-C
[self.deviceStatusManager startReachabilityNotifier];
[self.deviceStatusManager startLocationNotifier];
[self.deviceStatusManager startBluetoothNotifier];
```

We will use `viewWillDisappear` to stop the reachability notification.

**Swift**
``` Swift
meppDeviceStatusManager?.stopReachabilityNotifier()
```

**Objective-C**
``` Objective-C
[self.deviceStatusManager stopReachabilityNotifier];
```

### Reachability Delegate Callbacks

Now we'll add the delegate methods for the device status manager.

**Swift**
``` Swift
func didChangeReachability(reachabilityStatus: ReachableStatus) {
    print("network reachability status changed")
}

func didChangeLocationAuthorization(status: LocationStatus) {
    print("location authorization status changed")    
}

func didChangeBluetoothStatus(status: BluetoothStatus) {
  print("bluetooth status changed")
}
```

**Objective-C**
``` Objective-C
- (void)didChangeReachability:(enum ReachableStatus)reachabilityStatus {
    NSLog(@"network reachability status changed");
}

- (void)didChangeLocationAuthorization:(enum LocationStatus)status {
    NSLog(@"location authorization status changed");
}

- (void)didChangeBluetoothStatus:(enum BluetoothStatus)status {
    NSLog(@"bluetooth status changed");
}
```

## Data Structure

### AppConfig
 * **slcDistance: NSNumber?** The distance when a significant distance change should be initiated.
 * **minSDK: String?** The minimum allowed SDK version.
 * **maxSessionTime: NSNumber?** The maximum session time.

### Content
 * **contentId: NSNumber?** The internal content id. Use this to fetch content a by id.
 * **active: Bool?** Boolean if the content is active or not.
 * **contentType: String?** The type of the content (a.k.a use case).
 * **displayType: DisplayType?** The display type of the content. ["entry", "exit"]
 * **delayTime: NSNumber?** The delay after the content should be shown in seconds.
 * **coolDownTime: NSNumber?** The cooldown time in seconds after which the SDK notifies for a content again.
 * **activeDateStart: NSDate?** This indicates the date from which a content is active.
 * **activeDateStop: NSDate?** This indicates the date until a content is active.
 * **activeTimeStart: String?** This delivers the time of the day from which a content is active.
 * **activeTimeStop: String?** This delivers the time of the day until a content is active.
 * **metaInfo: MetaInfo?** The meta info of the content.
 * **textRecord: TextRecord?** The text record of the content.

### MetaInfo
 * **imageURI: String?** The image URI of the meta info.
 * **linkURI: String?** The link URI of the meta info.

### TextRecord
 * **name: String?** The name of the text record.
 * **text: String?** The text of the text record.
 * **languageCode: languageCode?** The language code of the text record.

### Beacon
 * **uuid: String?** The UUID of the beacon.
 * **major: String?** The major ID of the beacon.
 * **minor: String?** The minor ID of the beacon.

## Changelog

### 1.0.8 - 22 November 2016
* FIX: Don't include swift standard libraries in release builds.

### 1.0.7 - 15 November 2016
* FIX: Don't show content multiple times if different beacons provide the same content.

### 1.0.6 - 17 October 2016
* FIX: Don't show Bluetooth warning dialog anymore

### 1.0.5 - 5 October 2016
* Updated 3rd party frameworks
* activeDateStart and activeDateStop are now from type NSDate
* Fixed a bug with the persistent storage of the coolDownTime

### 1.0.4 - 27 September 2016
* Renamed id to contentId in the Content class (Objective-C compatibility)

### 1.0.3 - 26 September 2016
* Added analytics support

### 1.0.2 - 23 September 2016
* Added Objective-C support
* Added Examples for iOS (Swift and Objective-C)

### 1.0.1 - 20 September 2016
* Switched to CocoaPods deployment
* Changed Deployment Target to iOS 8.0

### 1.0.0 - 19 September 2016
* First release fo the iOS SDK
