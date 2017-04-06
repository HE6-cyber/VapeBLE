//
//  DeviceDataAccessor.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DeviceDataAccessor.h"
#import "Utility.h"

@implementation DeviceDataAccessor

//==========================================================================================================================
#pragma mark - 保存/查询
//==========================================================================================================================
/**
 * 保存设备信息，保存数据前先检查设备信息是否存在，若存在则更新数据
 **/
+ (void)saveDevice:(Device *)device {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", kFieldName_DeviceId, device.deviceId];
    DBDevice *dDevice = [DBDevice MR_findFirstWithPredicate:predicate];
    if (dDevice == nil) {
        dDevice = [DBDevice MR_createEntity];
        dDevice.deviceId    = dDevice.deviceId;
        dDevice.createDt    = dDevice.createDt;
    }
    
    dDevice.deviceName      = device.deviceName;
    
    dDevice.workMode        = @(device.workMode);
    dDevice.batteryValue    = @(device.batteryValue);
    dDevice.powerValue      = @(device.powerValue);
    dDevice.resistanceValue = @(device.resistanceValue);
    dDevice.centigradeValue = @(device.centigradeValue);
    dDevice.fahrenheitValue = @(device.fahrenheitValue);
    
    dDevice.lastUpdateDt    = device.lastUpdateDt;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 * 使用deviceId与userId在本地数据库中查询设备信息，若不存在则返回nil
 **/
+ (Device *)findDeviceByDeiveId:(NSString *)deviceId {
    if (deviceId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", kFieldName_DeviceId, deviceId];
        DBDevice *dDevice = [DBDevice MR_findFirstWithPredicate:predicate];
        if (dDevice != nil) {
            Device *device = [Device new];
            device.deviceId         = deviceId;
            device.deviceName       = dDevice.deviceName;
            
            device.workMode         = [dDevice.workMode integerValue];
            device.batteryValue     = [dDevice.batteryValue integerValue];
            device.powerValue       = [dDevice.powerValue integerValue];
            device.resistanceValue  = [dDevice.resistanceValue integerValue];
            device.centigradeValue  = [dDevice.centigradeValue integerValue];
            device.fahrenheitValue  = [dDevice.fahrenheitValue integerValue];
            
            device.createDt         = dDevice.createDt;
            device.lastUpdateDt     = dDevice.lastUpdateDt;
            return device;
        }
    }
    return nil;
}

/** 删除指定的设备数据 */
+ (void)deleteDeviceByDeviceId:(NSString *)deviceId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", kFieldName_DeviceId, deviceId];
    [DBDevice MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


@end
