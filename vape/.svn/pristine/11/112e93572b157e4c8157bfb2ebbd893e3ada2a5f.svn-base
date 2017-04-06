//
//  Smoking.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBSmoking;

typedef NS_ENUM(NSInteger, SyncTag) {
    SyncTagNotSynchronized  = 0, //未同步
    SyncTagSynchronized     = 1 //已同步
};


@interface Smoking : NSObject

@property (assign, nonatomic) long long     smokingId;
@property (assign, nonatomic) long long     userId;

@property (strong, nonatomic) NSDate        *smokingDt;
@property (assign, nonatomic) NSInteger     hourIndex;
@property (assign, nonatomic) NSInteger     dayIndex;
@property (assign, nonatomic) NSInteger     monthIndex;
@property (assign, nonatomic) NSInteger     yearIndex;
@property (assign, nonatomic) NSInteger     numberOfPuffs;  //吸烟口数

@property (assign, nonatomic) NSInteger     workMode;   //模式：功率模式——0x01、温度模式1——0x02（摄氏度）、温度模式2——0x03（华氏度）
/**
 * 功率模式下输出功率范围：50-400W（实际值的10倍，如50表示5W,168表示16.8W，400表示40W）
 * 温度模式1下输出温度范围：100-315℃
 * 温度模式2下输出温度范围：200-600℉
 **/
@property (assign, nonatomic) NSInteger     powerOrTemp;
/**
 * 吸烟时长范围：0-10秒，如是0表示没有吸烟数据，如是2表示吸烟2秒APP将吸烟口数加1
 **/
@property (assign, nonatomic) NSInteger     smokingTime;
/**
 * 电池电量范围: 0-5 格
 **/
@property (assign, nonatomic) NSInteger     battery;
/**
 * 雾化器阻值范围:0-100(实际值的 100 倍,如 55 表示 0.55 欧,如为 0 表示雾化器
 **/
@property (assign, nonatomic) NSInteger     resistanceValue;

@property (assign, nonatomic) double        longitude;  //经度
@property (assign, nonatomic) double        latitude;   //纬度
@property (strong, nonatomic) NSString      *address;

@property (assign, nonatomic) NSInteger     syncTag;
@property (strong, nonatomic) NSDate        *createDt;
@property (strong, nonatomic) NSDate        *lastUpdateDt;

- (instancetype)initWithSmokingTime:(NSInteger)smokingTime NumberOfPuffs:(NSInteger)numberOfPuffs;

+ (Smoking *)smokingWithSSmoking:(DBSmoking *)dSmoking;

@end
