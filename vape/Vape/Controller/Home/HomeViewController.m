//
//  HomeViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/6.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "HomeViewController.h"
#import "BLEBindDeviceCommand.h"
#import "BLEDataDecodingHelper.h"
#import "BLEFrame.h"
#import "BLECommandHelper.h"
#import "ProgressView.h"
#import "Masonry.h"


typedef NS_ENUM(NSUInteger, WorkingModel) {
    WorkingModelPower,
    WorkingModelVoltage,
    WorkingModelCentigrade,
    WorkingModelFahrenheit,
    WorkingModelRVW,
    WorkingModelRVV
};





@interface HomeViewController ()

@property (strong, nonatomic) BLECommandHelper *bleCommandHelper;
@property (strong, nonatomic) ProgressView     *progress;
@property (strong, nonatomic) NSMutableArray   *deviceArray;

@end

@implementation HomeViewController

//=====================================================================
#pragma mark - viewcontroller lifecycle
//=====================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialParameter];
    BLEBindDeviceCommand *bindDeviceCommand = [[BLEBindDeviceCommand alloc] initBLEBindDeviceCommandWithMacAddress:@[@(0xAA), @(0xBB), @(0xCC),@(0xDD),@(0xEE),@(0xFF)]];
    NSData *commandData = [bindDeviceCommand getCommandData];
    DebugLog(@"%@", commandData);
    BLEFrame *frame =  [BLEDataDecodingHelper decodeReceivedData:commandData macAddress:@[@(0xAA), @(0xBB), @(0xCC),@(0xDD),@(0xEE),@(0xFF)]];
    [self configureProgressView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self confiureBasicComponent];
    [[self.navigationController navigationBar]  setHidden:YES];
    
//    [self refreshWorkingModelInformationWithWorkingModel:WorkingModelPower      Value:@"0.5w"];
//    [self refreshWorkingModelInformationWithWorkingModel:WorkingModelVoltage    Value:@"0.5v"];
//    [self refreshWorkingModelInformationWithWorkingModel:WorkingModelCentigrade Value:@"0.5℃"];
    [self refreshWorkingModelInformationWithWorkingModel:WorkingModelFahrenheit Value:@"0.5℉"];
//    [self refreshWorkingModelInformationWithWorkingModel:WorkingModelRVV Value:nil];
//    [self refreshWorkingModelInformationWithWorkingModel:WorkingModelRVW Value:nil];
    
    //设置电阻值的字体更小
    [self.electricResistanceLabel setAttributedText:[self handleStringChangeToAttributeString:@"5Ω" isInfo:YES]];
    [self.rateLabel setText:@"15%"];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureBackGroundColor];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[self.navigationController navigationBar]  setHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.bleCommandHelper = [BLECommandHelper shareBLECommandHelper];
    [self.bleCommandHelper scan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverPeripheral:) name:BLECommandHelperNotification object:nil];
}


//============================================================
#pragma mark - Button click
//============================================================
- (IBAction)shareButtonClicked:(id)sender {
    
    
    
}





//============================================================
#pragma mark - Private method
//============================================================
- (void)discoverPeripheral:(NSNotification *)notifiction {
    BLEMessage *message = notifiction.userInfo[kUserInfo_Key_Message];
    BLENotificationCode notifictionCode = [message notificationCode];
    switch (notifictionCode) {
        case BLENotificationCodeDiscoverPeripheral:
            //存储设备的UUID，便于重新连接蓝牙设备
            
            
            //展示设备,用什么进行展示？？？
            
            
            
            break;
            
        default:
            break;
    }
}

//将声明的变量初始化
- (void)initialParameter {
    self.deviceArray = [NSMutableArray array];
}

- (void)configureProgressView {
    
    self.progress = [[ProgressView alloc] initWithFrame:CGRectZero];
    [self.progressView addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.progressView.mas_width);
        make.height.mas_equalTo(self.progressView.mas_height);
        make.centerX.equalTo(self.progressView.mas_centerX).offset(0);
        make.centerY.equalTo(self.progressView.mas_centerY).offset(0);
    }];
    
    [self.progress setPlanCount:@"600"];
    [self.progress setInFactcount:@"600"];
    [self.progressView addSubview:self.progress];
}

