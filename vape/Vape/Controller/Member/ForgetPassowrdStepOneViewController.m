//
//  ForgetPassowrdStepOneViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "ForgetPassowrdStepOneViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "ForgetPasswordStepTwoViewController.h"

@interface ForgetPassowrdStepOneViewController ()


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (weak, nonatomic) IBOutlet UILabel    *verifyCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeButton;

- (IBAction)onGetVerifyCodeButton:(UIButton *)sender;
- (IBAction)onVerificationButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLine1WidthConstraint;

@property (strong, nonatomic) NSTimer   *timerForGetVerifyCode;
@property (assign, nonatomic) NSInteger counter;

@end

@implementation ForgetPassowrdStepOneViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyForgotPassword);//@"忘记密码";
    [self setupBorderLineConstraint];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    User *user = [UserDataAccessor findUserByUserId:[UserHelper getLoginUserId]];
    [self.phoneTextField setText:(user!=nil?user.phone:@"")];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - 工具方法
//=====================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    self.bottomLine1HeightConstraint.constant   = kBorder_Line_Height;
    self.bottomLine2HeightConstraint.constant   = kBorder_Line_Height;
    self.leftLine1WidthConstraint.constant      = kBorder_Line_Width;
}


//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
- (IBAction)onGetVerifyCodeButton:(UIButton *)sender {
    
    NSString *phoneNumber = self.phoneTextField.text;
    
    CValidator *validator = [[CValidator alloc] init];
    [validator validateCellphoneNo:phoneNumber FieldName:LOCALIZED_STRING(keyPhoneNumber)];//@"手机号码"
    
    if ([validator isValid]) {
        __weak typeof(self) weakSelf = self;
        [Utility showIndicatorHUD:@""];
        [self startTimerForGetVerifyCode];
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                                phoneNumber:phoneNumber
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error) {
                                         [Utility hideIndicatorHUD];
                                         if (!error) {
                                             [weakSelf showSuccessMessage:LOCALIZED_STRING(keyGetVerificationCodeSuccessful)];//@"获取验证码成功"
                                         }
                                         else {
                                             DebugLog(@"错误信息：%@", error);
                                             [weakSelf showErrorMessage:LOCALIZED_STRING(keyGetVerificationCodeFailed)];//@"获取验证码失败"
                                             [weakSelf abortTimerForGetVerifyCode];
                                         }
                                     }];
    }
    else {
        NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
        [self showErrorMessage:errorMsg];
    }
    
}

- (IBAction)onVerificationButton:(UIButton *)sender {
    
    NSString *phoneNumber   = self.phoneTextField.text;
    NSString *verifyCode    = self.verifyCodeTextField.text;
    
    CValidator *validator = [[CValidator alloc] init];
    [validator validateCellphoneNo:phoneNumber FieldName:LOCALIZED_STRING(keyPhoneNumber)];//@"手机号码"
    [validator validateRequired:verifyCode FieldName:LOCALIZED_STRING(keySMSCode)];//@"验证码"
    
    if ([validator isValid]) {
        __weak typeof(self) weakSelf = self;
        [Utility showIndicatorHUD:@""];
        [SMSSDK commitVerificationCode:verifyCode
                           phoneNumber:phoneNumber
                                  zone:@"86"
                                result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                                    [Utility hideIndicatorHUD];
                                    if (!error) {
                                        DebugLog(@"验证成功！");
                                        ForgetPasswordStepTwoViewController *forgetPasswordStepTwoVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"ForgetPasswordStepTwoViewController");
                                        forgetPasswordStepTwoVC.userPhone = phoneNumber;
                                        [weakSelf.navigationController pushViewController:forgetPasswordStepTwoVC animated:YES];
                                    }
                                    else {
                                        DebugLog(@"错误信息：%@", error);
                                        [weakSelf showErrorMessage:LOCALIZED_STRING(keyPleaseEnterTheCorrectVerificationCode)];//@"请输入正确的验证码."
                                    }
        }];
    }
    else {
        NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
        [self showErrorMessage:errorMsg];
    }
    
}

//=====================================================================================
#pragma mark - 获取验证码定时器
//=====================================================================================
/**
 * 开始执行获取验证码定时器
 **/
- (void)startTimerForGetVerifyCode {
    [self abortTimerForGetVerifyCode];
    self.counter = 90;
    self.timerForGetVerifyCode = [NSTimer timerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(handleTimerForGetVerifyCode)
                                                       userInfo:nil
                                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timerForGetVerifyCode forMode:NSRunLoopCommonModes];
    [self.verifyCodeLabel setTextColor:[UIColor lightGrayColor]];
    [self.verifyCodeLabel setFont:[UIFont systemFontOfSize:15]];
    [self.verifyCodeLabel setText:[NSString stringWithFormat:@"%ld%@", (long)self.counter, LOCALIZED_STRING(keyUnitSecond)]];//秒
    [self.getVerifyCodeButton setEnabled:NO];
}

/**
 * 中止执行获取验证码定时器
 **/
- (void)abortTimerForGetVerifyCode {
    if (self.timerForGetVerifyCode != nil) {
        if ([self.timerForGetVerifyCode isValid]) {
            [self.timerForGetVerifyCode invalidate];
        }
        self.timerForGetVerifyCode = nil;
    }
    [self.verifyCodeLabel setTextColor:kNavigationBar_Bg_Color];
    [self.verifyCodeLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [self.verifyCodeLabel setText:LOCALIZED_STRING(keySendSMSCode)];//@"发送验证码"
    [self.getVerifyCodeButton setEnabled:YES];
    
}

/**
 * 处理获取验证码定时器的事件
 **/
- (void)handleTimerForGetVerifyCode {
    self.counter--;
    if (self.counter<1) {
        [self abortTimerForGetVerifyCode];
    }
    else {
        [self.verifyCodeLabel setText:[NSString stringWithFormat:@"%ld%@", (long)self.counter, LOCALIZED_STRING(keyUnitSecond)]];//@"秒"
    }
}

@end
