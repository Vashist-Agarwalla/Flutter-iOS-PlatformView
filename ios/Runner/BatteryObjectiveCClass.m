//
//  YourObjectiveCClass.m
//  Runner
//
//  Created by Vashist Agarwalla on 15/12/23.
//

#import "BatteryObjectiveCClass.h"
#import <UIKit/UIKit.h>

@implementation BatteryObjectiveCClass

+ (NSInteger)getBatteryPercentage {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    NSInteger batteryLevel = (NSInteger)(device.batteryLevel * 100);

    return batteryLevel;
}

@end
