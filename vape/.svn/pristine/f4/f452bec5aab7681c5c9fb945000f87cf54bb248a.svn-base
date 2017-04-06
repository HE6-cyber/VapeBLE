//
//  UserDataAccessor.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "DBUser.h"
#import "User.h"

#define kFieldName_UserId           @"userId"
#define kFieldName_UserPhone        @"phone"

@interface UserDataAccessor : NSObject

//==========================================================================================================================
#pragma mark - 保存/查询
//==========================================================================================================================
/** 保存用户信息，保存数据前先检查用户是否存在，若存在则更新数据 */
+ (void)saveUser:(User *)user;

/** 使用userId在本地数据库中查询用户信息，若不存在则返回nil */
+ (User *)findUserByUserId:(long long)userId;

/** 使用userPhone在本地数据库中查询用户信息，若不存在则返回nil */
+ (User *)findUserByUserPhone:(NSString *)userPhone;


/** 删除指定用户的用户数据 */
+ (void)deleteUserByUserId:(long long)userId;


@end
