//
//  Device.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMark_Watt              @"W"    //瓦特
#define kMark_Centigrade        @"°C"   //摄氏度
#define kMark_Fahrenheit        @"°F"   //华氏度

extern const NSInteger  kDefault_Value_WorkMode;

extern const NSInteger  kPowerValue_Minimum_Value;
extern const NSInteger  kPowerValue_Maximum_Value;

extern const NSInteger  kCentigrade_Minimum_Value;
extern const NSInteger  kCentigrade_Maximum_Value;

extern const NSInteger  kFahrenheit_Minimum_Value;
extern const NSInteger  kFahrenheit_Maximum_Value;

@interface Device : NSObject <NSCopying>

@property (strong, nonatomic) NSString  *deviceId;
@property (strong, nonatomic) NSString  *deviceName;

@property (assign, nonatomic) NSInteger workMode;  //功率模式：0x01、摄氏度模式：0x02、华氏度模式：0x03
@property (assign, nonatomic) NSInteger batteryValue;
@property (assign, nonatomic) NSInteger powerValue;
@property (assign, nonatomic) NSInteger resistanceValue;
@property (assign, nonatomic) NSInteger centigradeValue;
@property (assign, nonatomic) NSInteger fahrenheitValue;

@property (strong, nonatomic) NSDate    *createDt;
@property (strong, nonatomic) NSDate    *lastUpdateDt;

/** 默认值 */
+ (Device *)defaultValue;

@end
