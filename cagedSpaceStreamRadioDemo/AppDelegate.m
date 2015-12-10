//
//  AppDelegate.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 10/25/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "AppDelegate.h"
#import <EstimoteSDK/EstimoteSDK.h>


@interface AppDelegate ()

// 2. Add a property to hold the beacon manager
@property (nonatomic) ESTBeaconManager *beaconManager;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // Estimote Analytics
    [ESTConfig setupAppID:@"uncc---college-of-arts---a-gl5" andAppToken:@"f424cd457af77e24e8ee67322e38a1d6"];
    
    // 4. Enable analytics
    [ESTConfig enableRangingAnalytics:YES];
    [ESTConfig enableMonitoringAnalytics:YES];
    
//    // 5. Instantiate the beacon manager
//    self.beaconManager = [ESTBeaconManager new];
//    
//    [self.beaconManager requestWhenInUseAuthorization];
//
//    
//    // 6. Start scanning for beacons
//    [self.beaconManager startRangingBeaconsInRegion:
//     [[CLBeaconRegion alloc] initWithProximityUUID:@"7455EF5F-50AE-5EC6-ACD9-6EE22A52A0AA"
//                                        identifier:@"my beacons"]];
//
//
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
