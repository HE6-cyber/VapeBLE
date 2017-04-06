//
//  Device.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "Device.h"
#import "User.h"
#import "BLEOperationCommand.h"

const NSInteger  kDefault_Value_WorkMode        = BLEDeviceWorkModePower;

const NSInteger  kPowerValue_Minimum_Value      = 50;
const NSInteger  kPowerValue_Maximum_Value      = 250;//400

const NSInteger  kCentigrade_Minimum_Value      = 100;
const NSInteger  kCentigrade_Maximum_Value      = 315;

const NSInteger  kFahrenheit_Minimum_Value      = 200;
const NSInteger  kFahrenheit_Maximum_Value      = 600;

static Device *defaultDevice;

@implementation Device

/**
 * 默认值
 **/
+ (Device *)defaultValue {
    static dispatch_once_t  predicate;
    if (defaultDevice == nil) {
        dispatch_once(&predicate, ^{
            defaultDevice = [[Device alloc] init];
            defaultDevice.deviceId         = nil;
            defaultDevice.deviceName       = @"--";
            defaultDevice.workMode         = kDefault_Value_WorkMode;
            defaultDevice.batteryValue     = 0;
            defaultDevice.powerValue       = kPowerValue_Minimum_Value;
            defaultDevice.resistanceValue  = 0;
            defaultDevice.centigradeValue  = kCentigrade_Minimum_Value;
            defaultDevice.fahrenheitValue  = kFahrenheit_Minimum_Value;
        });
    }
    return defaultDevice;
}

/**
 * NSCopying
 **/
- (id)copyWithZone:(NSZone *)zone {
    Device *device = [[Device allocWithZone:zone] init];
    device.deviceId         = [self.deviceId copy];
    device.deviceName       = [self.deviceName copy];
    device.workMode         = self.workMode;
    device.batteryValue     = self.batteryValue;
    device.powerValue       = self.powerValue;
    device.resistanceValue  = self.resistanceValue;
    device.centigradeValue  = self.centigradeValue;
    device.fahrenheitValue  = self.fahrenheitValue;
    device.createDt         = self.createDt;
    device.lastUpdateDt     = self.lastUpdateDt;
    return device;
}




@end
