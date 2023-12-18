//
//  YourObjectiveCClass.m
//  Runner
//
//  Created by Vashist Agarwalla on 15/12/23.
//

#import "BatteryObjectiveCClass.h"
#import <UIKit/UIKit.h>

@implementation BatteryObjectiveCClass

/// Retrieves the battery percentage of the device.
+ (NSInteger)getBatteryPercentage {
    // Access the current device and enable battery monitoring.
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    // Calculate the battery level as a percentage.
    NSInteger batteryLevel = (NSInteger)(device.batteryLevel * 100);
    
    return batteryLevel;
}

@end
