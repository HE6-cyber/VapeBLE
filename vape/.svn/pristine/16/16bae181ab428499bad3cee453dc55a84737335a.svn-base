//
//  EditSmokingPlanViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "EditSmokingPlanViewController.h"

static NSString *const CellIdentifier   = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104
};

@interface EditSmokingPlanViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray             *titlesInLayoutTableView;   //个人信息标题数组
    
    NSMutableArray      *planCountStrings;
    NSMutableArray      *planTimeStrings;
    
}

//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (assign, nonatomic) UpdateProfileRequestMessage_SettingField  currentEditedSettingFieldType;
@property (assign, nonatomic) NSInteger                                 currentEditedSettingValue;


@end

@implementation EditSmokingPlanViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keySmokingPlan);//@"吸烟计划"
//    titlesInLayoutTableView = @[@"今日计划吸烟口数", @"今日计划吸烟时长"];
    titlesInLayoutTableView = @[LOCALIZED_STRING(keySmokingPuffsPlanForToday), LOCALIZED_STRING(keySmokingTimePlanForToday)];
    [self setupStringPickerData];
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
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 配置选取器用到的数据
 **/
- (void)setupStringPickerData {
    
    planCountStrings = [NSMutableArray new]; //口数
    for (NSInteger i=kPlanCount_Minimum_Value; i<=kPlanCount_Maximum_Value; i=i+kPlanCount_Step_Value) {
        [planCountStrings addObject:[NSString stringWithFormat:@"%ld%@", (long)i, LOCALIZED_STRING(keySmokingPuffsUnit)]];//@"口"
    }
    
    planTimeStrings = [NSMutableArray new]; //分钟
    for (NSInteger i=kPlanTime_Minimum_Value; i<=kPlanTime_Maximum_Value; i=i+kPlanTime_Step_Value) {
        [planTimeStrings addObject:[NSString stringWithFormat:@"%ld%@", (long)i, LOCALIZED_STRING(keySmokingTimeUnit)]];//@"分钟"
    }
    
}

//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesInLayoutTableView.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 32;
    }
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == titlesInLayoutTableView.count -1) {
        return 32;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *titleLabel             = [cell.contentView viewWithTag:TagValueTitleLabel];
    UILabel *valueLabel             = [cell.contentView viewWithTag:TagValueValueLabel];
    UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
    
    [titleLabel setText:[titlesInLayoutTableView objectAtIndex:indexPath.section]];
    
    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomLine.superview.mas_leading);
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    if (indexPath.section == 0) {
        [valueLabel setText:[NSString stringWithFormat:@"%ld%@", (long)[UserHelper currentUser].planCount, LOCALIZED_STRING(keySmokingPuffsUnit)]];//@"口"
    }
    else {
        [valueLabel setText:[NSString stringWithFormat:@"%ld%@", (long)[UserHelper currentUser].planTime, LOCALIZED_STRING(keySmokingTimeUnit)]];//@"分钟"
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        case 0: {
            ActionSheetStringPicker *picker =
            [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                      rows:planCountStrings
                                          initialSelection:([UserHelper currentUser].planCount/kPlanCount_Step_Value)-1
                                                 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                     NSInteger planCountValue = (selectedIndex+1)*kPlanCount_Step_Value;
                                                     [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_PlanCount SettingValue:planCountValue];
                                                 }
                                               cancelBlock:^(ActionSheetStringPicker *picker) {
                                                   
                                               }
                                                    origin:self.view];
            picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
            [picker showActionSheetPicker];
        }
            break;
        case 1: {
            ActionSheetStringPicker *picker =
            [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                      rows:planTimeStrings
                                          initialSelection:([UserHelper currentUser].planTime/kPlanTime_Step_Value)-1
                                                 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                     NSInteger planTimeValue = (selectedIndex+1)*kPlanTime_Step_Value;
                                                     [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_PlanTime SettingValue:planTimeValue];
                                                 }
                                               cancelBlock:^(ActionSheetStringPicker *picker) {
                                                   
                                               }
                                                    origin:self.view];
            picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
            [picker showActionSheetPicker];
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
            if (error == nil && updateProfileResponseMsg.errorMsg.errorCode == 0) {
                switch (self.currentEditedSettingFieldType) {
                    case UpdateProfileRequestMessage_SettingField_PlanCount: {
                        [UserHelper currentUser].planCount = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_PlanTime: {
                        [UserHelper currentUser].planTime = self.currentEditedSettingValue;
                    }
                        break;
                    default:
                        break;
                }
                [UserHelper synchronizeCurrentUser];
                [self.layoutTableView reloadData];
                [self showSuccessMessage:LOCALIZED_STRING(keySmokingPlanSetUpSuccessful)];//@"更新吸烟计划成功"
            }
            else {
                [self showErrorMessage:(updateProfileResponseMsg!=nil?updateProfileResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keySmokingPlanSetUpFailed))];//@"更新吸烟计划失败"
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
