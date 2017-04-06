//
//  Smoking.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "Smoking.h"
#import "DBSmoking.h"

@implementation Smoking

- (instancetype)initWithSmokingTime:(NSInteger)smokingTime NumberOfPuffs:(NSInteger)numberOfPuffs {
    if (self = [super init]) {
        self.smokingTime = smokingTime;
        self.numberOfPuffs = numberOfPuffs;
    }
    return self;
}

+ (Smoking *)smokingWithSSmoking:(DBSmoking *)dSmoking {
    Smoking *smoking = [[Smoking alloc] init];
    
    smoking.smokingId       = [dSmoking.smokingId longLongValue];
    smoking.userId          = [dSmoking.userId longLongValue];
    
    smoking.smokingDt       = dSmoking.smokingDt;
    smoking.hourIndex       = [dSmoking.hourIndex integerValue];
    smoking.dayIndex        = [dSmoking.dayIndex integerValue];
    smoking.monthIndex      = [dSmoking.monthIndex integerValue];
    smoking.yearIndex       = [dSmoking.yearIndex integerValue];
    smoking.numberOfPuffs   = [dSmoking.numberOfPuffs integerValue];
    
    smoking.workMode        = [dSmoking.workMode integerValue];
    smoking.powerOrTemp     = [dSmoking.powerOrTemp integerValue];
    smoking.smokingTime     = [dSmoking.smokingTime integerValue];
    smoking.battery         = [dSmoking.battery integerValue];
    smoking.resistanceValue = [dSmoking.resistanceValue integerValue];
    
    smoking.longitude       = [dSmoking.longitude doubleValue];
    smoking.latitude        = [dSmoking.latitude doubleValue];
    smoking.address         = dSmoking.address;
    
    smoking.syncTag         = [dSmoking.syncTag integerValue];
    smoking.createDt        = dSmoking.createDt;
    smoking.lastUpdateDt    = dSmoking.lastUpdateDt;
    
    return smoking;
}

@end
