//
//  BaseViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BaseViewController.h"

static const NSInteger  kTagValue_BackButton    = 99999;

@interface BaseViewController () {

}

@end

@implementation BaseViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.bleHelper = [BLECommandHelper shareBLECommandHelper];
    self.tcpHelper = [TcpCommandHelper shareTcpCommandHelperWithDelegate:self];
    [TSMessage iOS7StyleEnabled];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [TSMessage setDelegate:self];
    [TSMessage setDefaultViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBLENotification:) name:BLECommandHelperNotification object:nil];
    
    
    //===========================去掉NavigationBar底部的黑线=================================
    [self.navigationController.navigationBar setBackgroundImage:[Utility createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[Utility createImageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar setShadowImage:[Utility createImageWithColor:[UIColor clearColor]]];
    
    [self.tabBarController.tabBar setBackgroundImage:[Utility createImageWithColor:[UIColor clearColor]]];
    [self.tabBarController.tabBar setShadowImage:[Utility createImageWithColor:[UIColor clearColor]]];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TSMessage dismissActiveNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLECommandHelperNotification object:nil];
    [Utility hideIndicatorHUD]; //当视图控制器将要消失时，隐藏该视图的菊花 Added By Zhoucy 2016-11-13 23:34
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - 设置导航栏样式
//=====================================================================================
- (void)setupNavigationBar {
    //状态栏字体颜色；必须在info.plist中添加“View controller-based status bar appearance = NO”才能生效
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //将导航栏设置为不透明效果
    [self.navigationController.navigationBar setTranslucent:NO];
    //导航栏背景颜色颜色
    [self.navigationController.navigationBar setBarTintColor:kNavigationBar_Bg_Color];
    //导航栏回退按钮的字体颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏中间标题的字体样式
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    //自定义导航栏上的返回按钮
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    backItem.title =@"  ";
    self.navigationItem.backBarButtonItem = backItem;
}

/**
 * 在NavigationBar左边添加同步按钮
 **/
- (void)setupSyncButtonInLeftBarButtonItem {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cloud22"] style:UIBarButtonItemStylePlain target:self action:@selector(onSyncButton:)] animated:NO];
}

/**
 * 在NavigationBar右边添加分享按钮
 **/
- (void)setupShareButtonInRightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share22"] style:UIBarButtonItemStylePlain target:self action:@selector(onShareButton:)] animated:NO];
}


/**
 * 在NavigationBar左边添加透明的BackButton按钮
 **/
- (void)addBackButtonInNavigationBar {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.navigationController.navigationBar addSubview:backButton];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTag:kTagValue_BackButton];
    [backButton addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 * 从NavigationBar上移除BackButton按钮
 **/
- (void)removeBackButtonFromNavigationBar {
    UIButton *backButton = [self.navigationController.navigationBar viewWithTag:kTagValue_BackButton];
    [backButton removeFromSuperview];
}

//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    switch (message.notificationCode) {
        case BLENotificationCodeDevicePowerOn: {
            if ([UserHelper isBoundDevice]) { /* 开启蓝牙功能时自动重连用户的默认设备 */
                [[BLECommandHelper shareBLECommandHelper] connectToPeripheralWithUUIDString:[UserHelper currentDeviceUUID]];
            }
        }
            break;
        case BLENotificationCodeDiscoverPeripheral: {
            
        }
            break;
        case BLENotificationCodeSucceedToConnectPeripheral: {
            [self showSuccessMessage:@"烟具连接成功"];
        }
            break;
        case BLENotificationCodeInitPeripheralCompleted: {
            
        }
            break;
        case BLENotificationCodeReceiveNotifyForCharacteristic: {
            
        }
            break;
        case BLENotificationCodeDeviceUnSupported: { /* 当蓝牙功能未启用时，所有对蓝牙设备进行的操作直接中止 */
            [self showErrorMessage:@"蓝牙功能未启用"];
            [Utility hideIndicatorHUD];
        }
            break;
        case BLENotificationCodeNotAddDevice: { 
            [self showErrorMessage:@"未添加设备"];
        }
            break;
        case BLENotificationCodeDiscoverDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeConnectDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeInitDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeFailToPerformOperation: {
            
        }
            break;
        case BLENotificationCodeDisconnectPeripheral: { /* 设备连接断开，则中止 */
            [Utility hideIndicatorHUD];
            [self showErrorMessage:@"烟具连接已断开"];//
        }
            break;
        case BLENotificationCodeReconnectDeviceTimeOut: {
            [Utility hideIndicatorHUD];
            [self showErrorMessage:@"设备重连超时"];
        }
            break;
        case BLENotificationCodeNotFoundDevice: { /* 使用设备UUID重连时，没有找到设备 */
            [Utility hideIndicatorHUD];
            [self showErrorMessage:@"未找到可重连设备"]; //
        }
            break;
        case BLENotificationCodeFailToConnect: {
            
        }
            break;
    }
    
}


//=====================================================================
#pragma mark -  消息提示:TSMessage
//=====================================================================
- (void)showErrorMessage:(NSString *)message {
    [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeError];
}
- (void)showSuccessMessage:(NSString *)message {
    [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeSuccess];
}




//=====================================================================================
#pragma mark - Button事件处理方法
//=====================================================================================
- (void)onShareButton:(UIButton *)sender {
}

- (void)onSyncButton:(UIButton *)sender {
    
}

- (void)onBackButton:(UIButton *)sender {
    
}

//===================================================================================
#pragma mark - UITextFieldDelegate
//===================================================================================
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}


//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    
}

- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [Utility hideIndicatorHUD];
    if (errorCode == ReturnErrorCodeNotNetwork) {
        [self showErrorMessage:errorMsg];
    }
    else if (errorCode == ReturnErrorCodeSocketNotConnected) {
        //当网络被断开时，socket会发送该错误
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyTryAgain)];
    }
}











@end
