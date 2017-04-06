//
//  SmokingDetailDataAccessor.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "NSManagedObject+Custom.h"
#import "DBSmokingDetail.h"
#import "Smoking.h"

#define kAggregateOperation_SUM     @"sum:"
#define kAggregateOperation_MAX     @"max:"
#define kAggregateOperation_MIN     @"min:"

#define kFieldName_SmokingId        @"smokingId"
#define kFieldName_SmokingDt        @"smokingDt"
#define kFieldName_DeviceId         @"deviceId"
#define kFieldName_UserId           @"userId"
#define kFieldName_SmokingTime      @"smokingTime"
#define kFieldName_NumberOfPuffs    @"numberOfPuffs"

#define kFieldName_DayIndex         @"dayIndex"


@interface SmokingDetailDataAccessor : NSObject

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================
/** 保存吸烟数据，保存数据前先检查当前是否有5笔数据，如果存在5笔，则使用新数据去更新最早的那笔数据 */
+ (void)saveSmoking:(Smoking *)smoking;

/** 更新同步标记 */
+ (void)updateSyncTagBySmoking:(Smoking *)smoking;

/** 查询指定日期的吸烟位置坐标 */
+ (NSArray *)findSmokingDetailByDayIndex:(NSInteger)dayIndex;

/** 删除指定用户的吸烟位置数据 */
+ (void)deleteSmokingDetailByUserId:(long long)userId;

@end
