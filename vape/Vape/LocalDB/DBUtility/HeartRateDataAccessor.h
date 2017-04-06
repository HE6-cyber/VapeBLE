//
//  HeartRateDataAccessor.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "NSManagedObject+Custom.h"
#import "DBHeartRate.h"
#import "HeartRate.h"

#define kFieldName_UserId           @"userId"
#define kFieldName_HeartRateId      @"heartRateId"
#define kFieldName_HeartRateDt      @"heartRateDt"

@interface HeartRateDataAccessor : NSObject

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================
/** 保存心率数据，保存数据前先检查当前是否有5笔数据，如果存在5笔，则使用新数据去更新最早的那笔数据 */
+ (void)saveHeartRate:(HeartRate *)heartRate;

/** 更新同步标记 */
+ (void)updateSyncTagByHeartRate:(HeartRate *)heartRate;

/** 查询指定日期的心率数据 */
+ (NSArray *)findHeartRatesByDate:(NSDate *)date;

/** 删除指定用户的心率数据 */
+ (void)deleteHeartRateByUserId:(long long)userId ;
@end
