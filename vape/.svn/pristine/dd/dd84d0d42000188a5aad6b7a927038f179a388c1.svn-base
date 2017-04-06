//
//  UserHelper.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UserHelper.h"
#import "TcpCommandHelper.h"
#import "BLECommandHelper.h"
#import "UserDataAccessor.h"
#import "DeviceDataAccessor.h"
#import "SmokingDataAccessor.h"
#import "SmokingDetailDataAccessor.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "Device.h"
#import "SyncDataHelper.h"


#define kVape_LoginUserId               @"kVape_LoginUserId"
#define kVape_LoginUserSession          @"kVape_LoginUserSession"


static UserHelper   *pUserHelper    = nil;
static User         *shareLoginUser = nil;

@interface UserHelper ()<TcpCommandHelperDelegate> {
    
}

@property (strong, nonatomic) TcpCommandHelper  *tcpCommandHelper;

@end

@implementation UserHelper

//=====================================================================================
#pragma mark - 获取类的实例对象
//=====================================================================================
/**
 * 获取UserHelper的公用实例对象
 **/
+ (UserHelper *)shareUserHelper {
    static dispatch_once_t  predicate;
    if (pUserHelper == nil) {
        dispatch_once(&predicate, ^{
            pUserHelper = [[UserHelper alloc] init];
        });
    }
    return pUserHelper;
}

/**
 * 初始化方法
 **/
- (instancetype)init {
    if (self = [super init]) {
        self.tcpCommandHelper = [TcpCommandHelper tcpCommandHelperWithDelegate:self];
    }
    return self;
}

//=====================================================================================
#pragma mark - 用户
//=====================================================================================
/**
 * 弹出用户登录视图控制器
 **/
+ (void)presentLoginViewControllerByIsSessionExpired:(BOOL)isSessionExpired {
    LoginViewController *loginVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"LoginViewController");
    loginVC.isBackToPreviousFunction    = YES;
    loginVC.isSessionExpired            = isSessionExpired;
    BaseNavigationController *navigationVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [[Utility getAppDelegate].window.rootViewController presentViewController:navigationVC animated:YES completion:^{
        DebugLog(@"Login finished!xxx");
    }];
}

/**
 * 弹出用户登录视图控制器
 **/
+ (void)presentLoginViewControllerByIsSessionExpired:(BOOL)isSessionExpired DidLogin:(void(^)())didLogin DidCacenl:(void(^)())didCancel {
    LoginViewController *loginVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"LoginViewController");
    loginVC.isBackToPreviousFunction    = YES;
    loginVC.isSessionExpired            = isSessionExpired;
    loginVC.didLogin                    = didLogin;
    loginVC.didCancel                   = didCancel;
    BaseNavigationController *navigationVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [[Utility getAppDelegate].window.rootViewController presentViewController:navigationVC animated:YES completion:^{
        DebugLog(@"Login finished!xxx");
    }];
}

/**
 * 登录
 **/
