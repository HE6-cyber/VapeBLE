//
//  DBSmoking.h
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DBSmoking : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber    *smokingId;
@property (nullable, nonatomic, retain) NSNumber    *userId;

@property (nullable, nonatomic, retain) NSDate      *smokingDt;
@property (nullable, nonatomic, retain) NSNumber    *hourIndex;
@property (nullable, nonatomic, retain) NSNumber    *dayIndex;
@property (nullable, nonatomic, retain) NSNumber    *monthIndex;
@property (nullable, nonatomic, retain) NSNumber    *yearIndex;
@property (nullable, nonatomic, retain) NSNumber    *numberOfPuffs;

@property (nullable, nonatomic, retain) NSNumber    *workMode;
@property (nullable, nonatomic, retain) NSNumber    *powerOrTemp;
@property (nullable, nonatomic, retain) NSNumber    *smokingTime;
@property (nullable, nonatomic, retain) NSNumber    *battery;
@property (nullable, nonatomic, retain) NSNumber    *resistanceValue;

@property (nullable, nonatomic, retain) NSNumber    *longitude;
@property (nullable, nonatomic, retain) NSNumber    *latitude;
@property (nullable, nonatomic, retain) NSString    *address;

@property (nullable, nonatomic, retain) NSNumber    *syncTag;
@property (nullable, nonatomic, retain) NSDate      *createDt;
@property (nullable, nonatomic, retain) NSDate      *lastUpdateDt;

@end
