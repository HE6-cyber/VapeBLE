//
//  User.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "User.h"
#import <UIKit/UIKit.h>

const NSInteger kUserId_Anonymous       = -1;

const NSInteger  kUserAge_Minimum_Value      = 18;
const NSInteger  kUserAge_Maximum_Value      = 100;
const NSInteger  kUserHeight_Minimum_Value   = 150;
const NSInteger  kUserHeight_Maximum_Value   = 250;
const NSInteger  kUserWeight_Minimum_Value   = 40;
const NSInteger  kUserWeight_Maximum_Value   = 200;
const NSInteger  kSmokeAge_Minimum_Value     = 1;
const NSInteger  kSmokeAge_Maximum_Value     = 82;

const NSInteger  kPlanCount_Minimum_Value   = 50;
const NSInteger  kPlanCount_Maximum_Value   = 2000;
const NSInteger  kPlanCount_Step_Value      = 50;
const NSInteger  kPlanTime_Minimum_Value    = 5;
const NSInteger  kPlanTime_Maximum_Value    = 120;
const NSInteger  kPlanTime_Step_Value       = 5;

const NSInteger  kUser_Security_Value       = 0; //“保密”的值

NSString *const  kUser_Photo_BaseUrl        = @"";//@"http://112.74.23.119:8080/esphoto/user/";

const NSInteger  kPlanCount_Default_Value   = 50;
const NSInteger  kPlanTime_Default_Value    = 30;


static User *defaultUser;

@interface User ()

@end

@implementation User

/**
 * 检查当前用户是否是匿名用户
 **/
- (BOOL)isAnonymous {
    if (self.userId == kUserId_Anonymous) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 * 默认值
 **/
+ (User *)AnonymousUser {
    static dispatch_once_t  predicate;
    if (defaultUser == nil) {
        dispatch_once(&predicate, ^{
            defaultUser = [[User alloc] init];
            defaultUser.userId      = kUserId_Anonymous;
            defaultUser.phone       = nil;
            defaultUser.session     = nil;
            defaultUser.userName    = @"--";
            defaultUser.password    = nil;
            defaultUser.userGender  = kUser_Security_Value;//性别：保密
            defaultUser.userAge     = kUser_Security_Value;//年龄：保密
            defaultUser.smokeAge    = kUser_Security_Value;//烟龄：保密
            defaultUser.userHeight  = kUser_Security_Value;//身高：保密
            defaultUser.userWeight  = kUser_Security_Value;//体重：保密
            defaultUser.planCount   = kPlanCount_Default_Value;
            defaultUser.planTime    = kPlanTime_Default_Value;
            defaultUser.homeInfo    = HomeInfoTypeCount;
            defaultUser.language    = LanguageTypeSimplifiedChinese;
            defaultUser.userPhoto   = UIImagePNGRepresentation([UIImage imageNamed:@"defaultUserIcon"]);
            
            defaultUser.deviceId    = nil;
        });
    }
    return defaultUser;
}

/**
 * NSCopying
 **/
- (id)copyWithZone:(NSZone *)zone {
    User *user = [[User allocWithZone:zone] init];
    user.userId         = self.userId;
    user.phone          = [self.phone copy];
    user.password       = [self.password copy];
    user.userName       = [self.userName copy];
    user.userPhoto      = [self.userPhoto copy];
    user.userPhotoUrl   = [self.userPhotoUrl copy];
    
    user.userGender     = self.userGender;
    user.userAge        = self.userAge;
    user.smokeAge       = self.smokeAge;
    user.userHeight     = self.userHeight;
    user.userWeight     = self.userWeight;
    user.userAddress    = [self.userAddress copy];
    
    user.deviceId       = [self.deviceId copy];
    user.planCount      = self.planCount;
    user.planTime       = self.planTime;
    user.homeInfo       = self.homeInfo;
    user.language       = self.language;
    
    user.lastUpdateDt   = [self.lastUpdateDt copy];
    user.createDt       = [self.createDt copy];
    
    user.session        = [self.session copy];
    user.oldPassword    = [self.oldPassword copy];
    
    return user;
}





@end
