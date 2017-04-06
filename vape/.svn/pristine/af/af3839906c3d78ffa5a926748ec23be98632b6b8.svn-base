//
//  LoginViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassowrdStepOneViewController.h"

@interface LoginViewController () {
    BOOL    isShowPassword;
    
}

@property (weak, nonatomic) IBOutlet UITextField    *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField    *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView    *showOrHidePasswordImgView;


- (IBAction)onShowOrHidePasswordButton:(UIButton *)sender;
- (IBAction)onLoginButton:(UIButton *)sender;
- (IBAction)onForgetPasswordButton:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine3HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine4HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardViewHeightConstraint;

@property (strong, nonatomic) User *luser;

@end

@implementation LoginViewController


//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBorderLineConstraint];
    self.luser = [User new];
    if (self.isBackToPreviousFunction) {
        [self setupCancelButtonInLeftBarButtonItem];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    User *user = [UserDataAccessor findUserByUserId:[UserHelper getLoginUserId]];
    if (user != nil) {
        [self.phoneTextField setText:user.phone];
        [self.passwordTextField setText:user.password];
    }
    else {
        [self.phoneTextField setText:@""];
        [self.passwordTextField setText:@""];
    }
    if (self.isBackToPreviousFunction) {
        [self.rdv_tabBarController setTabBarHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isBackToPreviousFunction) {
        [self.rdv_tabBarController setTabBarHidden:NO];
    }
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
    self.bottomLine3HeightConstraint.constant = kBorder_Line_Height;
    self.bottomLine4HeightConstraint.constant = kBorder_Line_Height;
}

/**
 * 在NavigationBar右边添加取消按钮
 **/
- (void)setupCancelButtonInLeftBarButtonItem {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:LOCALIZED_STRING(keyCancel) style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton:)]];
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
#pragma mark - 登录界面的Button事件处理方法
//=====================================================================================
/**
 * 显示/隐藏密码
 **/
- (IBAction)onShowOrHidePasswordButton:(UIButton *)sender {
    isShowPassword = !isShowPassword;
    self.passwordTextField.secureTextEntry   = !isShowPassword;
    self.showOrHidePasswordImgView.image     = [UIImage imageNamed:(!isShowPassword?@"EyeClose":@"EyeOpen")];
}

/**
 * 登录
 **/
- (IBAction)onLoginButton:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *phoneNumber   = self.phoneTextField.text;
    NSString *password      = self.passwordTextField.text;
    
    CValidator *validator = [[CValidator alloc] init];
    [validator validateCellphoneNo:phoneNumber FieldName:LOCALIZED_STRING(keyPhoneNumber)];//@"手机号码"
    [validator validateMinLength:6 MaxLength:20 Text:password FieldName:LOCALIZED_STRING(keyPassword)];//@"密码"
    
    if ([validator isValid]) {
        [Utility showIndicatorHUD:@""];
        self.luser.phone    = phoneNumber;
        self.luser.password = password;
        LoginCommand *loginCommand = [[LoginCommand alloc] initLoginCommandWithPhone:self.luser.phone Password:self.luser.password];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:loginCommand];
    }
    else {
        NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
        [self showErrorMessage:errorMsg];
        
    }
    
}

/**
 * 忘记密码，跳转到重置密码页面
 **/
- (IBAction)onForgetPasswordButton:(UIButton *)sender {
    ForgetPassowrdStepOneViewController *forgetPasswordStepOneVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"ForgetPassowrdStepOneViewController");
    [self.navigationController pushViewController:forgetPasswordStepOneVC animated:YES];
}

/**
 * 取消登录操作
 **/
- (void)onCancelButton:(UIBarButtonItem *)sender {
    if (self.didCancel != nil) {
        self.didCancel();
    }
    if (self.isBackToPreviousFunction) {
        if (self.isSessionExpired) {  //会话过期时，取消登录则直接进入匿名登录模式
            [UserHelper loginByAnonymousUser];
        }
        [self dismissViewControllerAnimated:YES completion:^{
        }];
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
    if (opCode == OperationCodeLogin) {
        LoginResponseMessage *loginResponseMsg = [LoginResponseMessage parseFromData:result error:&error];
        DebugLog(@"responseMsg: %@", loginResponseMsg);
        if (error == nil && loginResponseMsg != nil && loginResponseMsg.errorMsg.errorCode == 0) {
            [UserHelper loginByLoginResponseMsg:loginResponseMsg UserPassword:self.luser.password];
            [self showSuccessMessage:LOCALIZED_STRING(keyLoginSuccessful)];//@"用户登录成功"
            if (self.didLogin != nil) {
                self.didLogin();
            }
            if (self.isBackToPreviousFunction) {
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
            else {
                [[Utility getAppDelegate] setupRootTabBarViewController];
            }
            
        }
        else {
            [self showErrorMessage:(loginResponseMsg!=nil?loginResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLoginFailed))];//@"用户登录失败")
        }
    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
}



@end
