//
//  HeartRateDataAccessor.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "HeartRateDataAccessor.h"
#import "Utility.h"

@implementation HeartRateDataAccessor

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================

/**
 * 保存心率数据，保存数据前先检查当前是否有5笔数据，
 * 如果存在5笔，则使用新数据去替换最早的那笔数据,
 * 如果多余5笔，则删除其他只保留最新的五笔，并用新数据去替换5笔中最旧的那一笔
 **/
+ (void)saveHeartRate:(HeartRate *)heartRate {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K>=%@", kFieldName_HeartRateDt, [NSDate dateStartOfDay:heartRate.heartRateDt]];
    NSArray *dHeartRates = [DBHeartRate MR_findAllSortedBy:kFieldName_HeartRateDt ascending:NO withPredicate:predicate];
    
    DBHeartRate *dHeartRate;
    if (dHeartRates.count < 5) {
        dHeartRate = [DBHeartRate MR_createEntity];
    }
    else {
        dHeartRate = [dHeartRates objectAtIndex:4];
        if (dHeartRates.count > 5) {
            NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"%K>=%@ AND %K<%@",
                                            kFieldName_DayIndex, [NSDate dateStartOfDay:heartRate.heartRateDt],
                                            kFieldName_HeartRateDt, dHeartRate.heartRateDt];
            [DBHeartRate MR_deleteAllMatchingPredicate:deletePredicate];
        }
    }
    
    dHeartRate.heartRateId      = @(heartRate.heartRateId);
    dHeartRate.userId           = @(heartRate.userId);
    
    dHeartRate.heartRateDt      = heartRate.heartRateDt;
    dHeartRate.heartRate        = @(heartRate.heartRate);
    dHeartRate.bloodOxygen      = @(heartRate.bloodOxygen);
    
    dHeartRate.syncTag          = @(heartRate.syncTag);
    heartRate.lastUpdateDt      = heartRate.lastUpdateDt;
    dHeartRate.createDt         = heartRate.createDt;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


/**
 * 更新同步标记
 **/
+ (void)updateSyncTagByHeartRate:(HeartRate *)heartRate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_HeartRateId, heartRate.heartRateId];
    DBHeartRate *dHeartRate = [DBHeartRate MR_findFirstWithPredicate:predicate];
    if (dHeartRate!= nil) {
        dHeartRate.syncTag        = @(heartRate.syncTag);
        dHeartRate.lastUpdateDt   = heartRate.lastUpdateDt;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}


/**
 * 查询指定日期的心率数据
 **/
+ (NSArray *)findHeartRatesByDate:(NSDate *)date {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K>=%@ AND %K<=%@",
                              kFieldName_HeartRateDt, [NSDate dateStartOfDay:date],
                              kFieldName_HeartRateDt, [NSDate dateEndOfDay:date]];
    NSArray *dHeartRates = [DBHeartRate MR_findAllSortedBy:kFieldName_HeartRateDt ascending:NO withPredicate:predicate];
    
    NSMutableArray *result = [NSMutableArray new];
    for (DBHeartRate *dHeartRate in dHeartRates) {
        HeartRate *heartRate = [[HeartRate alloc] init];
        heartRate.heartRateId      = [dHeartRate.heartRateId longLongValue];
        heartRate.userId           = [dHeartRate.userId longLongValue];
        
        heartRate.heartRateDt      = dHeartRate.heartRateDt;
        heartRate.heartRate        = [dHeartRate.heartRate integerValue];
        heartRate.bloodOxygen      = [dHeartRate.bloodOxygen integerValue];
        
        heartRate.syncTag          = [dHeartRate.syncTag integerValue];
        heartRate.lastUpdateDt     = heartRate.lastUpdateDt;
        heartRate.createDt         = heartRate.createDt;
        
        [result addObject:heartRate];
    }
    return result;
}

/**
 * 删除指定用户的心率数据
 **/
+ (void)deleteHeartRateByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    [DBHeartRate MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}




@end
