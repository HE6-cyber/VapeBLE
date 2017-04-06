//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Convenience)

+ (NSCalendar *)sharedCalendar;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

- (NSInteger)numDaysInMonth;
- (NSInteger)firstWeekDayInMonth;

+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (NSDate *)dateEndOfDay:(NSDate *)date;

+ (NSDate *)dateStartOfWeek;
+ (NSDate *)dateEndOfWeek;

+ (NSDate *)dateStartOfMonth:(NSDate *)date;
+ (NSDate *)dateEndOfMonth:(NSDate *)date;

+ (NSDate *)dateStartOfYear:(NSDate *)date;
+ (NSDate *)dateEndOfYear:(NSDate *)date;

- (NSDate *)offsetYear:(NSInteger)numYears;
- (NSDate *)offsetMonth:(NSInteger)numMonths;
- (NSDate *)offsetDay:(NSInteger)numDays;
- (NSDate *)offsetHours:(NSInteger)hours;

@end
