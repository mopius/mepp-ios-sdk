//
//  ViewController.m
//  MeppSDK-Demo-Objc
//
//  Created by Patrick Steiner on 21.09.16.
//  Copyright © 2016 Mopius. All rights reserved.
//

#import "ViewController.h"
@import MeppSDK;

@interface ViewController () <MeppDeviceStatusManagerDelegate>
@property (readwrite, nonatomic, strong) MeppAPIClient *apiClient;
@property (readwrite, nonatomic, strong) MeppDeviceStatusManager *deviceStatusManager;

- (void)fetchContentById:(int)id;
- (void)fetchContentByHardwareWithUUID:(NSString *)uuid andMajor:(NSString *)major andMinor:(NSString *)minor;
- (void)getAppConfig;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MEPP Reachability
    self.deviceStatusManager = [[MeppDeviceStatusManager alloc] init];
    self.deviceStatusManager.delegate = self;
    [self.deviceStatusManager requestAlwaysLocationAuthorization];
    
    // MEPP API Client
    self.apiClient = [[MeppAPIClient alloc] init];
    [self getAppConfig];
    [self fetchContentById:1];
    [self fetchContentByHardwareWithUUID:@"D33255DF-8AFD-4A52-99A2-C7DD8E42583F" andMajor:@"1" andMinor:@"2"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.deviceStatusManager startReachabilityNotifier];
    [self.deviceStatusManager startLocationNotifier];
    [self.deviceStatusManager startBluetoothNotifier];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.deviceStatusManager stopReachabilityNotifier];
}

- (void)getAppConfig {
    [self.apiClient appConfig:^(BOOL successful, AppConfig * _Nullable appConfig, NSInteger statusCode) {
        if (successful) {
            if (appConfig != nil) {
                NSLog(@"app config min sdk version: %@", appConfig.minSDK);
                NSLog(@"app config maximum session time: %@", appConfig.slcDistance);
            }
        }
    }];
}

- (void)fetchContentById:(int)id {
    [self.apiClient contentById:id user:@"objc-client" completion:^(BOOL succesful, Content * _Nullable content, NSInteger statusCode) {
        if (succesful) {
            if (content.textRecord != nil) {
                TextRecord *textRecord = content.textRecord;
                
                if (textRecord.name != nil) {
                    NSLog(@"content ame: %@", textRecord.name);
                }
            }
        }
    }];
}

- (void)fetchContentByHardwareWithUUID:(NSString *)uuid andMajor:(NSString *)major andMinor:(NSString *)minor {
    Beacon *beacon = [[Beacon alloc] init];
    beacon.uuid = uuid;
    beacon.major = major;
    beacon.minor = minor;
    
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
}

// MARK: - MeppDeviceStatusManagerDelegate

- (void)didChangeReachability:(enum ReachableStatus)reachabilityStatus {
    NSLog(@"network reachability status changed");
}

- (void)didChangeLocationAuthorization:(enum LocationStatus)status {
    NSLog(@"location authorization status changed");
}

- (void)didChangeBluetoothStatus:(enum BluetoothStatus)status {
    NSLog(@"bluetooth status changed");
}

@end
