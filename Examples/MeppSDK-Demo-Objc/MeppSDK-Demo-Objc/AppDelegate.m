//
//  AppDelegate.m
//  MeppSDK-Demo-Objc
//
//  Created by Patrick Steiner on 21.09.16.
//  Copyright © 2016 Mopius. All rights reserved.
//

#import "AppDelegate.h"
@import MeppSDK;

@interface AppDelegate () <MeppBeaconManagerDelegate>
@property (readwrite, nonatomic, strong) MeppBeaconManager *beaconManager;
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MeppSDK setAppToken:@"A1B2C3D4" forHost:@"example.com" completion:^(BOOL successful) {
        if (successful) {
            NSLog(@"MeppSDK successful initialized");
       
            // init beacon manager
            self.beaconManager = [[MeppBeaconManager alloc] init];
            self.beaconManager.delegate = self;
            [self.beaconManager startMonitoring];
        } else {
            NSLog(@"Failed to initialize MeppSDK");
        }
    }];
    
    return YES;
}

// MARK: - MeppBeaconManagerDelegate

- (void)didFindNewContent:(Content *)content {
    NSLog(@"Did find content: %@", content.contentType);
}

- (void)didChangeSessionStatus:(NSString *)status critical:(BOOL)critical {
    NSLog(@"Did change session status: %@", status);
}

- (void)didDiscoverBeacons:(NSArray<DiscoveredBeacon *> *)beacons {
    //NSLog(@"Did discover beacons");
}

- (void)shouldTrackAnalyticsEvent:(AnalyticsEvent *)event {
    // analytics tracking
}

@end
