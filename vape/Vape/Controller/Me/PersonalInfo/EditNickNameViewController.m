//
//  EditNickNameViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "EditNickNameViewController.h"

static NSString *const CellIdentifier   = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValuebottomLine          = 100102,
    TagValueNickNameTextField   = 100103,
    TagValueTopLine             = 100104
};

@interface EditNickNameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (strong, nonatomic) NSString     *currentEditedNickName;

@end

@implementation EditNickNameViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyNickname);//@"昵称";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [self addBackButtonInNavigationBar];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITableViewCell *nickNameCell = [self.layoutTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[nickNameCell viewWithTag:TagValueNickNameTextField] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [self removeBackButtonFromNavigationBar];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================

/**
 * BackButton按钮的事件处理方法
 **/
- (void)onBackButton:(UIButton *)sender {
    [self.view endEditing:YES];
    UITableViewCell *nickNameCell = [self.layoutTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *nickNameTextField = [nickNameCell viewWithTag:TagValueNickNameTextField];
    NSString *nickName = nickNameTextField.text;
    
    if ([UserHelper isLogin]) {
        if (nickName != nil && ![nickName isEqualToString:@""]) {
            [Utility showIndicatorHUD:@""];
            self.currentEditedNickName = nickName;
            UpdateProfileCommand *updateProfileCommand = [[UpdateProfileCommand alloc] initUpdateProfileCommandWithSession:[UserHelper currentUserSession] SettingField:UpdateProfileRequestMessage_SettingField_UserName SettingValue:nickName];
            [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:updateProfileCommand];
        }
        else {
            [self showErrorMessage:[NSString stringWithFormat:LOCALIZED_STRING(key_CanNotBeBlank), LOCALIZED_STRING(keyNickname)]];//@"昵称不能为空"
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UITextField *nickNameTextField  = [cell.contentView viewWithTag:TagValueNickNameTextField];
    UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
    
    [nickNameTextField setText:[UserHelper currentUser].userName];
    
    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
   
    return cell;
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
    
    if ([UserHelper isLogin]) {
        if (opCode == OperationCodeUpdateProfile) {
            NSError *error;
            UpdateProfileResponseMessage *updateProfileResponseMsg = [UpdateProfileResponseMessage parseFromData:result error:&error];
            if (error == nil && updateProfileResponseMsg.errorMsg.errorCode == 0) {
                [self showSuccessMessage:LOCALIZED_STRING(keyPersonalInformationUpdated)];//@"更新用户信息成功"
                [UserHelper currentUser].userName = self.currentEditedNickName;
                [UserHelper synchronizeCurrentUser];
                if ([self.delegate respondsToSelector:@selector(didSaveNickName:)]) {
                    [self.delegate didSaveNickName:self.currentEditedNickName];
                }
            }
            else {
                [self showErrorMessage:(updateProfileResponseMsg!=nil?updateProfileResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyPersonalInformationUpdateFailed))];//@"更新用户信息失败"
                if (error ==nil && updateProfileResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
