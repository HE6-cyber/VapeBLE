//
//  ShareSDKHelper.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "ShareSDKHelper.h"
#import <SMS_SDK/SMSSDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "TSMessage.h"
#import "StringHelper.h"

@interface ShareSDKHelper ()

@end

@implementation ShareSDKHelper

/**
 * 分享到新浪微博、QQ、QQ空间、微信、微信朋友圈
 **/
+ (void)shareWithShareContent:(ShareContent *)shareContent andView:(UIView *)view {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary new];
    NSMutableArray *images = [NSMutableArray new];
    if (shareContent.image != nil) {
        [images addObject:shareContent.image];
    }
    
    [shareParams SSDKSetupShareParamsByText:shareContent.content images:images url:nil title:shareContent.title type:SSDKContentTypeImage];
    
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess: {
                           [TSMessage showNotificationWithTitle:@"分享成功" type:TSMessageNotificationTypeSuccess];//@"分享成功"
                       }
                           break;
                       case SSDKResponseStateFail: {
                           [TSMessage showNotificationWithTitle:@"分享失败" type:TSMessageNotificationTypeError];//@"分享失败"
                       }
                           break;
                       case SSDKResponseStateCancel: {
//                           [TSMessage showNotificationWithTitle:@"取消分享" type:TSMessageNotificationTypeSuccess];
                       }
                           break;
                    default:
                           break;
                   }
                   
               }];
    
}

@end
