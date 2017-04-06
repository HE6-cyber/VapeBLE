//
//  MeViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import <MJPhotoBrowser/MJPhotoBrowser.h>

#define  kUserIconImageView_Width       (kScreen_Width * 0.45f -44)

static NSString *const CellIdentifier   = @"LayoutCell";
static NSString *const kShopURL         = @"http://www.baidu.com";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100001,
    TagValuebottomLine          = 100002,
    TagValueTopLine             = 100104
};

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray         *titlesInLayoutTableView;
    
}


@property (weak, nonatomic) IBOutlet UIImageView    *userIconImgView;
@property (weak, nonatomic) IBOutlet UILabel        *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton       *loginButton;

@property (weak, nonatomic) IBOutlet UIView         *existedDeviceBackView;
@property (weak, nonatomic) IBOutlet UILabel        *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *connectStatusImgView;
@property (weak, nonatomic) IBOutlet UILabel        *connectStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *reconnectButton;

- (IBAction)onUserIconButton:(UIButton *)sender;
- (IBAction)onLoginButton:(UIButton *)sender;
- (IBAction)onAddDeviceButton:(UIButton *)sender;
- (IBAction)onReconnectButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine1HeightConstraint;

@property (strong, nonatomic) NSTimer   *timerForReconnectDeviceTimeout;


@end

@implementation MeViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self setupBorderLineConstraint];
//    titlesInLayoutTableView = @[@[@"个人信息", @"账号设置"],
//                                @[@"烟具设置"],
//                                @[@"系统设置"],
//                                @[@"进入商城"]];
    titlesInLayoutTableView = @[@[LOCALIZED_STRING(keyPersonalInformation), LOCALIZED_STRING(keyAccountSettings)],
                                @[LOCALIZED_STRING(keyDeviceSettings)],
                                @[LOCALIZED_STRING(keySystemSettings)],
                                @[LOCALIZED_STRING(keyShop)]];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:[UserHelper currentUser].userPhotoUrl]
                            placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
//    [self.userIconImgView setImage:[UIImage imageWithData:[UserHelper currentUser].userPhoto]];
    if ([UserHelper isLogin]) {
        self.nickNameLabel.text = [UserHelper currentUser].userName;
        [self.loginButton setEnabled:NO];
    }
    else {
        self.nickNameLabel.text = LOCALIZED_STRING(keyLogIn);//@"点击登录";
        [self.loginButton setEnabled:YES];
        
    }
    [self showDeviceInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    self.bottomLine1HeightConstraint.constant   = kBorder_Line_Height;
    self.topLine1HeightConstraint.constant      = kBorder_Line_Height;
    
    self.userIconImgView.layer.cornerRadius = kUserIconImageView_Width * 0.5f;
    self.userIconImgView.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.userIconImgView.layer.borderWidth  = 1;
    
}

/**
 * 显示设备信息
 **/
- (void)showDeviceInfo {
    if ([UserHelper isBoundDevice]) {
        [self.existedDeviceBackView setHidden:NO];
        [self.deviceNameLabel setText:[UserHelper currentDevice].deviceName];
        if ([BLECommandHelper shareBLECommandHelper].connectStatus == BLEConnectStatusDeviceInitCompleted ||
            [BLECommandHelper shareBLECommandHelper].connectStatus == BLEConnectStatusConnected) {
            self.connectStatusImgView.image = [UIImage imageNamed:@"connectedStatusIcon"];
            self.connectStatusLabel.text = LOCALIZED_STRING(keyConnected);//@"已连接";
            self.reconnectButton.enabled = NO;
        }
        else {
            self.connectStatusImgView.image = [UIImage imageNamed:@"disconnectedStatusIcon"];
            self.connectStatusLabel.text = LOCALIZED_STRING(keyDisconnected);//@"未连接";
            self.reconnectButton.enabled = YES;
        }
    }
    else {
        [self.existedDeviceBackView setHidden:YES];
    }
}

//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    [super handleBLENotification:notification];
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    
    switch (message.notificationCode) {
        case BLENotificationCodeSucceedToConnectPeripheral:
        case BLENotificationCodeInitPeripheralCompleted: {
            [Utility hideIndicatorHUD];
            [self showDeviceInfo];
        }
            break;
        case BLENotificationCodeDeviceUnSupported: {
            [Utility hideIndicatorHUD];
        }
            break;
        case BLENotificationCodeDisconnectPeripheral: {
            [Utility hideIndicatorHUD];
            [self showDeviceInfo];
        }
            break;
        case BLENotificationCodeFailToConnect: {
            
        }
            break;
    }
    
}


