//
//  NSDate+Common.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-16.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "NSDate+Common.h"
#import "Utility.h"

@implementation NSDate (Common)

- (BOOL)isSameDay:(NSDate*)anotherDate{
	NSDateComponents* components1 = [[NSDate sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
	NSDateComponents* components2 = [[NSDate sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}

- (NSInteger)secondsAgo{
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitSecond)
                                                          fromDate:self
                                                            toDate:[NSDate date]
                                                           options:0];
    return [components second];
}
- (NSInteger)minutesAgo{
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitMinute)
                                                          fromDate:self
                                                            toDate:[NSDate date]
                                                           options:0];
    return [components minute];
}
- (NSInteger)hoursAgo{
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitHour)
                                                          fromDate:self
                                                            toDate:[NSDate date]
                                                           options:0];
    return [components hour];
}
- (NSInteger)monthsAgo{
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitMonth)
                                                          fromDate:self
                                                            toDate:[NSDate date]
                                                           options:0];
    return [components month];
}

- (NSInteger)yearsAgo{
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitYear)
                                                          fromDate:self
                                                            toDate:[NSDate date]
                                                           options:0];
    return [components year];
}

- (NSInteger)leftDayCount{
    NSDate *today = [NSDate dateFromString:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];//时分清零
    NSDate *selfCopy = [NSDate dateFromString:[self stringWithFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];//时分清零
    
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitDay)
                                                          fromDate:today
                                                            toDate:selfCopy
                                                           options:0];
    return [components day];
}

- (NSString *)stringTimesAgo{
    if ([self compare:[NSDate date]] == NSOrderedDescending) {
        return @"刚刚";
    }
    
    NSString *text = nil;

    NSInteger agoCount = [self monthsAgo];
    if (agoCount > 0) {
        text = [NSString stringWithFormat:@"%ld个月前", (long)agoCount];
    }else{
        agoCount = [self daysAgoAgainstMidnight];
        if (agoCount > 0) {
            text = [NSString stringWithFormat:@"%ld天前", (long)agoCount];
        }else{
            agoCount = [self hoursAgo];
            if (agoCount > 0) {
                text = [NSString stringWithFormat:@"%ld小时前", (long)agoCount];
            }else{
                agoCount = [self minutesAgo];
                if (agoCount > 0) {
                    text = [NSString stringWithFormat:@"%ld分钟前", (long)agoCount];
                }else{
                    agoCount = [self secondsAgo];
                    if (agoCount > 15) {
                        text = [NSString stringWithFormat:@"%ld秒前", (long)agoCount];
                    }else{
                        text = @"刚刚";
                    }
                }
            }
        }
    }
    return text;
}

- (NSString *)string_yyyy_MM_dd_EEE{
    NSString *text = [self stringWithFormat:@"yyyy-MM-dd EEE"];
    NSInteger daysAgo = [self daysAgoAgainstMidnight];
    switch (daysAgo) {
        case 0:
            text = [text stringByAppendingString:@"（今天）"];
            break;
        case 1:
            text = [text stringByAppendingString:@"（昨天）"];
            break;
        default:
            break;
    }
    return text;
}

- (NSString *)string_yyyy_MM_dd{
    return [self stringWithFormat:@"yyyy-MM-dd"];
}



- (NSString *)string_yyyy_MM {
    return [self stringWithFormat:@"yyyy-MM"];
}

- (NSString *)string_yyyy {
    return [self stringWithFormat:@"yyyy"];
}


+ (NSString *)convertStr_yyyy_MM_ddToDisplay:(NSString *)str_yyyy_MM_dd{
    if (str_yyyy_MM_dd.length <= 0) {
        return nil;
    }
    NSDate *date = [NSDate dateFromString:str_yyyy_MM_dd withFormat:@"yyyy-MM-dd"];
    if (!date) {
        return nil;
    }
    NSString *displayStr = @"";
    if ([date year] != [[NSDate date] year]) {
        displayStr = [date stringWithFormat:@"yyyy年MM月dd日"];
    }else{
        switch ([date leftDayCount]) {
            case 2:
                displayStr = @"后天";
                break;
            case 1:
                displayStr = @"明天";
                break;
            case 0:
                displayStr = @"今天";
                break;
            case -1:
                displayStr = @"昨天";
                break;
            case -2:
                displayStr = @"前天";
                break;
            default:
                displayStr = [date stringWithFormat:@"MM月dd日"];
                break;
        }
    }
    return displayStr;
}

