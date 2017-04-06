//
//  UserDataAccessor.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UserDataAccessor.h"

@implementation UserDataAccessor

//==========================================================================================================================
#pragma mark - 插入/保存/更新
//==========================================================================================================================
/**
 * 保存用户信息，保存数据前先检查用户是否存在，若存在则更新数据
 **/
+ (void)saveUser:(User *)user {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, user.userId];
    DBUser *dUser = [DBUser MR_findFirstWithPredicate:predicate];
    if (dUser == nil) {
        dUser = [DBUser MR_createEntity];
        dUser.userId    = @(user.userId);
        dUser.createDt  = user.createDt;
    }
    
    dUser.phone         = user.phone;
    dUser.password      = user.password;
    dUser.userName      = user.userName;
    dUser.userPhoto     = user.userPhoto;
    dUser.userPhotoUrl  = user.userPhotoUrl;
    
    dUser.userGender    = @(user.userGender);
    dUser.userAge       = @(user.userAge);
    dUser.smokeAge      = @(user.smokeAge);
    dUser.userHeight    = @(user.userHeight);
    dUser.userWeight    = @(user.userWeight);
    dUser.userAddress   = user.userAddress;
    
    dUser.deviceId      = user.deviceId;
    dUser.planCount     = @(user.planCount);
    dUser.planTime      = @(user.planTime);
    dUser.homeInfo      = @(user.homeInfo);
    dUser.language      = @(user.language);
    
    dUser.lastUpdateDt  = user.lastUpdateDt;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 * 使用userId在本地数据库中查询用户信息，若不存在则返回nil
 **/
+ (User *)findUserByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    DBUser *dUser = [DBUser MR_findFirstWithPredicate:predicate];
    if (dUser != nil) {
        User *user = [User new];
        user.userId         = userId;
        user.phone          = dUser.phone;
        user.password       = dUser.password;
        user.userName       = dUser.userName;
        user.userPhoto      = dUser.userPhoto;
        user.userPhotoUrl   = dUser.userPhotoUrl;
        
        user.userGender     = [dUser.userGender integerValue];
        user.userAge        = [dUser.userAge integerValue];
        user.smokeAge       = [dUser.smokeAge integerValue];
        user.userHeight     = [dUser.userHeight doubleValue];
        user.userWeight     = [dUser.userWeight doubleValue];
        user.userAddress    = dUser.userAddress;
        
        user.deviceId       = dUser.deviceId;
        user.planCount      = [dUser.planCount integerValue];
        user.planTime       = [dUser.planTime integerValue];
        user.homeInfo       = [dUser.homeInfo integerValue];
        user.language       = [dUser.language integerValue];
        
        user.createDt       = dUser.createDt;
        user.lastUpdateDt   = dUser.lastUpdateDt;
        
        return user;
    }
    return nil;
}

/**
 * 使用userPhone在本地数据库中查询用户信息，若不存在则返回nil
 **/
+ (User *)findUserByUserPhone:(NSString *)userPhone {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", kFieldName_UserPhone, userPhone];
    DBUser *dUser = [DBUser MR_findFirstWithPredicate:predicate];
    if (dUser != nil) {
        User *user = [User new];
        user.userId         = [dUser.userId integerValue];
        user.phone          = dUser.phone;
        user.password       = dUser.password;
        user.userName       = dUser.userName;
        user.userPhoto      = dUser.userPhoto;
        user.userPhotoUrl   = dUser.userPhotoUrl;
        
        user.userGender     = [dUser.userGender integerValue];
        user.userAge        = [dUser.userAge integerValue];
        user.smokeAge       = [dUser.smokeAge integerValue];
        user.userHeight     = [dUser.userHeight doubleValue];
        user.userWeight     = [dUser.userWeight doubleValue];
        user.userAddress    = dUser.userAddress;
        
        user.deviceId       = dUser.deviceId;
        user.planCount      = [dUser.planCount integerValue];
        user.planTime       = [dUser.planTime integerValue];
        user.homeInfo       = [dUser.homeInfo integerValue];
        user.language       = [dUser.language integerValue];
        
        user.createDt       = dUser.createDt;
        user.lastUpdateDt   = dUser.lastUpdateDt;
        
        return user;
    }
    return nil;
}

/**
 * 删除指定用户的用户数据
 **/
+ (void)deleteUserByUserId:(long long)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld", kFieldName_UserId, userId];
    [DBUser MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


@end
