//
//  SmokingDataAccessor.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "SmokingDataAccessor.h"
#import "Utility.h"

#define kDefault_Maximum_SmokingData        [[Smoking alloc] initWithSmokingTime:10 NumberOfPuffs:10]

@implementation SmokingDataAccessor

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================

/**
 * 保存吸烟数据，保存数据前先检查数据是否存在，若存在则更新数据
 **/
+ (void)saveSmoking:(Smoking *)smoking {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld",
                              kFieldName_UserId,    smoking.userId,
                              kFieldName_HourIndex, smoking.hourIndex];
    DBSmoking *dSmoking = [DBSmoking MR_findFirstWithPredicate:predicate];
    if (dSmoking == nil) {
        dSmoking = [DBSmoking MR_createEntity];
        dSmoking.smokingId      = @(smoking.smokingId);
        dSmoking.userId         = @(smoking.userId);
        dSmoking.hourIndex      = @(smoking.hourIndex);
        dSmoking.dayIndex       = @(smoking.dayIndex);
        dSmoking.monthIndex     = @(smoking.monthIndex);
        dSmoking.yearIndex      = @(smoking.yearIndex);
        dSmoking.createDt       = smoking.createDt;
        
        dSmoking.numberOfPuffs  = @(smoking.numberOfPuffs);
        dSmoking.smokingTime    = @(smoking.smokingTime);
    }
    else {
        dSmoking.numberOfPuffs  = @([dSmoking.numberOfPuffs integerValue] + smoking.numberOfPuffs);
        dSmoking.smokingTime    = @([dSmoking.smokingTime integerValue] + smoking.smokingTime);
    }
    
    dSmoking.smokingDt          = smoking.smokingDt;
    dSmoking.workMode           = @(smoking.workMode);
    dSmoking.powerOrTemp        = @(smoking.powerOrTemp);
    dSmoking.battery            = @(smoking.battery);
    dSmoking.resistanceValue    = @(smoking.resistanceValue);
    dSmoking.syncTag            = @(smoking.syncTag);
    dSmoking.lastUpdateDt       = smoking.lastUpdateDt;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


/**
 * 更新同步标记
 **/
+ (void)updateSyncTagBySmoking:(Smoking *)smoking {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_SmokingId, smoking.smokingId];
    DBSmoking *dSmoking = [DBSmoking MR_findFirstWithPredicate:predicate];
    if ( dSmoking!= nil) {
        dSmoking.syncTag        = @(smoking.syncTag);
        dSmoking.lastUpdateDt   = smoking.lastUpdateDt;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}


/**
 * 删除指定用户的吸烟数据
 **/
+ (void)deleteSmokingByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    [DBSmoking MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


//==========================================================================================================================
#pragma mark - 数据汇总
//==========================================================================================================================
/**
 * 按小时汇总吸烟数据
 **/
+ (SmokingStatistics *)selectHourStatisticsByHourIndex:(NSInteger)hourIndex UserId:(long long)userId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld",
                              kFieldName_UserId,    userId,
                              kFieldName_HourIndex, hourIndex];
    
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate
                                              groupBy:@[kFieldName_HourIndex]];
    
    if (result!=nil && result.count>0) {
        NSDictionary *dict = [result firstObject];
        return [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeHour
                                                       Index:hourIndex
                                          SmokingTime:[[dict objectForKey:kFieldName_SmokingTime] integerValue]
                                        NumberOfPuffs:[[dict objectForKey:kFieldName_NumberOfPuffs] integerValue]
                                                     UserId:userId];
    }
    
    return nil;
    
}

/**
 * 按天汇总吸烟数据
 **/