+ (BOOL)loginByLoginResponseMsg:(LoginResponseMessage *)loginResponseMsg UserPassword:(NSString *)userPassword {
    if (loginResponseMsg != nil) {
        User *user = [UserDataAccessor findUserByUserId:loginResponseMsg.userId];
        if (user == nil) {
            user = [[User AnonymousUser] copy];
            user.createDt = [NSDate date];
        }
        user.session        = loginResponseMsg.session;
        user.userId         = loginResponseMsg.userId;
        user.phone          = loginResponseMsg.phone;
        user.userName       = loginResponseMsg.userName;
        user.password       = userPassword;
        user.userPhotoUrl   = loginResponseMsg.userPhoto;
        
        user.userGender     = loginResponseMsg.userGender;
        user.userAge        = loginResponseMsg.userAge;
        user.smokeAge       = loginResponseMsg.smokeAge;
        user.userHeight     = loginResponseMsg.userHeight;
        user.userWeight     = loginResponseMsg.userWeight;
        
        user.planCount      = loginResponseMsg.planCount;
        user.planTime       = loginResponseMsg.planTime;
        user.homeInfo       = loginResponseMsg.homeInfo;
        user.language       = loginResponseMsg.language;
        
        user.lastUpdateDt   = [NSDate date];
        
        shareLoginUser = user;
        [UserDataAccessor saveUser:user];
        [self saveLoginUserId:user.userId];
        [self saveLoginUserSession:user.session];
        
        [[SyncDataHelper shareSyncDataHelperWithDelegate:nil] startDownloadSmokingData];//开始下载吸烟数据
        
        if (!([self isBoundDevice] && [[[BLECommandHelper shareBLECommandHelper] currentPeripheralUUIDString] isEqualToString:[self currentDeviceUUID]])) { // 当前用户的绑定设备与当前已连接的设备的UUID一样时，不需要取消连接
            [[BLECommandHelper shareBLECommandHelper] cancelCurrentPeripheral]; //首先取消原来的连接
        }
        if ([self isBoundDevice]) { //重连绑定的蓝牙设备
            [[BLECommandHelper shareBLECommandHelper] connectToPeripheralWithUUIDString:[self currentDeviceUUID]];
        }
        return YES;
    }
    else {
        return NO;
    }
}

/**
 * 注册后登录
 **/
+ (BOOL)loginByRegisterResponseMsg:(RegisterResponseMessage *)registerResponseMsg UserPhone:(NSString *)userPhone UserPassword:(NSString *)userPassword {
    if (registerResponseMsg != nil) {
        User *user = [[User AnonymousUser] copy];
        user.session        = registerResponseMsg.session;
        user.userId         = registerResponseMsg.userId;
        user.phone          = userPhone;
        user.password       = userPassword;
        user.userName       = userPhone;
        user.createDt       = [NSDate date];
        user.lastUpdateDt   = [NSDate date];
        
        shareLoginUser = user;
        [UserDataAccessor saveUser:user];
        [self saveLoginUserId:user.userId];
        [self saveLoginUserSession:user.session];
        
        [[BLECommandHelper shareBLECommandHelper] cancelCurrentPeripheral]; //首先取消原来的连接
        if ([self isBoundDevice]) { //重连绑定的蓝牙设备
            [[BLECommandHelper shareBLECommandHelper] connectToPeripheralWithUUIDString:[self currentDeviceUUID]];
        }
        return YES;
    }
    else {
        return NO;
    }
}

/**
 * 注销切换到匿名登录模式
 **/
+ (void)loginByAnonymousUser {
    
    [[BLECommandHelper shareBLECommandHelper] cancelCurrentPeripheral]; //断开蓝牙设备连接
    
    //=====================================================
    //因为匿名用户不需要上一次使用的数据，故每次重新启动APP时都需要删除匿名用户的所有数据
    //=====================================================
    User *anonymousUser = [UserDataAccessor findUserByUserId:kUserId_Anonymous];
    if (anonymousUser != nil && anonymousUser.deviceId != nil && ![anonymousUser.deviceId isEqualToString:@""]) {
        [DeviceDataAccessor deleteDeviceByDeviceId:anonymousUser.deviceId];//删除匿名用户绑定的设备
    }
    [UserDataAccessor deleteUserByUserId:kUserId_Anonymous];
    [SmokingDataAccessor deleteSmokingByUserId:kUserId_Anonymous];
    [SmokingDetailDataAccessor deleteSmokingDetailByUserId:kUserId_Anonymous];
    
    shareLoginUser = [[User AnonymousUser] copy];
    [UserDataAccessor saveUser:shareLoginUser];
    [self saveLoginUserSession:nil];
}


/**
 * 获取当前用户的信息(分为匿名模式与正常登录模式)
 **/
