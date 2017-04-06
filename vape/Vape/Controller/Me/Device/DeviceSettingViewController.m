//
//  DeviceSettingViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DeviceSettingViewController.h"
#import "EditDeviceNameViewController.h"

static NSString *const CellIdentifier       = @"LayoutCell";
static NSString *const ButtonCellIdentifier = @"LayoutButtonCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104
};

@interface DeviceSettingViewController () <UITableViewDataSource, UITableViewDelegate, EditDeviceNameViewControllerDelegate> {
    NSArray             *titlesInLayoutTableView;   //个人信息标题数组
    
}

//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@end

@implementation DeviceSettingViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyDeviceSettings);//@"烟具设置";
//    titlesInLayoutTableView = @[@"烟具名称", @"模式及参数", @"解除绑定"];
    titlesInLayoutTableView = @[LOCALIZED_STRING(keyDeviceName), LOCALIZED_STRING(keyModeAndParameter), LOCALIZED_STRING(keyUnbind)];
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
    
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *titleLabel             = [cell.contentView viewWithTag:TagValueTitleLabel];
        UILabel *valueLabel             = [cell.contentView viewWithTag:TagValueValueLabel];
        UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
        UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
        
        [titleLabel setText:[titlesInLayoutTableView objectAtIndex:indexPath.section]];
        if (indexPath.section == 0) {
            [valueLabel setText:([UserHelper isBoundDevice] ? [UserHelper currentDevice].deviceName : @"--")];
        }
        else {
            [valueLabel setText:@""];
        }
        
        [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
        [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(bottomLine.superview.mas_leading);
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([UserHelper isBoundDevice]) {
        switch (indexPath.section) {
            case 0: {
                EditDeviceNameViewController *editDeviceNameVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"EditDeviceNameViewController");
                editDeviceNameVC.delegate = self;
                [self.navigationController pushViewController:editDeviceNameVC animated:YES];
            }
                break;
            case 1: { //设置设备运行参数
                    BaseViewController *editWorkingParamterVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"EditWorkingParameterViewController");
                    [self.navigationController pushViewController:editWorkingParamterVC animated:YES];
            }
                break;
            case 2: { //解除绑定设备
                [DeviceDataAccessor deleteDeviceByDeviceId:[UserHelper currentDeviceUUID]];//从本地数据库删除解绑设备
                [UserHelper currentUser].deviceId   = nil;
                [UserHelper synchronizeCurrentUser];
                [[BLECommandHelper shareBLECommandHelper] cancelCurrentPeripheral];
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
        }

    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseAddDevice)];
    }
    
}

//=====================================================================================
#pragma mark - EditDeviceNameViewControllerDelegate
//=====================================================================================
-(void)didSaveDeviceName:(NSString *)deviceName {
    UITableViewCell *deviceNameCell = [self.layoutTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *deviceNameLabel = [deviceNameCell.contentView viewWithTag:TagValueValueLabel];
    [deviceNameLabel setText:deviceName];
}



@end
