//
//  ChangePasswordViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)onSubmitButton:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine3HeightConstraint;

@property (strong, nonatomic) NSString  *currentNewPassword;

@end

@implementation ChangePasswordViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyPasswordEdit);//@"修改密码";
    [self setupBorderLineConstraint];
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

//=====================================================================================
#pragma mark - 工具方法
//=====================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    self.bottomLine1HeightConstraint.constant = kBorder_Line_Height;
    self.bottomLine2HeightConstraint.constant = kBorder_Line_Height;
    self.bottomLine3HeightConstraint.constant = kBorder_Line_Height;
}

//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
- (IBAction)onSubmitButton:(UIButton *)sender {
  
    if ([UserHelper isLogin]) {
        NSString *password          = self.oldPasswordTextField.text;
        NSString *newPassword       = self.passwordTextField.text;
        NSString *confirmPassword   = self.confirmPasswordTextField.text;
        
        CValidator *validator = [[CValidator alloc] init];
        
        [validator validateMinLength:6 MaxLength:20 Text:password FieldName:LOCALIZED_STRING(keyPassword)];//@"原密码"
        [validator validateMinLength:6 MaxLength:20 Text:newPassword FieldName:LOCALIZED_STRING(keyNewPassword)];//@"新密码"
        [validator validateMinLength:6 MaxLength:20 Text:confirmPassword FieldName:LOCALIZED_STRING(keyConfirmNewPassword)];//@"确认密码"
        [validator validateEqual:newPassword FirstFieldName:LOCALIZED_STRING(keyNewPassword) SecondText:confirmPassword SecondFieldName:LOCALIZED_STRING(keyConfirmNewPassword)];//@"新密码" @"确认密码"
        
        if ([validator isValid]) {
            [Utility showIndicatorHUD:@""];
            self.currentNewPassword = newPassword;
            UpdatePasswordCommand *updatePasswordCommand = [[UpdatePasswordCommand alloc] initUpdatePasswordCommandWithSession:[UserHelper currentUserSession] Password:password NewPassword:newPassword];
            [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:updatePasswordCommand];
        }
        else {
            NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
            [self showErrorMessage:errorMsg];
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
    
    
}

//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    [super didCommandSuccessWithResult:result andOpCode:opCode];
    [Utility hideIndicatorHUD];
    if ([UserHelper isLogin]) {
        if (opCode == OperationCodeUpdatePassword) {
            NSError *error;
            CommonResponseMessage *commonResponseMsg = [CommonResponseMessage parseFromData:result error:&error];
            if (error == nil && commonResponseMsg.errorMsg.errorCode == 0) {
                [self showSuccessMessage:LOCALIZED_STRING(keyPasswordChanged)];//@"密码修改成功"
                [UserHelper currentUser].password = self.currentNewPassword;
                [UserHelper synchronizeCurrentUser];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self showErrorMessage:(commonResponseMsg!=nil?commonResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyPasswordChangeFailed))];//@"密码修改失败"
                if (error ==nil && commonResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
    

}

- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
}


@end
