//
//  BaseViewController.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetMultipleStringPicker.h"
#import "AppDelegate.h"
#import "TcpCommandHelper.h"
#import "BLECommandHelper.h"
#import "UserDataAccessor.h"
#import "User.h"
#import "Device.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>



@interface BaseViewController : UIViewController <TcpCommandHelperDelegate, UITextFieldDelegate,UITextViewDelegate, TSMessageViewProtocol>

@property (strong, nonatomic) BLECommandHelper  *bleHelper;
@property (strong, nonatomic) TcpCommandHelper  *tcpHelper;

///在NavigationBar右边添加分享按钮
- (void)setupShareButtonInRightBarButtonItem;

///在NavigationBar左边添加同步按钮
- (void)setupSyncButtonInLeftBarButtonItem;

///分享按钮的点击事件处理方法
- (void)onShareButton:(UIButton *)sender;

///同步按钮的点击事件处理方法
- (void)onSyncButton:(UIButton *)sender;

///返回按钮的事件处理方法
- (void)onBackButton:(UIButton *)sender;


/** 在NavigationBar左边添加透明的BackButton按钮 */
- (void)addBackButtonInNavigationBar;
/** 从NavigationBar上移除BackButton按钮 */
- (void)removeBackButtonFromNavigationBar;


- (void)handleBLENotification:(NSNotification *)notification;


//=====================================================================
#pragma mark -  消息提示:TSMessage
//=====================================================================
- (void)showErrorMessage:(NSString *)message;
- (void)showSuccessMessage:(NSString *)message;



@end
