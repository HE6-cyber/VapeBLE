//
//  HomeDisplayTypeViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//


#import "HomeDisplayTypeViewController.h"

static NSString *const CellIdentifier           = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104,
    TagValueUserIconImgView     = 100105
};


@interface HomeDisplayTypeViewController ()
<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    NSArray             *titlesInLayoutTableView;   //个人信息标题数组
    NSArray             *homeInfoStrings;           //首页显示类型的字符串数组
}


//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (assign, nonatomic) UpdateProfileRequestMessage_SettingField  currentEditedSettingFieldType;
@property (assign, nonatomic) NSInteger                                 currentEditedSettingValue;

@end

@implementation HomeDisplayTypeViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyPlanSettings);//@"首页显示";
    
    //    titlesInLayoutTableView = @[@"首页显示", @"吸烟计划"];
    titlesInLayoutTableView = @[LOCALIZED_STRING(keyTheHomepage), LOCALIZED_STRING(keySmokingPlan)];
    homeInfoStrings = @[LOCALIZED_STRING(keySmokingPuffs), LOCALIZED_STRING(keySmokingTime)];  //首页显示类型
    
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
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesInLayoutTableView.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *titleLabel             = [cell.contentView viewWithTag:TagValueTitleLabel];
    UILabel *valueLabel             = [cell.contentView viewWithTag:TagValueValueLabel];
    UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
    
    [titleLabel setText:[titlesInLayoutTableView objectAtIndex:indexPath.row]];
    
    if (indexPath.row == 0) {
        [topLine setHidden:NO];
        [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
    }
    else {
        [topLine setHidden:YES];
    }
    if (indexPath.row == (titlesInLayoutTableView.count - 1)) {
        [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(bottomLine.superview.mas_leading);
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
    }
    else {
        [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(bottomLine.superview.mas_leading).offset(16);
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
    }
    
    User *currentUser = [UserHelper currentUser];
    if (indexPath.row == 0) {
        [valueLabel setHidden:NO];
        [valueLabel setText:[homeInfoStrings objectAtIndex:currentUser.homeInfo]]; /**首页显示*/
    }
    else {
        [valueLabel setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User *currentUser = [UserHelper currentUser];
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.row) {
        case 0: { /**首页显示*/
            ActionSheetStringPicker *picker =
            [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                      rows:homeInfoStrings
                                          initialSelection: currentUser.homeInfo
                                                 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                     
                                                     [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_HomeInfo
                                                                                             SettingValue:selectedIndex];
                                                 }
                                               cancelBlock:^(ActionSheetStringPicker *picker) {
                                                   
                                               }
                                                    origin:self.view];
            picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
            [picker showActionSheetPicker];
        }
            break;
        case 1: {
            if ([UserHelper isLogin]) {
                BaseViewController *editSmokingPlanVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"EditSmokingPlanViewController");
                [self.navigationController pushViewController:editSmokingPlanVC animated:YES];
            }
            else {
                [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
            }
        }
            break;
    }
    
}


//=====================================================================================
#pragma mark - 发送更新用户信息Socket命令
//=====================================================================================
- (void)sendUpdateProfileCommandBySettingFieldType:(UpdateProfileRequestMessage_SettingField)settingFieldType SettingValue:(NSInteger)settingValue {
    self.currentEditedSettingFieldType  = settingFieldType;
    self.currentEditedSettingValue      = settingValue;
    if ([UserHelper isLogin]) {
        [Utility showIndicatorHUD:@""];
        UpdateProfileCommand *updateProfileCommand = [[UpdateProfileCommand alloc] initUpdateProfileCommandWithSession:[UserHelper currentUserSession]
                                                                                                          SettingField:settingFieldType
                                                                                                          SettingValue:[NSString stringWithFormat:@"%ld", (long)settingValue]];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:updateProfileCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
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
    if ([UserHelper isLogin]) {
        if (opCode == OperationCodeUpdateProfile) {
            NSError *error;
            UpdateProfileResponseMessage *updateProfileResponseMsg = [UpdateProfileResponseMessage parseFromData:result error:&error];
            if (error == nil && updateProfileResponseMsg.errorMsg.errorCode == 0 &&
                self.currentEditedSettingFieldType == UpdateProfileRequestMessage_SettingField_HomeInfo) {
                [UserHelper currentUser].homeInfo = self.currentEditedSettingValue;
                [UserHelper synchronizeCurrentUser];
                [self.layoutTableView reloadData];
                [self showSuccessMessage:LOCALIZED_STRING(keyPersonalInformationUpdated)];//@"更新用户信息成功"
            }
            else {
                [self showErrorMessage:(updateProfileResponseMsg==nil?LOCALIZED_STRING(keyPersonalInformationUpdateFailed):updateProfileResponseMsg.errorMsg.errorMsg)];//@"更新用户信息失败"
                if (error ==nil && updateProfileResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
    
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
}



@end
