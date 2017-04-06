//
//  EditDeviceNameViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "EditDeviceNameViewController.h"

static NSString *const CellIdentifier   = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValuebottomLine          = 100102,
    TagValueDeviceNameTextField = 100103,
    TagValueTopLine             = 100104
};

@interface EditDeviceNameViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@end

@implementation EditDeviceNameViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyDeviceName);//@"烟具名称";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [self addBackButtonInNavigationBar];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITableViewCell *deviceNameCell = [self.layoutTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[deviceNameCell viewWithTag:TagValueDeviceNameTextField] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [self removeBackButtonFromNavigationBar];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================

/**
 * BackButton按钮的事件处理方法
 **/
- (void)onBackButton:(UIButton *)sender {
    [self.view endEditing:YES];
    UITableViewCell *deviceNameCell = [self.layoutTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *deviceNameTextField = [deviceNameCell viewWithTag:TagValueDeviceNameTextField];
    NSString *deviceName = deviceNameTextField.text;
    
    if ([UserHelper isBoundDevice]) {
        if (deviceName != nil && ![deviceName isEqualToString:@""]) {
            Device *currentDevice = [UserHelper currentDevice];
            currentDevice.deviceName = deviceName;
            [DeviceDataAccessor saveDevice:currentDevice];
            if ([self.delegate respondsToSelector:@selector(didSaveDeviceName:)]) {
                [self.delegate didSaveDeviceName:deviceName];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {;
            [self showErrorMessage:[NSString stringWithFormat:LOCALIZED_STRING(key_CanNotBeBlank), LOCALIZED_STRING(keyDeviceName)]];//@"设备名称不能为空"
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseAddDevice)];
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
    UITextField *deviceNameTextField= [cell.contentView viewWithTag:TagValueDeviceNameTextField];
    UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
    
    if ([UserHelper isBoundDevice]) {
        [deviceNameTextField setText:[UserHelper currentDevice].deviceName];
    }
    else {
        [deviceNameTextField setText:@"--"];
    }
    
    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    
    return cell;
}

@end
