//
//  HeartRate.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartRate : NSObject

@property (assign, nonatomic) long long     heartRateId;
@property (assign, nonatomic) long long     userId;

@property (strong, nonatomic) NSDate        *heartRateDt;
@property (assign, nonatomic) NSInteger     heartRate;  //心率范围约 60-120,如为 60 表示心率为 60 次/分, 如为 0 表示检测出错
@property (assign, nonatomic) NSInteger     bloodOxygen;    //血氧范围约 0-100,如为 90 表示血氧饱和度为 90%, 如为 0 表示检测出错

@property (assign, nonatomic) NSInteger     syncTag;
@property (strong, nonatomic) NSDate        *createDt;
@property (strong, nonatomic) NSDate        *lastUpdateDt;

//=====================================================================
#pragma mark - 计算心率血氧是否正常
//=====================================================================
- (BOOL)isNormalByHeartRateValue;

- (BOOL)isNormalByBloodOxygenValue;

@end