+ (User *)currentUser {
    if (shareLoginUser == nil) {
        long long userId    = [self getLoginUserId];
        shareLoginUser      = [UserDataAccessor findUserByUserId:userId];
        if (shareLoginUser == nil) {
            shareLoginUser              = [[User AnonymousUser] copy];
            shareLoginUser.userId       = userId;
            shareLoginUser.createDt     = [NSDate date];
            shareLoginUser.lastUpdateDt = [NSDate date];
            [UserDataAccessor saveUser:shareLoginUser];
        }
        shareLoginUser.session      = [self getLoginUserSession];
    }
    
    //========================================
    // 检查用户信息里面的设置值是否符合要求，若不符合则用保密值（没有保密值用最小值）替代
    //（主要防止设置修改用户信息时，选择器出现的数组越界）
    //========================================
    if (shareLoginUser.userGender!=SexTypeSecurity && shareLoginUser.userGender!=SexTypeMale && shareLoginUser.userGender!=SexTypeFemale) { //性别
        shareLoginUser.userGender   = SexTypeSecurity;
    }
    if (shareLoginUser.userAge<kUserAge_Minimum_Value || shareLoginUser.userAge>kUserAge_Maximum_Value) { //年龄
        shareLoginUser.userAge      = kUser_Security_Value;
    }
    if (shareLoginUser.smokeAge<kSmokeAge_Minimum_Value || shareLoginUser.smokeAge>kSmokeAge_Maximum_Value) { //烟龄
        shareLoginUser.smokeAge     = kUser_Security_Value;
    }
    if (shareLoginUser.userHeight<kUserHeight_Minimum_Value || shareLoginUser.userHeight>kUserHeight_Maximum_Value) { //身高
        shareLoginUser.userHeight   = kUser_Security_Value;
    }
    if (shareLoginUser.userWeight<kUserWeight_Minimum_Value || shareLoginUser.userWeight>kUserWeight_Maximum_Value) { //体重
        shareLoginUser.userWeight   = kUser_Security_Value;
    }
    if (shareLoginUser.homeInfo!=HomeInfoTypeTime && shareLoginUser.homeInfo!=HomeInfoTypeCount) { //首页显示类型
        shareLoginUser.homeInfo     = HomeInfoTypeTime;
    }
    if (shareLoginUser.language!=LanguageTypeSimplifiedChinese && shareLoginUser.language!=LanguageTypeEnglish) { //系统语言类型
        shareLoginUser.language     = LanguageTypeSimplifiedChinese;
    }
    
    if (shareLoginUser.planCount<kPlanCount_Minimum_Value || shareLoginUser.planCount>kPlanCount_Maximum_Value) { //计划吸烟口数
        shareLoginUser.planCount    = kPlanCount_Minimum_Value;
    }
    else {
        shareLoginUser.planCount    = shareLoginUser.planCount - (shareLoginUser.planCount%kPlanCount_Step_Value); //因为选择器只能一组固定值
    }
    if (shareLoginUser.planTime<kPlanTime_Minimum_Value || shareLoginUser.planTime>kPlanTime_Maximum_Value) {
        shareLoginUser.planTime     = kPlanTime_Minimum_Value;
    }
    else {
        shareLoginUser.planTime     = shareLoginUser.planTime - (shareLoginUser.planTime%kPlanTime_Step_Value); //因为选择器只能一组固定值
    }
    
    return shareLoginUser;
}

/**
 * 检查用户是否正常登录(非匿名)
 **/
