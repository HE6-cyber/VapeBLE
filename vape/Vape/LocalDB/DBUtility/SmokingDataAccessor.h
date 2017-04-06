//
//  SmokingDataAccessor.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "NSManagedObject+Custom.h"
#import "DBSmoking.h"
#import "Smoking.h"
#import "SmokingStatistics.h"

#define kAggregateOperation_SUM     @"sum:"
#define kAggregateOperation_MAX     @"max:"
#define kAggregateOperation_MIN     @"min:"

#define kFieldName_SmokingId        @"smokingId"
#define kFieldName_SmokingDt        @"smokingDt"
#define kFieldName_DeviceId         @"deviceId"
#define kFieldName_UserId           @"userId"
#define kFieldName_SmokingTime      @"smokingTime"
#define kFieldName_NumberOfPuffs    @"numberOfPuffs"

#define kFieldName_HourIndex        @"hourIndex"
#define kFieldName_DayIndex         @"dayIndex"
#define kFieldName_MonthIndex       @"monthIndex"
#define kFieldName_YearIndex        @"yearIndex"

#define kFieldName_SyncTag          @"syncTag"

@interface SmokingDataAccessor : NSObject

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================
/** 保存吸烟数据，保存数据前先检查数据是否存在，若存在则更新数据 */
+ (void)saveSmoking:(Smoking *)smoking;

/** 更新同步标记 */
+ (void)updateSyncTagBySmoking:(Smoking *)smoking;

/** 删除指定用户的吸烟数据 */
+ (void)deleteSmokingByUserId:(long long)userId;

//==========================================================================================================================
#pragma mark - 数据汇总(吸烟时间单位：分钟)
//==========================================================================================================================
/** 按小时汇总吸烟数据 */
+ (SmokingStatistics *)selectHourStatisticsByHourIndex:(NSInteger)hourIndex UserId:(long long)userId;

/** 按天汇总吸烟数据 */
+ (SmokingStatistics *)selectDayStatisticsByDayIndex:(NSInteger)dayIndex UserId:(long long)userId;

/** 按月汇总吸烟数据 */
+ (SmokingStatistics *)selectMonthStatisticsByMonthIndex:(NSInteger)monthIndex UserId:(long long)userId;

/** 按月汇总吸烟数据 */
+ (SmokingStatistics *)selectYearStatisticsByYearIndex:(NSInteger)yearIndex UserId:(long long)userId;

/**  获取当天的汇总数据 */
+ (SmokingStatistics *)getTodaySmokingDataByUserId:(long long)userId;


//==========================================================================================================================
#pragma mark - 其他工具方法
//==========================================================================================================================
/** 获取保存的最早的吸烟时间（若没有找到最小吸烟时间，则返回当前时间）*/
+ (NSDate *)getMinimumSmokingDtByUserId:(long long)userId;



//==========================================================================================================================
#pragma mark - 计算时、日、月、年的最大口数、最长吸烟时间(吸烟时间单位：分钟)
//==========================================================================================================================
+ (Smoking *)getMaxHourSmokingDataByUserId:(long long)userId;
+ (Smoking *)getMaxDaySmokingDataByUserId:(long long)userId;
+ (Smoking *)getMaxMonthSmokingDataByUserId:(long long)userId;
+ (Smoking *)getMaxYearSmokingDataByUserId:(long long)userId;












@end