+ (SmokingStatistics *)selectDayStatisticsByDayIndex:(NSInteger)dayIndex UserId:(long long)userId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld",
                              kFieldName_UserId,    userId,
                              kFieldName_DayIndex,  dayIndex];
    
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate
                                              groupBy:@[kFieldName_DayIndex]];
    
    if (result!=nil && result.count>0) {
        NSDictionary *dict = [result firstObject];
        return [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeDay
                                                      Index:dayIndex
                                                SmokingTime:[[dict objectForKey:kFieldName_SmokingTime] integerValue]
                                              NumberOfPuffs:[[dict objectForKey:kFieldName_NumberOfPuffs] integerValue]
                                                     UserId:userId];
    }
    
    return nil;
}

/**
 * 按月汇总吸烟数据
 **/
+ (SmokingStatistics *)selectMonthStatisticsByMonthIndex:(NSInteger)monthIndex UserId:(long long)userId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld",
                              kFieldName_UserId,     userId,
                              kFieldName_MonthIndex, monthIndex];
    
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate
                                              groupBy:@[kFieldName_MonthIndex]];
    
    if (result!=nil && result.count>0) {
        NSDictionary *dict = [result firstObject];
        return [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeMonth
                                                      Index:monthIndex
                                                SmokingTime:[[dict objectForKey:kFieldName_SmokingTime] integerValue]
                                              NumberOfPuffs:[[dict objectForKey:kFieldName_NumberOfPuffs] integerValue]
                                                     UserId:userId];
    }
    
    return nil;
}


/**
 * 按年汇总吸烟数据
 **/
+ (SmokingStatistics *)selectYearStatisticsByYearIndex:(NSInteger)yearIndex UserId:(long long)userId {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld",
                              kFieldName_UserId,    userId,
                              kFieldName_YearIndex, yearIndex];
    
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate
                                              groupBy:@[kFieldName_YearIndex]];
    
    if (result!=nil && result.count>0) {
        NSDictionary *dict = [result firstObject];
        return [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeYear
                                                      Index:yearIndex
                                                SmokingTime:[[dict objectForKey:kFieldName_SmokingTime] integerValue]
                                              NumberOfPuffs:[[dict objectForKey:kFieldName_NumberOfPuffs] integerValue]
                                                     UserId:userId];
    }
    
    return nil;
}

/**
 * 获取当天的汇总数据
 **/
+ (SmokingStatistics *)getTodaySmokingDataByUserId:(long long)userId {
    NSInteger dayIndex = [IDGenerator generateDayIndexByDate:[NSDate date]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld",
                              kFieldName_UserId,    userId,
                              kFieldName_DayIndex, dayIndex];
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate
                                              groupBy:@[kFieldName_DayIndex]];
    
    if (result!=nil && result.count>0) {
            return [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeDay
                                                          Index:dayIndex
                                                    SmokingTime:[[result[0] objectForKey:kFieldName_SmokingTime] integerValue]
                                                  NumberOfPuffs:[[result[0] objectForKey:kFieldName_NumberOfPuffs] integerValue]
                                                         UserId:userId];
    }
    else {
        return [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeDay Index:dayIndex SmokingTime:0 NumberOfPuffs:0 UserId:userId];
    }

}


//==========================================================================================================================
#pragma mark - 其他工具方法
//==========================================================================================================================
/**
 * 获取最小的HourIndex（若没有找到则使用当前时间来计算HourIndex）
 **/
+ (NSDate *)getMinimumSmokingDtByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    NSDate *smokingDt = [DBSmoking MR_aggregateOperation:kAggregateOperation_MIN onAttribute:kFieldName_SmokingDt withPredicate:predicate];
    if (smokingDt == nil || [smokingDt isAfter:[NSDate date]]) {
        smokingDt = [NSDate date];  //若没有找到最小吸烟时间，则返回当前时间
    }
    return smokingDt;
}



//==========================================================================================================================
#pragma mark - 计算时、日、月、年的最大口数、最长吸烟时间
//==========================================================================================================================
/**
 * 计算每2小时的最大吸烟数值(口数、时间)
 **/
