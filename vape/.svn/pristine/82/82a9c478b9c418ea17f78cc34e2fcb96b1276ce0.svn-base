//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "NSDate+convenience.h"

static NSCalendar   *pCalendar = nil;

@implementation NSDate (Convenience)


+ (NSCalendar *)sharedCalendar {
    if (pCalendar == nil) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            pCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; //公历
        });
    }
    return pCalendar;
}


- (NSInteger)year {
    NSDateComponents *components = [[NSDate sharedCalendar] components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

- (NSInteger)month {
    NSDateComponents *components = [[NSDate sharedCalendar] components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)day {
    NSDateComponents *components = [[NSDate sharedCalendar] components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)hour {
    NSDateComponents *components = [[NSDate sharedCalendar] components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)minute {
    NSDateComponents *components = [[NSDate sharedCalendar] components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

- (NSInteger)second {
    NSDateComponents *components = [[NSDate sharedCalendar] components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}



- (NSInteger)numDaysInMonth {
    NSRange rng = [[NSDate sharedCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

- (NSInteger)firstWeekDayInMonth {
    NSCalendar *gregorian = [NSDate sharedCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps]; //Set date to first of month
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
}



+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: date];
    return [[NSDate sharedCalendar] dateFromComponents:components];
}

+ (NSDate *)dateEndOfDay:(NSDate *)date {
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: date];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    components.nanosecond = 999999999;  //1秒 = 1000毫秒  1毫秒 = 1000微秒  1微秒 = 1000纳秒
    return [[NSDate sharedCalendar] dateFromComponents:components];
}

+ (NSDate *)dateStartOfWeek {
    NSCalendar *gregorian = [NSDate sharedCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: beginningOfWeek];
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    return beginningOfWeek;
}

+ (NSDate *)dateEndOfWeek {
    NSCalendar *gregorian = [NSDate sharedCalendar];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: + (((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7))+6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: endOfWeek];
    //gestript
    endOfWeek = [gregorian dateFromComponents: componentsStripped];
    return endOfWeek;
}

+ (NSDate *)dateStartOfMonth:(NSDate *)date {
    NSDate *startOfMonth = nil;
    [[NSDate sharedCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startOfMonth interval:NULL forDate:date];
    return startOfMonth;
}

+ (NSDate *)dateEndOfMonth:(NSDate *)date {
    return [[NSDate dateStartOfMonth:[date offsetMonth:1]] offsetDay:-1];
}

+ (NSDate *)dateStartOfYear:(NSDate *)date {
    NSCalendar* calendar = [NSDate sharedCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    comps.month = 1;
    comps.day = 1;
    return [calendar dateFromComponents:comps];
}

+ (NSDate *)dateEndOfYear:(NSDate *)date {
   return [[NSDate dateStartOfYear:[date offsetYear:1]]  offsetDay:-1];
}


- (NSDate *)offsetYear:(NSInteger)numYears{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:numYears];
    return [[NSDate sharedCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetMonth:(NSInteger)numMonths {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    return [[NSDate sharedCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetDay:(NSInteger)numDays {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    return [[NSDate sharedCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetHours:(NSInteger)hours {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:hours];
    return [[NSDate sharedCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}







@end
