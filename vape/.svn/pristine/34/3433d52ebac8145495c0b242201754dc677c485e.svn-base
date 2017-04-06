//
//  UserHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class LoginResponseMessage;
@class RegisterResponseMessage;
@class Device;
@class BaseViewController;

@interface UserHelper : NSObject

//=====================================================================================
#pragma mark - 获取类的实例对象
//=====================================================================================
/** 获取UserHelper的公用实例对象 */
+ (UserHelper *)shareUserHelper;


//=====================================================================================
#pragma mark - 用户
//=====================================================================================
/** 弹出用户登录视图控制器 */
+ (void)presentLoginViewControllerByIsSessionExpired:(BOOL)isSessionExpired;
+ (void)presentLoginViewControllerByIsSessionExpired:(BOOL)isSessionExpired DidLogin:(void(^)())didLogin DidCacenl:(void(^)())didCancel;

/** 登录 */
+ (BOOL)loginByLoginResponseMsg:(LoginResponseMessage *)loginResponseMsg UserPassword:(NSString *)userPassword;
/** 注册后登录 */
+ (BOOL)loginByRegisterResponseMsg:(RegisterResponseMessage *)registerResponseMsg UserPhone:(NSString *)userPhone UserPassword:(NSString *)userPassword;
/** 匿名模式登录 */
+ (void)loginByAnonymousUser;


/** 获取当前用户的信息(分为匿名模式与正常登录模式) */
+ (User *)currentUser;

/** 检查用户是否正常登录(非匿名) */
+ (BOOL)isLogin;

/** 返回当前用户的会话Session */
+ (NSString *)currentUserSession;

/** 返回当前用户的ID */
+ (long long)currentUserId;

/** 将当前用户信息同步到本地数据库 */
+ (void)synchronizeCurrentUser;


//=====================================================================================
#pragma mark - 处理用户登录的辅助方法
//=====================================================================================
/** 保存当前登录用户ID（会话永不过期） */
+ (void)saveLoginUserId:(long long)loginUserId;
/** 保存用户的会话session（会话永不过期）*/
+ (void)saveLoginUserSession:(NSString *)loginUserSession;
/** 获取当前登录用户ID，不存在时返回匿名用户ID */
+ (long long)getLoginUserId;
/** 获取当前用户的会话session（会话永不过期）*/
+ (NSString *)getLoginUserSession;



//=====================================================================================
#pragma mark - 用户的设备
//=====================================================================================
/** 当前是否已经绑定设备 */
+ (BOOL)isBoundDevice;
/** 用户当前绑定设备的UUID */
+ (NSString *)currentDeviceUUID;
/** 返回用户当前绑定设备的详细信息 */
+ (Device *)currentDevice;


//=====================================================================================
#pragma mark - 自动登录
//=====================================================================================
/** 开始自动登录 */
- (BOOL)startAutoLogin;


@end