//配置渐变色
- (void)configureBackGroundColor {
    
    CAGradientLayer *gradualLayer = [CAGradientLayer layer];
    [self.backGroundColorView.layer addSublayer:gradualLayer];
    [gradualLayer setFrame:CGRectMake(0, 0, self.view.size.width, self.backGroundColorView.bounds.size.height)];
    
    //设置渐变色的起始位置
    [gradualLayer setStartPoint:CGPointMake(0, 1)];
    [gradualLayer   setEndPoint:CGPointMake(1, 0)];
    
    //设置颜色数组
    [gradualLayer setColors:@[(__bridge id)[UIColor colorWithRed:53.f/255 green:215.f/255  blue:255.f/255 alpha:1].CGColor,
                              (__bridge id)[UIColor colorWithRed:38.f/255 green:120.f/255  blue:230.f/255 alpha:1].CGColor]];
    
    gradualLayer.locations = @[@(0.23f),@(0.7f),@(0.9f)];
}

- (void)confiureBasicComponent {
    //设置心率测试按钮
    [self.heartRateTestButton setBorderWidth:1.0];
    [[self.heartRateTestButton layer] setCornerRadius:20];
    [self.heartRateTestButton setBorderColor:[UIColor whiteColor]];
    
    //设置工作模式 温度为红色字体
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self.workModelLabel text]];
    NSRange range = NSMakeRange(4, 4);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [self.workModelLabel setAttributedText:string];
}

- (void)refreshWorkingModelInformationWithWorkingModel:(WorkingModel)workingModel Value:(NSString *)valueString{
    
    //不同工作模式下设置不同的显示内容
    switch (workingModel) {
        case WorkingModelPower:{
            NSString *string = @"功率模式(瓦特)";
            [self.workModelLabel setAttributedText:[self handleStringChangeToAttributeString:string isInfo:NO]];
            
            //设置Label后面单位的字体更小一点
            [self.modelInfomationLabel setAttributedText:[self handleStringChangeToAttributeString:valueString isInfo:YES]];
        }
            break;
            
        case WorkingModelVoltage:{
            NSString *string = @"电压模式(伏特)";
            [self.workModelLabel setAttributedText:[self handleStringChangeToAttributeString:string isInfo:NO]];
            
            //设置Label后面单位的字体更小一点
            [self.modelInfomationLabel setAttributedText:[self handleStringChangeToAttributeString:valueString isInfo:YES]];
        }
            break;
            
        case WorkingModelCentigrade:{
            NSString *string = @"温度模式(摄氏度)";
            [self.workModelLabel setAttributedText:[self handleStringChangeToAttributeString:string isInfo:NO]];
            
            //设置Label后面单位的字体更小一点
            [self.modelInfomationLabel setAttributedText:[self handleStringChangeToAttributeString:valueString isInfo:YES]];
        }
            break;
            
        case WorkingModelFahrenheit:{
            NSString *string = @"温度模式(华氏度)";
            [self.workModelLabel setAttributedText:[self handleStringChangeToAttributeString:string isInfo:NO]];
            
            //设置Label后面单位的字体更小一点
            [self.modelInfomationLabel setAttributedText:[self handleStringChangeToAttributeString:valueString isInfo:YES]];
        }
            break;
            
        case WorkingModelRVW:{
            NSString *string = @"RVW模式";
            [self.workModelLabel setText:string];
//            [self.modelInfomationLabel setAttributedText:[self handleStringChangeToAttributeStringWithString:string]];
            [self.modelInfomationLabel setText:@"不知道显示什么"];
        }
            break;
            
        case WorkingModelRVV:{
            NSString *string = @"RVV模式";
            [self.workModelLabel setText:string];
//            [self.modelInfomationLabel setAttributedText:[self handleStringChangeToAttributeStringWithString:string]];
            [self.modelInfomationLabel setText:@"不知道显示什么"];
        }
            break;
            
        default:
            break;
            
    }

}

//YES就是改变字体   NO就是改变固定的label后面几个字体颜色
- (NSMutableAttributedString *)handleStringChangeToAttributeString:(NSString *)string isInfo:(BOOL)isInfo {
    
    NSMutableAttributedString *targetString = [[NSMutableAttributedString alloc] initWithString:string];
    
    if (isInfo) {
        NSRange range = NSMakeRange(string.length-1, 1);
        [targetString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range];
    } else {
        NSRange range = NSMakeRange(4, string.length-4);
        [targetString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    
    return targetString;
}


@end