+ (Smoking *)getMaxHourSmokingDataByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    NSNumber *numberOfPuffs = [DBSmoking MR_aggregateOperation:kAggregateOperation_MAX onAttribute:kFieldName_NumberOfPuffs withPredicate:predicate];
    NSNumber *smokingTime = [DBSmoking MR_aggregateOperation:kAggregateOperation_MAX onAttribute:kFieldName_SmokingTime withPredicate:predicate];
 
    
    Smoking *maxHourSmoking = kDefault_Maximum_SmokingData;
    if (numberOfPuffs != nil && [numberOfPuffs integerValue] > maxHourSmoking.numberOfPuffs) {
        maxHourSmoking.numberOfPuffs = [numberOfPuffs integerValue];
    }
    if (smokingTime != nil && [smokingTime integerValue] > maxHourSmoking.smokingTime) {
        maxHourSmoking.smokingTime = [smokingTime integerValue];
    }
    return maxHourSmoking;
}

/**
 * 计算每天的最大吸烟数值(口数、时间)
 **/
+ (Smoking *)getMaxDaySmokingDataByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate groupBy:@[kFieldName_DayIndex]
                                      HavingPredicate:nil
                                             SortTerm:kFieldName_SmokingTime
                                            Ascending:NO
                                           FetchLimit:10000];
    Smoking *maxDaySmoking = kDefault_Maximum_SmokingData;
    if (result != nil) {
        for (NSDictionary *dict in result) {
            NSInteger numberOfPuffs = [[dict objectForKey:kFieldName_NumberOfPuffs] integerValue];
            NSInteger smokingTime   = [[dict objectForKey:kFieldName_SmokingTime] integerValue];
            if (numberOfPuffs > maxDaySmoking.numberOfPuffs) {
                maxDaySmoking.numberOfPuffs = numberOfPuffs;
            }
            if (smokingTime > maxDaySmoking.smokingTime) {
                maxDaySmoking.smokingTime = smokingTime;
            }
        }
    }
    
    return maxDaySmoking;
}

/**
 * 计算每月的最大吸烟数值(口数、时间)
 **/
+ (Smoking *)getMaxMonthSmokingDataByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate groupBy:@[kFieldName_MonthIndex]];
    Smoking *maxMonthSmoking = kDefault_Maximum_SmokingData;
    if (result != nil) {
        for (NSDictionary *dict in result) {
            NSInteger numberOfPuffs = [[dict objectForKey:kFieldName_NumberOfPuffs] integerValue];
            NSInteger smokingTime   = [[dict objectForKey:kFieldName_SmokingTime] integerValue];
            if (numberOfPuffs > maxMonthSmoking.numberOfPuffs) {
                maxMonthSmoking.numberOfPuffs = numberOfPuffs;
            }
            if (smokingTime > maxMonthSmoking.smokingTime) {
                maxMonthSmoking.smokingTime = smokingTime;
            }
        }
    }

    return maxMonthSmoking;
}

/**
 * 计算每年的最大吸烟数值(口数、时间)
 **/
+ (Smoking *)getMaxYearSmokingDataByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    NSArray *result = [DBSmoking MR_aggregateOperation:kAggregateOperation_SUM
                                         onAttributes:@[kFieldName_SmokingTime,kFieldName_NumberOfPuffs]
                                        withPredicate:predicate groupBy:@[kFieldName_YearIndex]];
    Smoking *maxYearSmoking = kDefault_Maximum_SmokingData;
    if (result != nil) {
        for (NSDictionary *dict in result) {
            NSInteger numberOfPuffs = [[dict objectForKey:kFieldName_NumberOfPuffs] integerValue];
            NSInteger smokingTime   = [[dict objectForKey:kFieldName_SmokingTime] integerValue];
            if (numberOfPuffs > maxYearSmoking.numberOfPuffs) {
                maxYearSmoking.numberOfPuffs = numberOfPuffs;
            }
            if (smokingTime > maxYearSmoking.smokingTime) {
                maxYearSmoking.smokingTime = smokingTime;
            }
        }
    }

    return maxYearSmoking;
}

































@end
