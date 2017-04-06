//
//  ForgetPasswordStepTwoViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//


#import "ForgetPasswordStepTwoViewController.h"
#import "LoginViewController.h"

@interface ForgetPasswordStepTwoViewController ()


@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)onSubmitButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine2HeightConstraint;

@property (strong, nonatomic) NSString  *currentNewPassword;

@end

@implementation ForgetPasswordStepTwoViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keySetPassword);//@"设置密码";
    [self setupBorderLineConstraint];
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
}


//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
- (IBAction)onSubmitButton:(UIButton *)sender {
    
    NSString *newPassword       = self.passwordTextField.text;
    NSString *confirmPassword   = self.confirmPasswordTextField.text;
    
    CValidator *validator = [[CValidator alloc] init];
    
    [validator validateMinLength:6 MaxLength:20 Text:newPassword FieldName:LOCALIZED_STRING(keyNewPassword)];//@"新密码"
    [validator validateMinLength:6 MaxLength:20 Text:confirmPassword FieldName:LOCALIZED_STRING(keyConfirmNewPassword)];//@"确认密码"
    [validator validateEqual:newPassword FirstFieldName:LOCALIZED_STRING(keyNewPassword) SecondText:confirmPassword SecondFieldName:LOCALIZED_STRING(keyConfirmNewPassword)];//@"新密码"  @"确认密码"
    
    if ([validator isValid]) {
        [Utility showIndicatorHUD:@""];
        self.currentNewPassword = newPassword;
        ResetPasswordCommand *resetPasswordCommand = [[ResetPasswordCommand alloc] initResetPasswordCommandWithPhone:self.userPhone Password:newPassword];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:resetPasswordCommand];
    }
    else {
        NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
        [self showErrorMessage:errorMsg];
    }
}


//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    [super didCommandSuccessWithResult:result andOpCode:opCode];
    [Utility hideIndicatorHUD];
    if (opCode == OperationCodeResetPassword) {
        NSError *error;
        CommonResponseMessage *commonResponseMsg = [CommonResponseMessage parseFromData:result error:&error];
        if (error == nil && commonResponseMsg.errorMsg.errorCode == 0) {
            [self showSuccessMessage:LOCALIZED_STRING(keyResetPasswordSuccessfully)];//@"重设密码成功"
            User *user = [UserDataAccessor findUserByUserPhone:self.userPhone];
            if (user != nil) {
                user.password = self.currentNewPassword;
                [UserDataAccessor saveUser:user];
            }
            
            //========================================
            // 跳转到登录页
            //========================================
            BaseViewController *loginVC;
            for (BaseViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LoginViewController class]]) {
                    loginVC = vc;
                    break;
                }
            }
            [self.navigationController popToViewController:loginVC animated:NO];
        }
        else {
            [self showErrorMessage:(commonResponseMsg!=nil?commonResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyResetPasswordFailed))];//@"重设密码失败"
            if (error ==nil && commonResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
            }
        }
    }
  
    
}

- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
}


@end
