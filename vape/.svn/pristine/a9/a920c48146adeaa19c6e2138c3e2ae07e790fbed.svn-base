//
//  User.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 匿名用户的id
 **/
extern const NSInteger kUserId_Anonymous;

/**
 * 首页显示类型
 **/
typedef NS_ENUM(NSInteger, HomeInfoType) {
    HomeInfoTypeCount   = 0, //吸烟口数
    HomeInfoTypeTime    = 1  //吸烟时间
};

/**
 * 系统语言类型
 **/
typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeSimplifiedChinese   = 0,
    LanguageTypeEnglish             = 1
};

typedef NS_ENUM(NSInteger, SexType) {
    SexTypeSecurity     = 0,
    SexTypeMale         = 1,
    SexTypeFemale       = 2
};


extern const NSInteger  kUserAge_Minimum_Value;
extern const NSInteger  kUserAge_Maximum_Value;
extern const NSInteger  kUserHeight_Minimum_Value;
extern const NSInteger  kUserHeight_Maximum_Value;
extern const NSInteger  kUserWeight_Minimum_Value;
extern const NSInteger  kUserWeight_Maximum_Value;
extern const NSInteger  kSmokeAge_Minimum_Value;
extern const NSInteger  kSmokeAge_Maximum_Value;

extern const NSInteger  kPlanCount_Minimum_Value;
extern const NSInteger  kPlanCount_Maximum_Value;
extern const NSInteger  kPlanCount_Step_Value;
extern const NSInteger  kPlanTime_Minimum_Value;
extern const NSInteger  kPlanTime_Maximum_Value;
extern const NSInteger  kPlanTime_Step_Value;

extern const NSInteger  kUser_Security_Value; //“保密”的值

extern NSString *const  kUser_Photo_BaseUrl;

extern const NSInteger  kPlanCount_Default_Value; //默认吸烟口数
extern const NSInteger  kPlanTime_Default_Value; //默认吸烟时间（分钟）


@interface User : NSObject <NSCopying>

@property (assign, nonatomic) long long     userId;
@property (strong, nonatomic) NSString      *phone;
@property (strong, nonatomic) NSString      *password;
@property (strong, nonatomic) NSString      *userName;
@property (strong, nonatomic) NSData        *userPhoto;
@property (strong, nonatomic) NSString      *userPhotoUrl;

@property (assign, nonatomic) NSInteger     userGender; //性别：0——保密、1——男、2——女
@property (assign, nonatomic) NSInteger     userAge;
@property (assign, nonatomic) NSInteger     smokeAge;   //用户烟龄
@property (assign, nonatomic) double        userHeight; //身高，单位CM
@property (assign, nonatomic) double        userWeight; //体重，单位：KG
@property (strong, nonatomic) NSString      *userAddress;

@property (strong, nonatomic) NSString      *deviceId;
@property (assign, nonatomic) NSInteger     planCount;  //吸烟计划口数
@property (assign, nonatomic) NSInteger     planTime;   //吸烟计划时长，单位为妙
@property (assign, nonatomic) HomeInfoType  homeInfo; //首页显示信息，0:count,1:time
@property (assign, nonatomic) LanguageType  language; //系统语言，0:中文，1:英文

@property (strong, nonatomic) NSDate        *lastUpdateDt;
@property (strong, nonatomic) NSDate        *createDt;

@property (strong, nonatomic) NSString      *session;   //用户的会话session
@property (strong, nonatomic) NSString      *oldPassword; //修改密码时需要该属性

/** 检查当前用户是否是匿名用户 */
- (BOOL)isAnonymous;

/** 默认值 */
+ (User *)AnonymousUser;

@end
