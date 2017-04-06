//
//  AppDelegate.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocation    *userLocation; //用户的当前位置

- (MBProgressHUD *)shareProgressHUD;

///将应用的根控制器设置成RootTabBarViewController
- (void)setupRootTabBarViewController;

@end

