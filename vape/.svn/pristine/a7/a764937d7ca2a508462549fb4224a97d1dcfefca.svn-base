//
//  HeartRateViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "HeartRateViewController.h"
#import "M13ProgressViewRing.h"

static const NSInteger kDetectHeartRate_Timeout = 20; //超时时间20秒，
static const double kTimer_TimeInterval         = 0.1f; //每0.2秒调用一次定时器

@interface HeartRateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView            *heartRateImgView;
@property (weak, nonatomic) IBOutlet UIView                 *startButtonBackView;
@property (weak, nonatomic) IBOutlet UILabel                *startButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton               *startButton;
@property (weak, nonatomic) IBOutlet UIView                 *backgroundColorView;

@property (weak, nonatomic) IBOutlet M13ProgressViewRing    *progressView;


@property (weak, nonatomic) IBOutlet UILabel                *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel                *bloodOxygenLabel;
@property (weak, nonatomic) IBOutlet UIView                 *heartRateBackView;
@property (weak, nonatomic) IBOutlet UIView                 *bloodOxygenBackView;



- (IBAction)onStartButton:(UIButton *)sender;


@property (strong, nonatomic) NSTimer   *timerForDetectHeartRateAndBloodOxygen;
@property (assign, nonatomic) NSInteger counter; //计数器

@end

@implementation HeartRateViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyHeartRateAndBloodOxygen);//@"心率血氧";
    
    [self setupBorderLineConstraint];
    if ([UserHelper isLogin]) {
         [self setupHistoryButtonInRightBarButtonItem];
    }
    
    self.progressView.progressRingWidth = 8.5f;
    self.progressView.backgroundRingWidth = 8.5f;
    self.progressView.primaryColor = kNavigationBar_Bg_Color;
    self.progressView.secondaryColor = RGB_COLOR(230, 230, 230);
    self.progressView.showPercentage = NO;
    
    CGFloat progressTextFontSize = 55;
    switch (kiPhone_Version) {
        case kiPhone_4_7:
            progressTextFontSize = 65;
            break;
        case kiPhone_5_5:
            progressTextFontSize = 75;
            break;
        default:
            break;
    }

    [self.startButtonLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Regular" size:progressTextFontSize]];
//    HeartRate *heartRate = [HeartRate new];
//    heartRate.heartRate = 80;
//    heartRate.bloodOxygen = 101;
    [self showHeartRate:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self abortTimerForDetectHeartRateAndBloodOxygen];
}

//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    //设置startButton的边框
    self.backgroundColorView.layer.borderWidth      = 0;
    self.backgroundColorView.layer.borderColor      = [UIColor clearColor].CGColor;
    self.backgroundColorView.layer.cornerRadius     = kScreen_Width/4;
}

/**
 * 重置界面
 **/
- (void)reset {
    [self.startButton setHidden:NO];
    [self.startButton setTitle:LOCALIZED_STRING(keyStartingTest) forState:UIControlStateNormal];//@"开始检测"
    [self.startButtonLabel setHidden:YES];
    self.counter = kDetectHeartRate_Timeout / kTimer_TimeInterval;
    [self.progressView setProgress:0 animated:NO];
}

/**
 * 在NavigationBar右边添加历史按钮
 **/
- (void)setupHistoryButtonInRightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"History"] style:UIBarButtonItemStylePlain target:self action:@selector(onHistoryButton:)] animated:NO];
}

//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    [super handleBLENotification:notification];
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    
    switch (message.notificationCode) {
        case BLENotificationCodeReceiveNotifyForCharacteristic: {
//            if (message.bleOpCode == BLEOperationCodeDetectHeartRateAndBloodOxygen) {
//                [self showHeartRate:message.heartRate];
//                [self abortTimerForDetectHeartRateAndBloodOxygen];
//            }
        }
            break;
        case BLENotificationCodeFailToPerformOperation: {
            [self showErrorMessage:LOCALIZED_STRING(keyHeartRateAndBloodOxygenDetectionFailedPleaseCheckIfTheDeviceConnectedProperly)];//@"心率血氧检测失败，请检查设备连接是否正常"
            [self abortTimerForDetectHeartRateAndBloodOxygen];
        }
            break;
        case BLENotificationCodeDeviceUnSupported:
        case BLENotificationCodeConnectDeviceTimeOut:
        case BLENotificationCodeInitDeviceTimeOut:
        case BLENotificationCodeDisconnectPeripheral: {
            [self abortTimerForDetectHeartRateAndBloodOxygen];
        }
            break;
        case BLENotificationCodeFailToConnect: {
            
        }
            break;
    }
    
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 发送心率血氧检测指令
 **/
- (void)sendDetectHeartRateAndBloodOxygenCommand {
//    BLEDetectHeartRateAndBloodOxygenCommand *detectHeartRateAndBloodOxygenCommand = [[BLEDetectHeartRateAndBloodOxygenCommand alloc] initDetectHeartRateAndBloodOxygenCommand];
//    [[BLECommandHelper shareBLECommandHelper] sendOperationCommandWithoutResponse:detectHeartRateAndBloodOxygenCommand];
}


/**
 * 显示心率血氧数据
 **/
