//
//  LoginViewController.h
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (assign, nonatomic) BOOL isBackToPreviousFunction; //是否回到前一个功能
@property (assign, nonatomic) BOOL isSessionExpired; //是否是会话过期

@property (copy, nonatomic) void(^didLogin)();
@property (copy, nonatomic) void(^didCancel)();

@end
