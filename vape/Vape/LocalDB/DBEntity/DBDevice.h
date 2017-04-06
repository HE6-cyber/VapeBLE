//
//  DBDevice.h
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DBDevice : NSManagedObject

@property (nullable, nonatomic, retain) NSString    *deviceId;
@property (nullable, nonatomic, retain) NSString    *deviceName;
@property (nullable, nonatomic, retain) NSNumber    *workMode;

@property (nullable, nonatomic, retain) NSNumber    *batteryValue;
@property (nullable, nonatomic, retain) NSNumber    *powerValue;
@property (nullable, nonatomic, retain) NSNumber    *resistanceValue;
@property (nullable, nonatomic, retain) NSNumber    *centigradeValue;
@property (nullable, nonatomic, retain) NSNumber    *fahrenheitValue;

@property (nullable, nonatomic, retain) NSDate      *createDt;
@property (nullable, nonatomic, retain) NSDate      *lastUpdateDt;

@end
