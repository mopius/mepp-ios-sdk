# MEPP iOS SDK

## Overview

This document shows you a quick way to start using the MEPP SDK in your apps.

## Installing iOS SDK

To use the MEPP SDK in your project, the minimum deployment target must be iOS 8.0.

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
<string>Required for ios >= 8 compatibilty</string>
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

## Interacting with Beacons - monitoring a region
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

**Swift**
``` Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  // Set MeppSDK
  MeppSDK.setAppToken("A1B2C3D4", forHost: "example.com") { (successful) in
            if successful {
              // init beacon manager
              meppBeaconManager = MeppBeaconManager()
              meppBeaconManager!.delegate = self
              meppBeaconManager!.startMonitoring()
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

### Delegate Callbacks

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

### Using MeppAPIClient

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

#### Get Content by ID

**Swift**
``` Swift
meppAPIClient?.contentById(1, user: username, completion: { (succesful, content) in
            if succesful {
                print("content name: \(content?.textRecord?.name)")
            }
        })
```

### Get Content by hardware

**Swift**
``` Swift
let beacon = Beacon()
        beacon.uuid = "D33255DF-8AFD-4A52-99A2-C7DD8E42583F"
        beacon.major = "1"
        beacon.minor = "2"

        meppAPIClient?.contentByHardware(beacon, user: username, completion: { (successful, entryContent, exitContent) in
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

## Reachability

The MEPP SDK also provides a class to get informations about the current Device status. You can monitor the network and API reachability. You can also monitor the bluetooth connection status of the device.

You can initialize it by calling...

MeppDeviceStatusManager()

Also make sure that your class conforms to `MeppDeviceStatusManagerDelegate` protocol.

We will use `viewDidLoad` to initiate the device status manager.

**Swift**
``` Swift
meppDeviceStatusManager = MeppDeviceStatusManager()
meppDeviceStatusManager?.delegate = self
```

### Delegate Callbacks

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

## Data Structure

### AppConfig
 * **slcDistance: Int?** The distance when a significant distance change should be initiated.
 * **minSDK: String?** The minimum allowed SDK version.
 * **maxSessionTime: Int?** The maximum session time.

### Content
 * **id: Int?** The internal content ID. Use this to fetch content a by id.
 * **active: Bool?** Boolean if the content is active or not.
 * **contentType: String?** The type of the content (a.k.a use case).
 * **displayType: DisplayType?** The display type of the content. ["entry", "exit"]
 * **delayTime: Int?** The delay after the content should be shown in seconds.
 * **coolDownTime: Int?** The cooldown time in seconds after which the SDK notifies for a content again.
 * **activeDateStart: String?** This indicates the date from which a content is active.
 * **activeDateStop: String?** This indicates the date until a content is active.
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

### 1.0.2 - 22 September 2016
* Added Objective-C support

### 1.0.1 - 20 September 2016
* Switched to CocoaPods deployment
* Changed Deployment Target to iOS 8.0

### 1.0.0 - 19 September 2016
* First release fo the iOS SDK
