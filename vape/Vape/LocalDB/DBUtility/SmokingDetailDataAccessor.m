//
//  SmokingDetailDataAccessor.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "SmokingDetailDataAccessor.h"
#import "Utility.h"

@implementation SmokingDetailDataAccessor

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================

/**
 * 保存吸烟数据，保存数据前先检查当前是否有5笔数据，
 * 如果存在5笔，则使用新数据去替换最早的那笔数据,
 * 如果多余5笔，则删除其他只保留最新的五笔，并用新数据去替换5笔中最旧的那一笔
 **/
+ (void)saveSmoking:(Smoking *)smoking {
    
    NSInteger dayIndex = [IDGenerator generateDayIndexByDate:smoking.smokingDt];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%ld", kFieldName_DayIndex, dayIndex];
    NSArray *dSmokingDetails = [DBSmokingDetail MR_findAllSortedBy:kFieldName_SmokingDt ascending:NO withPredicate:predicate];
    
    DBSmokingDetail *dSmokingDetail;
    if (dSmokingDetails.count < 5) {
        dSmokingDetail = [DBSmokingDetail MR_createEntity];
    }
    else {
        dSmokingDetail = [dSmokingDetails objectAtIndex:4];
        if (dSmokingDetails.count > 5) {
            NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"%K==%ld AND %K<%@",
                                            kFieldName_DayIndex, dayIndex,
                                            kFieldName_SmokingDt, dSmokingDetail.smokingDt];
            [DBSmokingDetail MR_deleteAllMatchingPredicate:deletePredicate];
        }
    }
    
    dSmokingDetail.smokingId        = @(smoking.smokingId);
    dSmokingDetail.dayIndex         = @(smoking.dayIndex);
    
    dSmokingDetail.userId           = @(smoking.userId);
    dSmokingDetail.smokingDt        = smoking.smokingDt;
    
    dSmokingDetail.longitude        = @(smoking.longitude);
    dSmokingDetail.latitude         = @(smoking.latitude);
    dSmokingDetail.address          = smoking.address;
    
    dSmokingDetail.workMode         = @(smoking.workMode);
    dSmokingDetail.powerOrTemp      = @(smoking.powerOrTemp);
    dSmokingDetail.smokingTime      = @(smoking.smokingTime);
    dSmokingDetail.battery          = @(smoking.battery);
    dSmokingDetail.resistanceValue  = @(smoking.resistanceValue);
    
    dSmokingDetail.syncTag          = @(smoking.syncTag);
    dSmokingDetail.createDt         = smoking.createDt;
    dSmokingDetail.lastUpdateDt     = smoking.lastUpdateDt;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


/**
 * 更新同步标记
 **/
+ (void)updateSyncTagBySmoking:(Smoking *)smoking {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_SmokingId, smoking.smokingId];
    DBSmokingDetail *dSmokingDetail = [DBSmokingDetail MR_findFirstWithPredicate:predicate];
    if (dSmokingDetail!= nil) {
        dSmokingDetail.syncTag        = @(smoking.syncTag);
        dSmokingDetail.lastUpdateDt   = smoking.lastUpdateDt;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}


/**
 * 查询指定日期的吸烟位置坐标
 **/
+ (NSArray *)findSmokingDetailByDayIndex:(NSInteger)dayIndex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%ld", kFieldName_DayIndex, dayIndex];
    NSArray *dSmokingDetails = [DBSmokingDetail MR_findAllSortedBy:kFieldName_SmokingDt ascending:NO withPredicate:predicate];
    
    NSMutableArray *result = [NSMutableArray new];
    for (DBSmokingDetail *dSmokingDetail in dSmokingDetails) {
        if ([dSmokingDetail.longitude doubleValue] == 0 &&
            [dSmokingDetail.latitude doubleValue] == 0) {
            continue;
        }
        Smoking *smoking        = [[Smoking alloc] init];
        smoking.smokingId       = [dSmokingDetail.smokingId longLongValue];
        smoking.userId          = [dSmokingDetail.userId longLongValue];
        smoking.smokingDt       = dSmokingDetail.smokingDt;
        
        smoking.longitude       = [dSmokingDetail.longitude doubleValue];
        smoking.latitude        = [dSmokingDetail.latitude doubleValue];
        smoking.address         = dSmokingDetail.address;
        
        smoking.workMode        = [dSmokingDetail.workMode integerValue];
        smoking.powerOrTemp     = [dSmokingDetail.powerOrTemp integerValue];
        smoking.smokingTime     = [dSmokingDetail.smokingTime integerValue];
        smoking.battery         = [dSmokingDetail.battery integerValue];
        smoking.resistanceValue = [dSmokingDetail.resistanceValue integerValue];
        
        smoking.syncTag         = [dSmokingDetail.syncTag integerValue];
        smoking.createDt        = dSmokingDetail.createDt;
        smoking.lastUpdateDt    = dSmokingDetail.lastUpdateDt;
        
        smoking.dayIndex        = [dSmokingDetail.dayIndex integerValue];
        
        [result addObject:smoking];
    }
    return result;
}

/**
 * 删除指定用户的吸烟位置数据
 **/
+ (void)deleteSmokingDetailByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    [DBSmokingDetail MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}





@end
