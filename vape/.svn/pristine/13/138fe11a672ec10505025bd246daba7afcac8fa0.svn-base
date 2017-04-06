//
//  DeviceDataAccessor.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "DBDevice.h"
#import "Device.h"

#define kFieldName_UserId           @"userId"
#define kFieldName_DeviceId         @"deviceId"

@interface DeviceDataAccessor : NSObject

//==========================================================================================================================
#pragma mark - 保存/查询
//==========================================================================================================================
/** 保存设备信息，保存数据前先检查设备信息是否存在，若存在则更新数据 */
+ (void)saveDevice:(Device *)device;

/** 使用deviceId与userId在本地数据库中查询设备信息，若不存在则返回nil */
+ (Device *)findDeviceByDeiveId:(NSString *)deviceId;

/** 删除指定的设备数据 */
+ (void)deleteDeviceByDeviceId:(NSString *)deviceId;

@end
