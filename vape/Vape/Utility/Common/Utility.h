//
//  Utility.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "MBProgressHUD.h"
#import <MagicalRecord/MagicalRecord.h>
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"

#import <SMS_SDK/SMSSDK.h>

#import "UIView+Common.h"
#import "UIColor+Expanded.h"
#import "UIImage+Common.h"
#import "NSDate+Common.h"
#import "NSString+Common.h"

#import "SizeHelper.h"
#import "ColorHelper.h"
#import "FontHelper.h"
#import "StringHelper.h"
#import "CValidator.h"

#import "UserHelper.h"
#import "ShareSDKHelper.h"

#import "IDGenerator.h"
#import "UserDataAccessor.h"
#import "SmokingDataAccessor.h"
#import "SmokingDetailDataAccessor.h"
#import "DeviceDataAccessor.h"
#import "HeartRateDataAccessor.h"

#import "RDVTabBarController.h"
#import "BaseNavigationController.h"

#define kDiscovery_PlaceholderImg       @"placeholderImg"

#define VIEW_CONTROLLER_IN_STORYBOARD(StoryBoardName, ViewControllerName) [[UIStoryboard storyboardWithName:StoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:ViewControllerName]

#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define kKeyWindow [UIApplication sharedApplication].keyWindow

@class AppDelegate;

@interface Utility : NSObject

//=====================================================================================
#pragma mark - 公用工具方法
//=====================================================================================
/** 获取本应用的委托对象 */
+ (AppDelegate *)getAppDelegate;

/** Returns the URL to the application's Documents directory. */
+ (NSURL *)applicationDocumentsDirectory;

/** 获取当前APP版本号 */
+ (NSString* )getAppVersion;


//=====================================================================================
#pragma mark - 检查是否有访问相册/访问相机的权限
//=====================================================================================
/** 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开. */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/** 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.*/
+ (BOOL)checkCameraAuthorizationStatus;

//=====================================================================
#pragma mark -  消息提示:MBProgressHUD
//=====================================================================
+ (void)showModeTextHUD:(NSString *)titleText AfterDelay:(NSInteger)afterDelay;
///显示菊花
+ (void)showIndicatorHUD:(NSString*)titleText;
///隐藏菊花
+ (void)hideIndicatorHUD;


//=====================================================================
#pragma mark -  屏幕截图
//=====================================================================
/** 对指定的视图进行截图 */
+ (UIImage *)screenshotByView:(UIView *)view;


//=====================================================================
#pragma mark -  本地通知
//=====================================================================
+ (void)scheduleLocalNotification:(NSObject *)object;

//=====================================================================
#pragma mark 颜色转换为图片
//=====================================================================
+ (UIImage *)createImageWithColor:(UIColor *)color;



//=====================================================================
#pragma mark -
//=====================================================================
/** 将秒数转换成HH:mm:ss格式的字符串 */
+ (NSString *)timeStringBySeconds:(NSInteger)seconds;
/** 将秒数转换成H:mm:ss格式的字符串 */
+ (NSString *)convertStringInHomePageBySeconds:(NSInteger)seconds;








@end
