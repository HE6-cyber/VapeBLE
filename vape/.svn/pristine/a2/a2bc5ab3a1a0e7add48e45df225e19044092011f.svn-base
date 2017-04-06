//
//  Utility.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <BlocksKit/BlocksKit.h>
#import "UIAlertView+BlocksKit.h"


#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(keyPrompt) message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:LOCALIZED_STRING(keyConfirm) otherButtonTitles:nil] show]//@"提示" @"知道了"

@implementation Utility
//=====================================================================================
#pragma mark - 公用工具方法
//=====================================================================================
/**
 * 获取本应用的委托对象
 **/
+ (AppDelegate *)getAppDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

/**
 * Returns the URL to the application's Documents directory.
 **/
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 * 获取当前APP版本号
 **/
+ (NSString *)getAppVersion{
    NSDictionary *appInfo   = [[NSBundle mainBundle] infoDictionary];
    NSString *version       = [appInfo objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion  = [appInfo objectForKey:@"CFBundleVersion"];
    DebugLog(@"app version:%@.%@",version, buildVersion);
    return [NSString stringWithFormat:@"%@.%@", version, buildVersion];
}

//=====================================================================================
#pragma mark - 检查是否有访问相册/访问相机的权限
//=====================================================================================
/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus {
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:LOCALIZED_STRING(keyPleaseAllowAccessToAlbumsIniPhoneSettingsPrivacyPhotos)];//@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"
            return NO;
        }
    }
    return YES;
}

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(keyPrompt) message:LOCALIZED_STRING(keyTheDeviceDoesNotSupportTakingPictures) delegate:nil cancelButtonTitle:LOCALIZED_STRING(keyConfirm) otherButtonTitles:nil] show];//@"提示" @"该设备不支持拍照" @"知道了"
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:LOCALIZED_STRING(keyPleaseAllowAccessToTheCameraInTheiPhoneSettingsPrivacyCamera)];//@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"
            return NO;
        }
    }
    
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr {
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:LOCALIZED_STRING(keyPrompt) message:tipStr];//@"提示"
        [alertView bk_setCancelButtonWithTitle:LOCALIZED_STRING(keyCancel) handler:nil];
        [alertView bk_addButtonWithTitle:LOCALIZED_STRING(keySettings) handler:nil];
        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
            if (index == 1) {
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL];
                }
            }
        }];
        [alertView show];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(keyPrompt) message:tipStr delegate:nil cancelButtonTitle:LOCALIZED_STRING(keyConfirm) otherButtonTitles:nil] show];//@"提示" @"知道了"
    }
}


//=====================================================================
#pragma mark -  消息提示:MBProgressHUD
//=====================================================================
+(void)showModeTextHUD:(NSString *)titleText AfterDelay:(NSInteger)afterDelay {
    MBProgressHUD *hud = [[self getAppDelegate] shareProgressHUD];
    [hud.superview bringSubviewToFront:hud];
    
    hud.mode                    = MBProgressHUDModeText;
    hud.label.text              = titleText;
    hud.label.font              = [UIFont systemFontOfSize:12];
    hud.label.textColor         = [UIColor whiteColor];
    hud.bezelView.color         = kNavigationBar_Bg_Color;
    hud.contentColor            = [UIColor whiteColor];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:afterDelay];
}

///显示菊花
+(void)showIndicatorHUD:(NSString*)titleText {
    MBProgressHUD *hud = [[self getAppDelegate] shareProgressHUD];
    [hud.superview bringSubviewToFront:hud];
    
    hud.mode                            = MBProgressHUDModeIndeterminate;
    hud.label.text                      = titleText;
    hud.label.font                      = [UIFont systemFontOfSize:12];
    hud.label.textColor                 = [UIColor whiteColor];
    hud.detailsLabel.text               = @"";
    hud.detailsLabel.font               = [UIFont systemFontOfSize:12];
    hud.detailsLabel.textColor          = [UIColor whiteColor];
    hud.bezelView.layer.cornerRadius    = 5;
    hud.bezelView.color                 = kNavigationBar_Bg_Color;
    hud.contentColor                    = [UIColor whiteColor];
    [hud showAnimated:YES];
}

///隐藏菊花
+(void)hideIndicatorHUD {
    [[[self getAppDelegate] shareProgressHUD] hideAnimated:NO];
}


//=====================================================================
#pragma mark -  屏幕截图
//=====================================================================
/**
 * 对指定的视图进行截图
 **/
+ (UIImage *)screenshotByView:(UIView *)view {
    CGSize size = view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//=====================================================================
#pragma mark -  本地通知
//=====================================================================
+ (void)scheduleLocalNotification:(NSObject *)object {
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    // 2.2.设置通知的内容
    localNote.alertBody = [NSString stringWithFormat:@"%@", object];
    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
    localNote.alertAction = @"解锁";
    // 2.4.决定alertAction是否生效
    localNote.hasAction = NO;
    // 2.5.设置点击通知的启动图片
    localNote.alertLaunchImage = @"123Abc";
    // 2.6.设置alertTitle
    localNote.alertTitle = @"你有一条新通知";
    // 2.7.设置有通知时的音效
    localNote.soundName = @"buyao.wav";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 1;
    
    // 2.9.设置额外信息
    localNote.userInfo = @{@"type" : @1};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

//=====================================================================
#pragma mark 颜色转换为图片
//=====================================================================
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//=====================================================================
#pragma mark -
//=====================================================================
/** 
 *将秒数转换成HH:mm:ss格式的字符串 
**/
+ (NSString *)timeStringBySeconds:(NSInteger)seconds {
    NSInteger hour      = seconds / 3600;
    NSInteger minute    = (seconds % 3600) / 60;
    NSInteger second    = seconds % 60;
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
    if (hour>99) {
        [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
    }
    
    return timeString;
}

/**
 *将秒数转换成H:mm:ss格式的字符串
 **/
+ (NSString *)convertStringInHomePageBySeconds:(NSInteger)seconds {
    NSInteger hour      = seconds / 3600;
    NSInteger minute    = (seconds % 3600) / 60;
    NSInteger second    = seconds % 60;
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];

    return timeString;
}














@end