- (NSString *)stringDisplay_HHmm{
    NSString *displayStr = @"";
    if ([self year] != [[NSDate date] year]) {
        displayStr = [self stringWithFormat:@"yy/MM/dd HH:mm"];
    }else if ([self leftDayCount] != 0){
        displayStr = [self stringWithFormat:@"MM/dd HH:mm"];
    }else if ([self hoursAgo] > 0){
        displayStr = [self stringWithFormat:@"今天 HH:mm"];
    }else if ([self minutesAgo] > 0){
        displayStr = [NSString stringWithFormat:@"%ld 分钟前", (long)[self minutesAgo]];
    }else if ([self secondsAgo] > 10){
        displayStr = [NSString stringWithFormat:@"%ld 秒前", (long)[self secondsAgo]];
    }else{
        displayStr = @"刚刚";
    }
    return displayStr;
}

- (NSString *)stringDisplay_MMdd{
    NSString *displayStr = @"";
    if ([self year] != [[NSDate date] year]) {
        displayStr = [self stringWithFormat:@"yy/MM/dd"];
    }else if ([self leftDayCount] != 0){
        displayStr = [self stringWithFormat:@"MM/dd"];
    }else if ([self hoursAgo] > 0){
        displayStr = [self stringWithFormat:@"今天"];
    }else if ([self minutesAgo] > 0){
        displayStr = [NSString stringWithFormat:@"%ld 分钟前", (long)[self minutesAgo]];
    }else if ([self secondsAgo] > 10){
        displayStr = [NSString stringWithFormat:@"%ld 秒前", (long)[self secondsAgo]];
    }else{
        displayStr = @"刚刚";
    }
    return displayStr;
}

+ (BOOL)isDuringMidAutumn{
//    return YES;
    BOOL isDuringMidAutumn;
    NSDate *curDate = [NSDate date];
    if (curDate.year != 2015 ||
        curDate.month != 9 ||
        curDate.day < 25 ||
        curDate.day > 27) {//中秋节期间才显示
        isDuringMidAutumn = NO;
    }else{
        isDuringMidAutumn = YES;
    }
    return isDuringMidAutumn;
}


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
    
    return [[NSDate sharedCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


-(NSDate*)weekStartDate {
    NSDateComponents *comps = [[NSDate sharedCalendar] components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:self];
    comps.weekday = 1;
    return [[NSDate sharedCalendar] dateFromComponents:comps];
}





-(NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [weekdayComponents weekday];
}

-(NSUInteger)weekOfYear {
    NSDateComponents *weekOfYearComponents = [[NSDate sharedCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return [weekOfYearComponents weekOfYear];
}




-(NSString *)localizedDateString {
    NSDate *now = [NSDate new];
    if ([self year]==[now year]&&[self month]==[now month]&&[self day]==[now day]) {
        return LOCALIZED_STRING(@"Today");
    }
    else if ([self year]==[now year]&&[self month]==[now month]&&[self day]==([now day]-1)) {
        return LOCALIZED_STRING(@"Yesterday");
    }
    else if ([self year]==[now year]&&[self month]==[now month]&&[self day]==([now day]+1)) {
        return LOCALIZED_STRING(@"Tomorrow");
    }
    else {
        return [NSDate dateStringWithDate:self DateFormat:@"yyyy-MM-dd"];
    }
}




- (NSDate *)midnightDate {
    NSDate *midnightDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                    startDate:&midnightDate
                                     interval:NULL
                                      forDate:self];
    return midnightDate;
}

- (NSInteger)daysSinceDate:(NSDate *)date {
    return round([self timeIntervalSinceDate:date] / (60 * 60 * 24));
}

- (BOOL)isBefore:(NSDate *)date{
    return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL)isAfter:(NSDate *)date{
    return [self timeIntervalSinceDate:date] > 0;
}

- (BOOL)isCurrentMonth:(NSDate *)date {
    NSDateComponents* comp1 = [[NSDate sharedCalendar] components:NSCalendarUnitMonth fromDate:self];
    NSDateComponents* comp2 = [[NSDate sharedCalendar] components:NSCalendarUnitMonth fromDate:date];
    return ([comp1 month] == [comp2 month]);
}


@end
