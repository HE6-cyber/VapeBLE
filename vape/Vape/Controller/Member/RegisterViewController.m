//
//  RegisterViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () {
    BOOL isShowPassword;
}


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *showOrHidePasswordImgView;

@property (weak, nonatomic) IBOutlet UILabel    *verifyCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton   *getVerifyCodeButton;

- (IBAction)onShowOrHidePasswordButton:(UIButton *)sender;
- (IBAction)onGetVerifyCodeButton:(UIButton *)sender;
- (IBAction)onRegisterButton:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine5HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLine1WidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardViewHeightConstraint;

@property (strong, nonatomic) User *ruser;

@property (strong, nonatomic) NSTimer   *timerForGetVerifyCode;
@property (assign, nonatomic) NSInteger counter;

@end

@implementation RegisterViewController


//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBorderLineConstraint];
    self.ruser = [User new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self abortTimerForGetVerifyCode];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
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
    self.bottomLine1HeightConstraint.constant = kBorder_Line_Height;
    self.bottomLine2HeightConstraint.constant = kBorder_Line_Height;
    self.bottomLine5HeightConstraint.constant = kBorder_Line_Height;
    self.leftLine1WidthConstraint.constant    = kBorder_Line_Width;
}


/**
 * 显示/隐藏密码
 **/
- (void)hideOrShowPassword {
    
    
}


//=====================================================================================
#pragma mark - 键盘通知处理
//=====================================================================================
- (void)KeyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat loginContentHeight = (kScreen_Height - 64)*0.45 + 150+24+45;
    CGFloat spaceAreaHeight = kScreen_Height - loginContentHeight - 64;
    CGFloat keyboradViewHeight = (spaceAreaHeight>=keyboardFrame.size.height ?
                                  0 :
                                  (kScreen_Height-keyboardFrame.origin.y-spaceAreaHeight));
    keyboradViewHeight = (keyboradViewHeight>0 ? keyboradViewHeight : 0);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.keyboardViewHeightConstraint.constant = keyboradViewHeight;
        DebugLog(@"y=%f, height=%f", keyboardFrame.origin.y, keyboardFrame.size.height);
    }];
}


//=====================================================================================
#pragma mark - 注册界面的Button事件处理方法
//=====================================================================================
/**
 * 显示/隐藏密码
 **/
- (IBAction)onShowOrHidePasswordButton:(UIButton *)sender {
    isShowPassword = !isShowPassword;
    self.passwordTextField.secureTextEntry    = !isShowPassword;
    self.showOrHidePasswordImgView.image      = [UIImage imageNamed:(isShowPassword?@"EyeOpen":@"EyeClose")];
}

/**
 * 获取手机验证码
 **/
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

/**
 * 注册
 **/
- (IBAction)onRegisterButton:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *phoneNumber   = self.phoneTextField.text;
    NSString *password      = self.passwordTextField.text;
    NSString *verifyCode    = self.verifyCodeTextField.text;
    
    CValidator *validator = [[CValidator alloc] init];
    [validator validateCellphoneNo:phoneNumber FieldName:LOCALIZED_STRING(keyPhoneNumber)];//@"手机号码"
    [validator validateMinLength:6 MaxLength:20 Text:password FieldName:LOCALIZED_STRING(keyPassword)];//@"密码"
    [validator validateRequired:verifyCode FieldName:LOCALIZED_STRING(keySMSCode)];//@"验证码"
    
    if ([validator isValid]) {
        __weak typeof(self) weakSelf = self;
        [Utility showIndicatorHUD:@""];
        [SMSSDK commitVerificationCode:verifyCode
                           phoneNumber:phoneNumber
                                  zone:@"86"
                                result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                                    if (!error) {
                                        DebugLog(@"验证成功！");
                                        weakSelf.ruser.phone    = phoneNumber;
                                        weakSelf.ruser.password = password;
                                        RegisterCommand *registerCommand = [[RegisterCommand alloc] initRegisterCommandWithPhone:weakSelf.ruser.phone Password:weakSelf.ruser.password];
                                        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:weakSelf] sendCommand:registerCommand];
                                    }
                                    else {
                                        [Utility hideIndicatorHUD];
                                        DebugLog(@"错误信息：%@", error);
                                        [weakSelf showErrorMessage:LOCALIZED_STRING(keyPleaseEnterTheCorrectVerificationCode)];//@"请输入正确的验证码"
                                    }
        }];
        
    }
    else {
        NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
        [self showErrorMessage:errorMsg];
    }
    
}

//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
/**
 * Socket调用正常返回
 **/
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    [super didCommandSuccessWithResult:result andOpCode:opCode];
    [Utility hideIndicatorHUD];
    NSError *error;
    if (opCode == OperationCodeRegister) {
        RegisterResponseMessage *registerResponseMsg = [RegisterResponseMessage parseFromData:result error:&error];
        DebugLog(@"responseMsg: %@", registerResponseMsg);
        if (error == nil && registerResponseMsg.errorMsg.errorCode == 0) {
            [UserHelper loginByRegisterResponseMsg:registerResponseMsg UserPhone:self.ruser.phone UserPassword:self.ruser.password];
            [self showSuccessMessage:LOCALIZED_STRING(keyRegistrationSuccessful)];//@"用户注册成功"
            [[Utility getAppDelegate] setupRootTabBarViewController];
        }
        else {
            [self showErrorMessage:(registerResponseMsg!=nil?registerResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyRegistrationFailed))];//@"用户注册失败"
        }
    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
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
    [self.verifyCodeLabel setText:[NSString stringWithFormat:@"%ld%@", (long)self.counter, LOCALIZED_STRING(keyUnitSecond)]];//@"秒";
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
