//
//  DBUser.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DBUser : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber    *userId;
@property (nullable, nonatomic, retain) NSString    *phone;
@property (nullable, nonatomic, retain) NSString    *password;
@property (nullable, nonatomic, retain) NSString    *userName;
@property (nullable, nonatomic, retain) NSData      *userPhoto;
@property (nullable, nonatomic, retain) NSString    *userPhotoUrl;

@property (nullable, nonatomic, retain) NSNumber    *userGender;
@property (nullable, nonatomic, retain) NSNumber    *userAge;
@property (nullable, nonatomic, retain) NSNumber    *smokeAge;
@property (nullable, nonatomic, retain) NSNumber    *userHeight;
@property (nullable, nonatomic, retain) NSNumber    *userWeight;
@property (nullable, nonatomic, retain) NSString    *userAddress;

@property (nullable, nonatomic, retain) NSString    *deviceId;
@property (nullable, nonatomic, retain) NSString    *deviceName;
@property (nullable, nonatomic, retain) NSNumber    *planCount;
@property (nullable, nonatomic, retain) NSNumber    *planTime;
@property (nullable, nonatomic, retain) NSNumber    *homeInfo;
@property (nullable, nonatomic, retain) NSNumber    *language;

@property (nullable, nonatomic, retain) NSDate      *lastUpdateDt;
@property (nullable, nonatomic, retain) NSDate      *createDt;

@end
