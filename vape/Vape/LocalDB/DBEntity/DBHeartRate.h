//
//  DBHeartRate.h
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DBHeartRate : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber    *heartRateId;
@property (nullable, nonatomic, retain) NSNumber    *userId;

@property (nullable, nonatomic, retain) NSDate      *heartRateDt;
@property (nullable, nonatomic, retain) NSNumber    *heartRate;
@property (nullable, nonatomic, retain) NSNumber    *bloodOxygen;

@property (nullable, nonatomic, retain) NSNumber    *syncTag;
@property (nullable, nonatomic, retain) NSDate      *createDt;
@property (nullable, nonatomic, retain) NSDate      *lastUpdateDt;

@end
