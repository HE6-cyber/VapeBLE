//
//  AppDelegate.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"
#import <SMS_SDK/SMSSDK.h>

//==================ShareSDK====================
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//==============================================

//==================BaiduMap====================
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
//==============================================
#import "RootTabBarViewController.h"
#import "AppEntryPageViewController.h"

#define kMBProgressHUD_TagValue         900001
#define kSMS_APPKEY                     @"f3fc6baa9ac4"
#define kSMS_APP_SECRECT                @"7f3dedcb36d92deebcb373af921d635a"
#define kBAIDU_MAP_KEY                  @"jbA88pUfqPWHgXHV6Ck7ylHb3O0qbiwX"

@interface AppDelegate ()<BMKGeneralDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MBProgressHUD         *progressHUD;
@property (strong, nonatomic) BMKMapManager         *baiduMapManager;
@property (strong, nonatomic) CLLocationManager     *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    //=========================================
    // 网络连通性检测
    //=========================================
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable: {
                //网络连接断开
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //网络连接正常
            }
                
            default:
                break;
        }
    }];
    
    //=========================================
    // MagicalRecord初始化
    //=========================================
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Vape.xcdatamodeld"];
    
    //=========================================
    //百度地图初始化
    //=========================================
    self.baiduMapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.baiduMapManager start:kBAIDU_MAP_KEY generalDelegate:self];
    if (!ret) {
        DebugLog(@"manager start failed!");
    }
    
    //=========================================
    //初始化短信验证框架
    //=========================================
    [SMSSDK registerApp:kSMS_APPKEY withSecret:kSMS_APP_SECRECT];
    
    //=========================================
    // 初始化ShareSDK
    //=========================================
    [self setupShareSDK];
    
    //=========================================
    //设置启动APP时首先显示的视图控制器
    //=========================================
    if ([UserHelper isLogin]) {
        [self setupRootTabBarViewController];
        if ([UserHelper isBoundDevice]) { //重连绑定的蓝牙设备
            [[BLECommandHelper shareBLECommandHelper] connectToPeripheralWithUUIDString:[UserHelper currentDeviceUUID]];
        }
//        [[SyncDataHelper shareSyncDataHelperWithDelegate:self] startDownloadSmokingData];
    }
    else {
        [self setupAppEntryPageViewController];
    }
    
    //=========================================
    // MBProgressHUD初始化
    //=========================================
    self.progressHUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:self.progressHUD];
    [self.progressHUD setTag:kMBProgressHUD_TagValue];
    
    [self.window makeKeyAndVisible];
    
    //后面需要修改
//    [self setupRootTabBarViewController];
    
    //=========================================
    // 开启GPS定位
    //=========================================
//    [self startUpdateUserLocation];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // MagicalRecord清理
    [MagicalRecord cleanUp];
}



//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
- (MBProgressHUD *)shareProgressHUD {
    return self.progressHUD;
}


/**
 * 配置ShareSDK
 **/
- (void)setupShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQZone)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn/"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                            appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:@"100371282"
                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                         authType:SSDKAuthTypeSSO];
                      break;
                  default:
                      break;
              }
          }];
    
}

//=====================================================================================
#pragma mark - 获取实时定位
//=====================================================================================
/**
 * 实时获取手机的GPS坐标
 **/
- (void)startUpdateUserLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeOther;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        if([[[UIDevice currentDevice] systemVersion]floatValue] >=8) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    if([[[UIDevice currentDevice] systemVersion]floatValue] >=9) {
        self.locationManager.allowsBackgroundLocationUpdates=YES;
    }
}

//=====================================================================================
#pragma mark - CLLocationManagerDelegate
//=====================================================================================
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DebugLog(@"status---------%d------------", status);
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //    [Utility scheduleLocalNotification:[locations firstObject]];
    self.userLocation = [locations firstObject];
    
    //    NSLog(@"location-----------:%@", self.userLocation);
}

//=====================================================================================
#pragma mark - BMKGeneralDelegate
//=====================================================================================
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        DebugLog(@"联网成功");
    }
    else{
        DebugLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        DebugLog(@"授权成功");
    }
    else {
        DebugLog(@"onGetPermissionState %d",iError);
    }
}


//=====================================================================================
#pragma mark - 设置应用的根控制器
//=====================================================================================
/**
 * 将应用的根控制器设置成RootTabBarViewController
 **/
- (void)setupRootTabBarViewController {
    RootTabBarViewController *rootTabBarVC = [[RootTabBarViewController alloc] init];
    rootTabBarVC.tabBar.translucent = YES;
    [self.window setRootViewController:rootTabBarVC];
}


- (void)setupAppEntryPageViewController {
    AppEntryPageViewController *appEntryPageVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"AppEntryPageViewController");
    BaseNavigationController *navigationVC = [[BaseNavigationController alloc] initWithRootViewController:appEntryPageVC];
    [self.window setRootViewController:navigationVC];
}


@end
