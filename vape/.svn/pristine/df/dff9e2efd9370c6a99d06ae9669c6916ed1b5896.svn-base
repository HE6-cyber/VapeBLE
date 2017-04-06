//
//  AggregatedSmoking.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SmokingDataIndexType) {
    SmokingDataIndexTypeHour,
    SmokingDataIndexTypeDay,
    SmokingDataIndexTypeMonth,
    SmokingDataIndexTypeYear
};

@interface SmokingStatistics : NSObject

@property (assign, nonatomic) SmokingDataIndexType      indexType;
@property (assign, nonatomic) NSInteger                 index;

@property (assign, nonatomic) NSInteger                 smokingTime;
@property (assign, nonatomic) NSInteger                 numberOfPuffs;

@property (assign, nonatomic) long long                 userId;

- (instancetype)initWithIndexType:(SmokingDataIndexType)indexType Index:(NSInteger)index SmokingTime:(NSInteger)smokingTime NumberOfPuffs:(NSInteger)numberOfPuffs UserId:(long long)userId;

@end



