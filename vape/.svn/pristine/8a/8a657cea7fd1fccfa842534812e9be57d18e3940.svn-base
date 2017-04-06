//
//  IDGenerator.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDGenerator : NSObject

//=====================================================================================
#pragma mark - 操作本地数据库时，用来生成记录字段的值的方法
//=====================================================================================
/** 根据当前时间的生成13位时间戳 */
+ (long long)generateTimeStampByDate:(NSDate *)date;
+ (NSInteger)generateHourIndexByDate:(NSDate *)date;
+ (NSInteger)generateDayIndexByDate:(NSDate *)date;
+ (NSInteger)generateMonthIndexByDate:(NSDate *)date;
+ (NSInteger)generateYearIndexByDate:(NSDate *)date;

/** 生成吸烟数据的ID */
+ (long long)generateSmokingDataIdByDate:(NSDate *)date;
@end
