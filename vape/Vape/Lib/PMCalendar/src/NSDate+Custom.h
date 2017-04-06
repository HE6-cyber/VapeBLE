//
//  NSDate+Custom.h
//  LearnNSDate
//
//  Created by JeffZhao on 15/8/2.
//  Copyright (c) 2015年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE_NOW                    [NSDate date]

//NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(date>=%@) AND (date<%@)",[NSDate convertDateWithYear:2015 Month:8 Day:2 Hour:0 Minute:0 Second:0],[NSDate convertDateWithYear:2015 Month:8 Day:3 Hour:00 Minute:00 Second:00]];

@interface NSDate (Custom)

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
///Returns current (self) date without time components. Effectively, it's just a beginning of a day.
- (NSDate *) dateWithoutTime;

///指定日期当天的00:00:00
-(NSDate*)dateStartPoint;

///指定日期当天的23:59:59
-(NSDate*)dateEndPoint;

///Returns a date object shifted by a given number of days, months and years from the current (self) date.
- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years;

-(NSDate*)dateByAddingHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds;

- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years Hours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds;

///Returns a date object shifted by a given number of days from the current (self) date.
- (NSDate *) dateByAddingDays:(NSInteger) days;

///Returns a date object shifted by a given number of months from the current (self) date.
- (NSDate *) dateByAddingMonths:(NSInteger) months;

///Returns a date object shifted by a given number of years from the current (self) date.
- (NSDate *) dateByAddingYears:(NSInteger) years;

///Returns start of month for the current (self) date.
- (NSDate *) monthStartDate;

- (NSDate *) weekStartDate;

- (NSDate *) yearStartDate;

///Returns the number of days in the current (self) month.
- (NSUInteger) numberOfDaysInMonth;

///Returns the weekday of the current (self) date.
///Returns 1 for Sunday, 2 for Monday ... 7 for Saturday
- (NSUInteger) weekday;

///返回日期所在的周
-(NSUInteger)weekOfYear;
-(NSUInteger)year;
-(NSUInteger)month;
-(NSUInteger)day;
-(NSUInteger)hour;
-(NSUInteger)minute;
-(NSUInteger)second;

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
