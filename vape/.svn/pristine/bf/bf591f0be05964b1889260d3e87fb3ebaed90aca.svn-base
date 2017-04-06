//
//  AppDelegate.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"
#import "HomeViewController.h"
#import "BLEEncryptDescryptHelper.h"
#import "RootTabBarController.h"

#define kMBProgressHUD_TagValue       900001

@interface AppDelegate ()

@property (strong, nonatomic) MBProgressHUD         *progressHUD;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
//    //=========================================
//    //  初始化RC5秘钥
//    //=========================================
//    EnDeCryptInit();
    
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
    // MBProgressHUD初始化
    //=========================================
    self.progressHUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:self.progressHUD];
    [self.progressHUD setTag:kMBProgressHUD_TagValue];
    
    [self.window makeKeyAndVisible];
    
    //后面需要修改
    [self setupRootTabBarViewController];
    
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

- (void)setupRootTabBarViewController {
    RootTabBarController *rootTabBarVC = [[RootTabBarController alloc] init];
    [self.window setRootViewController:rootTabBarVC];
}

@end
