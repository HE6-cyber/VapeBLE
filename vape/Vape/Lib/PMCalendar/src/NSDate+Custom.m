//
//  NSDate+Custom.m
//  LearnNSDate
//
//  Created by JeffZhao on 15/8/2.
//  Copyright (c) 2015年 YZH. All rights reserved.
//

#import "NSDate+Custom.h"
#import "Utility.h"

@implementation NSDate (Custom)

//====================================================================================
#pragma mark - 将数字转换成日期
//====================================================================================
+(NSDate*)dateByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day {
    return [[self class]dateByYear:year Month:month Day:day Hour:0 Minute:0 Second:0];
}

+(NSDate*)dateByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    components.timeZone = [NSTimeZone systemTimeZone];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

//====================================================================================
#pragma mark - 将日期转换成字符串
//====================================================================================
+(NSString*)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

-(NSString *)dateStringWithFormat:(NSString *)format {
    return [[self class] dateStringWithDate:self DateFormat:format];
}

//====================================================================================
#pragma mark - Created by Pavel Mazurin on 7/14/12.
//====================================================================================
-(NSDate *)dateWithoutTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [calendar dateFromComponents:components];
}

///指定日期当天的00:00:00
-(NSDate*)dateStartPoint {
    return [self dateWithoutTime];
}

///指定日期当天的23:59:59
-(NSDate*)dateEndPoint {
    return [[self dateWithoutTime] dateByAddingDays:0 months:0 years:0 Hours:23 Minutes:59 Seconds:59];
}


-(NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years {
    return [self dateByAddingDays:days months:months years:years Hours:0 Minutes:0 Seconds:0];
}

-(NSDate*)dateByAddingHours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds {
    return [self dateByAddingDays:0 months:0 years:0 Hours:hours Minutes:minutes Seconds:seconds];
}

-(NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years Hours:(NSInteger)hours Minutes:(NSInteger)minutes Seconds:(NSInteger)seconds {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day      = days;
    dateComponents.month    = months;
    dateComponents.year     = years;
    dateComponents.hour     = hours;
    dateComponents.minute   = minutes;
    dateComponents.second   = seconds;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

-(NSDate *)dateByAddingDays:(NSInteger)days {
    return [self dateByAddingDays:days months:0 years:0];
}

-(NSDate *)dateByAddingMonths:(NSInteger)months {
    return [self dateByAddingDays:0 months:months years:0];
}

-(NSDate *)dateByAddingYears:(NSInteger)years {
    return [self dateByAddingDays:0 months:0 years:years];
}

-(NSDate *)monthStartDate {
    NSDate *monthStartDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&monthStartDate interval:NULL forDate:self];
    return monthStartDate;
}

-(NSDate*)weekStartDate {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:self];
    comps.weekday = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

-(NSDate*)yearStartDate {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    comps.month = 1;
    comps.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


-(NSUInteger)numberOfDaysInMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}



-(NSUInteger)weekday {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [weekdayComponents weekday];
}

-(NSUInteger)weekOfYear {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *weekOfYearComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return [weekOfYearComponents weekOfYear];
}

-(NSUInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

-(NSUInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

-(NSUInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

-(NSUInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

-(NSUInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

-(NSUInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}



-(NSString *)localizedDateString {
    NSDate *now = [NSDate new];
    if ([self year]==[now year]&&[self month]==[now month]&&[self day]==[now day]) {
        return @"Today";//LOCALIZED_STRING(keyToday);
    }
    else if ([self year]==[now year]&&[self month]==[now month]&&[self day]==([now day]-1)) {
        return @"Yesterday";//LOCALIZED_STRING(keyYesterday);
    }
    else if ([self year]==[now year]&&[self month]==[now month]&&[self day]==([now day]+1)) {
        return @"Tomorrow";//LOCALIZED_STRING(keyTomorrow);
    }
    else {
        return [NSDate dateStringWithDate:self DateFormat:@"yyyy-MM-dd"];
    }
}




- (NSDate *) midnightDate
{
    NSDate *midnightDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                    startDate:&midnightDate
                                     interval:NULL
                                      forDate:self];
    
    return midnightDate;
}

- (NSInteger) daysSinceDate:(NSDate *) date
{
    return round([self timeIntervalSinceDate:date] / (60 * 60 * 24));
}

- (BOOL) isBefore:(NSDate *) date
{
    return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL) isAfter:(NSDate *) date
{
    return [self timeIntervalSinceDate:date] > 0;
}

- (BOOL) isCurrentMonth:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp1 = [calendar components:NSMonthCalendarUnit fromDate:self];
    NSDateComponents* comp2 = [calendar components:NSMonthCalendarUnit fromDate:date];
    
    return ([comp1 month] == [comp2 month]);
}

@end
