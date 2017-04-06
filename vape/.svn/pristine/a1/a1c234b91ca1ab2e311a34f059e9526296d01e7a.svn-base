//
//  IDGenerator.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "IDGenerator.h"
#import "Utility.h"

@implementation IDGenerator

//=====================================================================================
#pragma mark - 操作本地数据库时，用来生成记录字段的值的方法
//=====================================================================================
/**
 * 根据当前时间的生成13位时间戳
 **/
+ (long long)generateTimeStampByDate:(NSDate *)date {
    double timeStamp = [date timeIntervalSince1970];
    return timeStamp * 1000;
}

+ (NSInteger)generateHourIndexByDate:(NSDate *)date {
    NSInteger hour = [date hour];
    hour = hour - (hour % 2); //取0、2、4、6、8、10、12、14、16、18、20、22作为小时部分的索引
    NSString *hourIndexString = [NSString stringWithFormat:@"%4ld%02ld%02ld%02ld", (long)[date year], (long)[date month], (long)[date day], (long)hour];
    return [hourIndexString integerValue];
}

+ (NSInteger)generateDayIndexByDate:(NSDate *)date {
    NSString *dayIndexString = [NSString stringWithFormat:@"%4ld%02ld%02ld", (long)[date year], (long)[date month], (long)[date day]];
    return [dayIndexString integerValue];
}

+ (NSInteger)generateMonthIndexByDate:(NSDate *)date {
    NSString *monthIndexString = [NSString stringWithFormat:@"%4ld%02ld", (long)[date year], (long)[date month]];
    return [monthIndexString integerValue];
}

+ (NSInteger)generateYearIndexByDate:(NSDate *)date {
    return [date year];
}

/**
 * 生成吸烟数据的ID
 **/
+ (long long)generateSmokingDataIdByDate:(NSDate *)date {
    NSInteger hour = [date hour];
    hour = hour - (hour % 2); //取0、2、4、6、8、10、12、14、16、18、20、22作为小时部分的索引
    NSDate *newDate = [NSDate dateByYear:[date year]
                                   Month:[date month]
                                     Day:[date day]
                                    Hour:hour
                                  Minute:0
                                  Second:0];
    long long temp = [newDate timeIntervalSince1970];
    return temp * 1000;
}




@end