//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
/**
 * 以大图的方式显示用户图像
 **/
- (IBAction)onUserIconButton:(UIButton *)sender {
    MJPhoto *photo = [[MJPhoto alloc] init];
    if ([UserHelper currentUser].userPhotoUrl != nil && ![[UserHelper currentUser].userPhotoUrl isEqualToString:@""]) {
        photo.url = [NSURL URLWithString:[UserHelper currentUser].userPhotoUrl];
    }
    else {
        photo.image = [UIImage imageNamed:@"defaultUserIcon"];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = @[photo];
    browser.showSaveBtn = false;
    [browser show];
}

/**
 * 登录
 **/
- (IBAction)onLoginButton:(UIButton *)sender {
    [UserHelper presentLoginViewControllerByIsSessionExpired:NO];
}

/**
 * 添加设备
 **/
- (IBAction)onAddDeviceButton:(UIButton *)sender {
    BaseViewController *addDeviceVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"AddDeviceViewController");
    [self.navigationController pushViewController:addDeviceVC animated:YES];
    
}

/**
 * 重连设备
 **/
- (IBAction)onReconnectButton:(UIButton *)sender {
    if (([[BLECommandHelper shareBLECommandHelper] connectStatus] != BLEConnectStatusConnected ||
        [[BLECommandHelper shareBLECommandHelper] connectStatus] != BLEConnectStatusDeviceInitCompleted) &&
        [UserHelper isBoundDevice]) {
        [Utility showIndicatorHUD:@""];
        [[BLECommandHelper shareBLECommandHelper] connectToPeripheralWithUUIDString:[UserHelper currentDeviceUUID]];
    }
    
}



//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesInLayoutTableView.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titlesInLayoutTableView[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *titleLabel = [cell.contentView viewWithTag:TagValueTitleLabel];
    UILabel *topLine    = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine = [cell.contentView viewWithTag:TagValuebottomLine];
    
    NSString *title = [titlesInLayoutTableView[indexPath.section] objectAtIndex:indexPath.row];
    [titleLabel setText:title];
    
    if (indexPath.row == 0) {
        [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
    }
    else {
        [topLine setHidden:YES];
    }
    
    if (indexPath.row == ([titlesInLayoutTableView[indexPath.section] count] - 1)) {
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            if ([UserHelper isLogin]) {
                switch (indexPath.row) {
                    case 0: {
                        BaseViewController *personalInfoVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"PersonalInfoViewController");
                        [self.navigationController pushViewController:personalInfoVC animated:YES];
                    }
                        break;
                    case 1: {
                        BaseViewController *accountSettingVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"AccountSettingViewController");
                        [self.navigationController pushViewController:accountSettingVC animated:YES];
                    }
                        break;
                }
            }
            else {
                [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
            }
            
        }
            break;
        case 1: {
            if ([UserHelper isBoundDevice]) {
                BaseViewController *deviceSettingVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"DeviceSettingViewController");
                [self.navigationController pushViewController:deviceSettingVC animated:YES];
            }
            else {
                [self showErrorMessage:LOCALIZED_STRING(keyPleaseAddDevice)];
            }
        }
            break;
        case 2: {
            BaseViewController *appSettingVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"AppSettingViewController");
            [self.navigationController pushViewController:appSettingVC animated:YES];
        }
            break;
        case 3: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(keyMallSiteIsUnderConstructionPleaseLookForwardToIt) message:@"" delegate:nil cancelButtonTitle:LOCALIZED_STRING(keyConfirm) otherButtonTitles:nil];
            [alertView show];
            return;
            /*
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:LOCALIZED_STRING(keyDoYouWantToEnterTheMall) message:@""];//@"确定进入商城?"
            [alertView bk_setCancelButtonWithTitle:LOCALIZED_STRING(keyCancel) handler:nil];
            [alertView bk_addButtonWithTitle:LOCALIZED_STRING(keyConfirm) handler:nil];
            [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kShopURL]];
                }
            }];
            [alertView show];
             */
            
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 16;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == titlesInLayoutTableView.count -1) {
        return 16;
    }
    return 1;
}










@end