- (void)showHeartRate:(HeartRate *)heartRate {
    if (heartRate != nil) {
        NSDictionary *valueStyleDict = @{NSFontAttributeName: [UIFont fontWithName:kNumber_Font_Name_Regular size:30],
                                         NSForegroundColorAttributeName: [UIColor whiteColor]};
        NSDictionary *unitStyleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                        NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        //显示心率
        NSString *unitString = LOCALIZED_STRING(keyTimesPerSecond);
        NSString *heartRateValueString = [NSString stringWithFormat:@"%ld%@", (long)heartRate.heartRate, unitString];
        NSMutableAttributedString *heartRateAttributedString = [[NSMutableAttributedString alloc] initWithString:heartRateValueString];
        [heartRateAttributedString addAttributes:valueStyleDict range:NSMakeRange(0, heartRateValueString.length-unitString.length)];
        [heartRateAttributedString addAttributes:unitStyleDict range:NSMakeRange(heartRateValueString.length-unitString.length, unitString.length)];
        self.heartRateLabel.attributedText = heartRateAttributedString;
        
        //显示血氧
        NSString *bloodOxygenValueString = [NSString stringWithFormat:@"%ld%@", (long)heartRate.bloodOxygen, @"%"];
        NSMutableAttributedString *bloodOxygenAttributedString = [[NSMutableAttributedString alloc] initWithString:bloodOxygenValueString];
        [bloodOxygenAttributedString addAttributes:valueStyleDict range:NSMakeRange(0, bloodOxygenValueString.length-1)];
        [bloodOxygenAttributedString addAttributes:unitStyleDict range:NSMakeRange(bloodOxygenValueString.length-1, 1)];
        self.bloodOxygenLabel.attributedText = bloodOxygenAttributedString;
        
        //设置背景色
        [self.heartRateBackView setBackgroundColor:([heartRate isNormalByHeartRateValue]?kHeartRate_Normal_BgColor:kHeartRate_Abnormal_BgColor)];
        [self.bloodOxygenBackView setBackgroundColor:([heartRate isNormalByBloodOxygenValue]?kHeartRate_Normal_BgColor:kHeartRate_Abnormal_BgColor)];
    }
    else {
        self.heartRateLabel.text = @"--";
        self.bloodOxygenLabel.text = @"--";
        [self.heartRateLabel setFont:[UIFont fontWithName:kNumber_Font_Name_Regular size:30]];
        [self.bloodOxygenLabel setFont:[UIFont fontWithName:kNumber_Font_Name_Regular size:30]];
        [self.heartRateBackView setBackgroundColor:kHeartRate_Normal_BgColor];
        [self.bloodOxygenBackView setBackgroundColor:kHeartRate_Normal_BgColor];
    }
    
}



//=====================================================================================
#pragma mark - Button事件处理方法
//=====================================================================================
/**
 * 启动心率检测
 **/
- (IBAction)onStartButton:(UIButton *)sender {
    
    if ([BLECommandHelper shareBLECommandHelper].connectStatus == BLEConnectStatusDeviceInitCompleted) {
        self.heartRateLabel.text = @"--";
        self.bloodOxygenLabel.text = @"--";
        [self startTimerForDetectHeartRateAndBloodOxygen];
        [self sendDetectHeartRateAndBloodOxygenCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyNotConnectedToTheDevicePleaseConnectTheDeviceAndThenTryAgain)];//@"未连接设备,请您先连接设备再重试"
    }
    
}

- (void)onHistoryButton:(UIButton *)sender {
    BaseViewController *heartRateHistoryListVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Main, @"HeartRateHistoryViewController");
    [self.navigationController pushViewController:heartRateHistoryListVC animated:YES];
}


//=====================================================================================
#pragma mark - 心率检测定时器
//=====================================================================================
/**
 * 启动心率监测定时器
 **/
- (void)startTimerForDetectHeartRateAndBloodOxygen {
    [self abortTimerForDetectHeartRateAndBloodOxygen];
    [self.startButton setHidden:YES];
    [self.startButtonLabel setHidden:NO];
    self.timerForDetectHeartRateAndBloodOxygen = [NSTimer scheduledTimerWithTimeInterval:kTimer_TimeInterval target:self selector:@selector(handleTimerForDetectHeartRateAndBloodOxygen:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timerForDetectHeartRateAndBloodOxygen forMode:NSRunLoopCommonModes];
}

/**
 * 中止心率监测定时器
 **/
- (void)abortTimerForDetectHeartRateAndBloodOxygen {
    if (self.timerForDetectHeartRateAndBloodOxygen != nil) {
        if ([self.timerForDetectHeartRateAndBloodOxygen isValid]) {
            [self.timerForDetectHeartRateAndBloodOxygen invalidate];
        }
        self.timerForDetectHeartRateAndBloodOxygen = nil;
    }
    [self reset];
}

/**
 * 处理发现设备超时
 **/
- (void)handleTimerForDetectHeartRateAndBloodOxygen:(NSTimer *)timer {
    self.counter--;
    NSInteger value = ceil(self.counter*kTimer_TimeInterval);//向上取整
    [self.startButtonLabel setText:[NSString stringWithFormat:@"%ld", (long)value]];
    [self.progressView setProgress:1-(self.counter/(kDetectHeartRate_Timeout/kTimer_TimeInterval)) animated:YES];
    if (self.counter <= 0) {
        [self abortTimerForDetectHeartRateAndBloodOxygen];
    }
}



@end
