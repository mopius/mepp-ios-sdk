//
//  AppDelegate.m
//  MeppSDK-Demo-Objc
//
//  Created by Patrick Steiner on 21.09.16.
//  Copyright © 2016 Mopius. All rights reserved.
//

#import "AppDelegate.h"
@import MeppSDK;
@import CoreLocation;
@import CoreBluetooth;

@interface AppDelegate () <MeppManagerDelegate, CBCentralManagerDelegate>
@property (readwrite, nonatomic, strong) MeppManager *meppManager;
@property (readwrite, nonatomic, strong) MeppAPIClient *meppApiClient;
@property (readwrite, nonatomic, strong) CLLocationManager *locationManager;
@property (readwrite, nonatomic, strong) CBCentralManager *centralManager;
@property (readwrite, nonatomic, strong) MeppDeviceStatusManager *deviceManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MeppSDK setAppToken:@"A1B2C3D4" forHost:@"example.at" completion:^(BOOL successful) {
        if (successful) {
            
            self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:NULL];
            
            self.meppManager = [[MeppManager alloc] initWithDelegate:self];
            [self.meppManager startMonitoring];
            
            self.meppApiClient = [[MeppAPIClient alloc] init];
            [self.meppApiClient appConfig:^(BOOL successful, AppConfig * _Nullable appConfig, NSInteger statusCode) {
                if (successful) {
                    if (appConfig != nil) {
                        NSLog(@"app config min sdk version: %@", appConfig.minSDK);
                        NSLog(@"app config maximum session time: %@", appConfig.slcDistance);
                    }
                }
            }];
            [self.meppApiClient contentById:3 user:@"objc-client" completion:^(BOOL successful, Content * _Nullable content, NSInteger statusCode) {
                if (successful) {
                    if (content.textRecord != nil) {
                        TextRecord *textRecord = content.textRecord;
                        
                        if (textRecord.name != nil) {
                            NSLog(@"content name: %@", textRecord.name);
                        }
                    }
                }
            }];
            
            Beacon *beacon = [[Beacon alloc] init];
            beacon.uuid = @"aaaaaaaaa-bbbb-cccc-dddd-eeeeeeee";
            beacon.major = @"1";
            beacon.minor = @"2";
            
            [self.meppApiClient contentByHardwareBeacon:beacon user:@"objc-client" completion:^(BOOL successful, Content * _Nullable entryContent, Content * _Nullable exitContent, NSInteger statusCode) {
                if (successful) {
                    if (entryContent.textRecord != nil) {
                        TextRecord *textRecord = entryContent.textRecord;
                        if (textRecord.name != nil) {
                            NSLog(@"entry content name: %@", textRecord.name);
                        }
                    }
                }
            }];
            
            [self.meppApiClient notificationClickedWithContentId:@"3"];
            [self.meppApiClient notificationDisplayedWithContentId:@"3"];
            [self.meppApiClient nearestPlacesWithLatitude:48.206493 longitude:14.253560 limit:0 completion:^(BOOL successfull, NSArray<Place *> * _Nullable places, NSInteger statusCode) {
                if (successful){
                    if (places.count > 0){
                        printf("%s", places);
                    }
                }
            }];
        } else {
            NSLog(@"Failed to initialize MeppSDK");
        }
    }];
    
    return YES;
}

// MARK: - MeppManagerDelegate

- (void)didFindContent:(Content * _Nonnull)content{
    NSLog(@"Did find content: %@", content.contentType);
}
- (void)didChangeStatus:(NSString * _Nonnull)status critical:(BOOL)critical{
    NSLog(@"Did change session status: %@", status);
}
- (void)geofencesDidChangeWithLocations:(NSArray<GeoLocation *> * _Nonnull)locations{
    NSLog(@"Geofences did change");
}
- (void)didDiscoverBeacons:(NSArray<CLBeacon *> * _Nonnull)beacons{
   // NSLog(@"Did discover beacons");
}
- (void)shouldTrackAnalyticsEvent:(AnalyticsEvent * _Nonnull)event{}



- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    if(self.centralManager.state == CBCentralManagerStatePoweredOn)
    {
        stateString = @"Bluetooth is currently powered on and available to use.";
        //  [self alertStatus:@"Bluetooth is currently powered ON.":@" Bluetooth available" :0];
    }else{
        stateString = @"State unknown, update imminent.";
    }
    NSLog(@"Bluetooth State %@",stateString);
}


- (void)didChangeReachability:(enum ReachableStatus)reachabilityStatus{}
- (void)didChangeLocationAuthorization:(enum LocationStatus)status{}
- (void)didChangeBluetoothStatus:(enum BluetoothStatus)status{
    printf("%ld", (long)status);
}
@end
