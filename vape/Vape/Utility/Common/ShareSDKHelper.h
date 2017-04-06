//
//  ShareSDKHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareContent.h"

@class UIView;

@interface ShareSDKHelper : NSObject

///分享到新浪微博、QQ、QQ空间、微信、微信朋友圈
+ (void)shareWithShareContent:(ShareContent *)shareContent andView:(UIView *)view;

@end

