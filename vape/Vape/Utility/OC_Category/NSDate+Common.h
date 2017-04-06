//
//  NSDate+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-16.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
#import "NSDate+convenience.h"

@interface NSDate (Common)

- (BOOL)isSameDay:(NSDate*)anotherDate;

- (NSInteger)secondsAgo;
- (NSInteger)minutesAgo;
- (NSInteger)hoursAgo;
- (NSInteger)monthsAgo;
- (NSInteger)yearsAgo;
- (NSInteger)leftDayCount;


- (NSString *)string_yyyy_MM_dd_EEE;//@"yyyy-MM-dd EEE" + (今天/昨天)
- (NSString *)string_yyyy_MM_dd;//@"yyyy-MM-dd"
- (NSString *)string_yyyy_MM;//@"yyyy-MM"
- (NSString *)string_yyyy;//@"yyyy"
- (NSString *)stringDisplay_HHmm;//n秒前 / 今天 HH:mm
- (NSString *)stringDisplay_MMdd;//n庙前 / 今天 / MM/dd

+ (NSString *)convertStr_yyyy_MM_ddToDisplay:(NSString *)str_yyyy_MM_dd;//(今天、明天) / MM月dd日 / yyyy年MM月dd日

- (NSString *)stringTimesAgo;//代码更新时间

+ (BOOL)isDuringMidAutumn;



//====================================================================================
#pragma mark - 将数字转换成日期
//====================================================================================
///根据给的的年、月、日的数值转换成NSDate，并且时、分、秒都为0
+ (NSDate *)dateByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;

///根据给的的年、月、日、时、分、秒的数值转换成NSDate
+ (NSDate *)dateByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second;



//====================================================================================
#pragma mark - 将日期转换成字符串
//====================================================================================
///将日期转换成指定格式的字符串，dateFormatString："yyyy-MM-dd HH:MM:SS"
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat;

///Returns string representation of the current (self) date formatted with given format.
///i.e. "dd-MM-yyyy" will return "14-07-2012"
- (NSString *)dateStringWithFormat:(NSString *) format;


//====================================================================================
#pragma mark - Created by Pavel Mazurin on 7/14/12.
//====================================================================================
///Returns a date object shifted by a given number of days, months and years from the current (self) date.
- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years;

-(NSDate*)dateByAddingHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds;

- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years Hours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds;




- (NSDate *)weekStartDate;


///Returns the weekday of the current (self) date.
///Returns 1 for Sunday, 2 for Monday ... 7 for Saturday
- (NSUInteger) weekday;

///返回日期所在的周
-(NSUInteger)weekOfYear;


-(NSString*)localizedDateString;





/**
 * Returns start of day for the current (self) date.
 */
- (NSDate *) midnightDate;

/**
 * Returns the number of days since given date.
 */
- (NSInteger) daysSinceDate:(NSDate *) date;

/**
 * Checks if a given date is before or after the current (self) date.
 */
- (BOOL) isBefore:(NSDate *) date;
- (BOOL) isAfter:(NSDate *) date;

/**
 * Checks if a given date is during the current (self) month.
 */
- (BOOL) isCurrentMonth:(NSDate *)date;


@end