+ (BOOL)isLogin {
    if ([self currentUser].userId != kUserId_Anonymous && [self currentUser].session != nil && ![[self currentUser].session isEqualToString:@""]) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 * 返回当前用户的会话Session
 **/
+ (NSString *)currentUserSession {
    if ([self isLogin]) {
        return [self currentUser].session;
    }
    else {
        return nil;
    }
}

/**
 * 返回当前用户的ID
 **/
+ (long long)currentUserId {
    return [self currentUser].userId;
}

/**
 * 将当前用户信息同步到本地数据库
 **/
+ (void)synchronizeCurrentUser {
    [UserDataAccessor saveUser:[self currentUser]];
}


//=====================================================================================
#pragma mark - 处理用户登录的辅助方法
//=====================================================================================
/**
 * 保存当前登录用户ID，会话的SessionNo（会话永不过期）
 **/
+ (void)saveLoginUserId:(long long)loginUserId {
    [[NSUserDefaults standardUserDefaults] setObject:@(loginUserId) forKey:kVape_LoginUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 保存用户的会话session（会话永不过期）
 **/
+ (void)saveLoginUserSession:(NSString *)loginUserSession {
    [[NSUserDefaults standardUserDefaults] setObject:loginUserSession forKey:kVape_LoginUserSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取当前登录用户ID，不存在时返回匿名用户ID
 **/
+ (long long)getLoginUserId {
    NSNumber *userIdNumber  = [[NSUserDefaults standardUserDefaults] objectForKey:kVape_LoginUserId];
    if (userIdNumber != nil) {
        return [userIdNumber longLongValue];
    }
    else {
        return kUserId_Anonymous;
    }
}

/**
 * 获取当前用户的会话session（会话永不过期）
 **/
+ (NSString *)getLoginUserSession {
    NSString *loginUserSession  = [[NSUserDefaults standardUserDefaults] objectForKey:kVape_LoginUserSession];
    if (loginUserSession != nil && ![loginUserSession isEqualToString:@""]) {
        return loginUserSession;
    }
    else {
        return nil;
    }
}


//=====================================================================================
#pragma mark - 用户的设备
//=====================================================================================
/**
 * 当前是否已经绑定设备
 **/
+ (BOOL)isBoundDevice {
    if ([self currentUser].deviceId != nil && ![[self currentUser].deviceId isEqualToString:@""]) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 * 用户当前绑定设备的UUID
 **/
+ (NSString *)currentDeviceUUID {
    if ([self isBoundDevice]) {
        return [self currentUser].deviceId;
    }
    else {
        return nil;
    }
}


/**
 * 返回用户当前绑定设备的详细信息
 **/
+ (Device *)currentDevice {
    if ([self isBoundDevice]) {
        Device *device = [DeviceDataAccessor findDeviceByDeiveId:[self currentDeviceUUID]];
        if (device == nil) {
            device = [[Device defaultValue] copy];
            device.deviceId     = [self currentDeviceUUID];
            device.createDt     = [NSDate date];
            device.lastUpdateDt = [NSDate date];
            [DeviceDataAccessor saveDevice:device];
        }
        return device;
    }
    else {
        return nil;
    }
}





//=====================================================================================
#pragma mark - 自动登录
//=====================================================================================
/**
 * 开始自动登录
 **/
- (BOOL)startAutoLogin {
    long long loginUserId   = [UserHelper getLoginUserId];
    if (loginUserId != kUserId_Anonymous) {
        User *user = [UserDataAccessor findUserByUserId:loginUserId];
        if (user != nil && user.password != nil && ![user.password isEqualToString:@""]) {
            LoginCommand *loginCommand = [[LoginCommand alloc] initLoginCommandWithPhone:user.phone Password:user.password];
            [self.tcpCommandHelper sendCommand:loginCommand];
            return YES;
        }
    }
    return NO;
}


//===============================================
#pragma mark TcpCommandHelperDelegate
//===============================================
/**
 * Socket调用正常返回
 **/
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    NSError *error;
    if (opCode == OperationCodeLogin) {
        LoginResponseMessage *loginResponseMsg = [LoginResponseMessage parseFromData:result error:&error];
        DebugLog(@"responseMsg: %@", loginResponseMsg);
        if (error == nil && loginResponseMsg != nil && loginResponseMsg.errorMsg.errorCode == 0) {
            User *user = [UserDataAccessor findUserByUserId:[UserHelper getLoginUserId]];
            [UserHelper loginByLoginResponseMsg:loginResponseMsg UserPassword:user.password];
        }
    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    
    
}


@end
