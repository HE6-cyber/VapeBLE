//
//  AddDeviceViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "AddDeviceViewController.h"
#import <MRProgress/MRProgress.h>

static NSString *const CellIdentifier = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel                  = 100101,
    TagValuebottomLine                  = 100102,
    TagValueTopLine                     = 100103,
    TagValueScanDeviceTimeoutAlertView  = 888888,
    TagValueAddDeviceAlertView          = 999999
};


@interface AddDeviceViewController () <UIAlertViewDelegate> {
  
    
}

@property (weak, nonatomic) IBOutlet UITableView    *layoutTableView;

@property (weak, nonatomic) IBOutlet UIView                     *searchDeviceBackView;
@property (weak, nonatomic) IBOutlet MRActivityIndicatorView    *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray    *discoveredPeripherals; //存储扫描到的蓝牙设备
@property (strong, nonatomic) CBPeripheral      *selectedPeripheral;

@end

@implementation AddDeviceViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyAddDevice);//@"添加烟具";
    self.discoveredPeripherals = [NSMutableArray new];
    [self setupActivityIndicatorView:self.activityIndicatorView];
    [self addConnectedDiscoveredPeripherals];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];

//    [self.bleHelper connectToPeripheralWithUUIDString:@"CE47C9F4-6914-4350-9F27-90F77C503F0E"];
    if (self.discoveredPeripherals.count ==0) {
        [self.activityIndicatorView startAnimating];
        [self.searchDeviceBackView setHidden:NO];
    }
    else {
        [self.activityIndicatorView stopAnimating];
        [self.searchDeviceBackView setHidden:YES];
    }
    [[BLECommandHelper shareBLECommandHelper] scan];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.activityIndicatorView stopAnimating];
     [[BLECommandHelper shareBLECommandHelper] stopScan];
}

//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 配置指示器
 **/
- (void)setupActivityIndicatorView:(MRActivityIndicatorView *)indicatorView {
    indicatorView.lineWidth = 1;
    indicatorView.tintColor = kNavigationBar_Bg_Color;
}

/**
 * 添加扫描到的蓝牙设备
 **/
- (BOOL)addDiscoverPeripheral:(DiscoveredPeripheral *)newDiscoveredPeripheral {
    BOOL isExists = NO;
    NSString *newPeripheralUUIDString = newDiscoveredPeripheral.peripheral.identifier.UUIDString;
    for (DiscoveredPeripheral *item in self.discoveredPeripherals) {
        if ([item.peripheral.identifier.UUIDString isEqualToString:newPeripheralUUIDString]) {
            isExists = YES;
            break;
        }
    }
    if (!isExists) {
        Device *device = [DeviceDataAccessor findDeviceByDeiveId:newPeripheralUUIDString];
        if (device != nil && device.deviceName != nil && ![device.deviceName isEqualToString:@""]) {
            newDiscoveredPeripheral.peripheralName = device.deviceName;
        }
        if (newDiscoveredPeripheral.peripheralName == nil || [newDiscoveredPeripheral.peripheralName isEqualToString:@""]) {
            newDiscoveredPeripheral.peripheralName = @"unknown device";
        }
        [self.discoveredPeripherals insertObject:newDiscoveredPeripheral atIndex:0];
    }
    return !isExists;
}

/**
 * 添加扫描到的已连接的蓝牙设备
 **/
- (void)addConnectedDiscoveredPeripherals {
    NSArray *connectedPeripherals = [self.bleHelper retrieveConnectedPeripherals];
    for (CBPeripheral *item in connectedPeripherals) {
        [self addDiscoverPeripheral:[[DiscoveredPeripheral alloc] initWithPeripheral:item AdvertisementData:nil RSSI:nil PeripheralName:nil IsConnected:YES]];
    }
}



//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    [super handleBLENotification:notification];
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    
    switch (message.notificationCode) {
        case BLENotificationCodeDiscoverPeripheral: {
            [self.activityIndicatorView stopAnimating];
            [self.searchDeviceBackView setHidden:YES];
            
            DiscoveredPeripheral *newDiscoveredPeripheral = message.discoveredPeripheral;
            if ([self addDiscoverPeripheral:newDiscoveredPeripheral]) {
                [self.layoutTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
            break;
        case BLENotificationCodeSucceedToConnectPeripheral: {
            
        }
            break;
        case BLENotificationCodeInitPeripheralCompleted: {
            [Utility hideIndicatorHUD];
            CBPeripheral *peripheral = message.peripheral;
            [UserHelper currentUser].deviceId = peripheral.identifier.UUIDString;
            [UserHelper synchronizeCurrentUser];
            Device *device = [DeviceDataAccessor findDeviceByDeiveId:peripheral.identifier.UUIDString];
            if (device == nil) {
                device = [[Device defaultValue] copy];
                device.deviceId     = peripheral.identifier.UUIDString;
                device.deviceName   = peripheral.name;
                device.createDt     = [NSDate date];
                device.lastUpdateDt = [NSDate date];
                [DeviceDataAccessor saveDevice:device];
            }
            
             [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case BLENotificationCodeReceiveNotifyForCharacteristic: {
            
        }
            break;
        case BLENotificationCodeNotAddDevice: {
            
        }
            break;
        case BLENotificationCodeDiscoverDeviceTimeOut: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(keyNotFoundTheDevicePleaseEnsureTheDeviceScreenBrightAndCloseItToThePhone) message:@"" delegate:self cancelButtonTitle:LOCALIZED_STRING(keyRetry) otherButtonTitles:LOCALIZED_STRING(keyNotAdd), nil];
            alertView.tag = TagValueScanDeviceTimeoutAlertView;
            [alertView show];
        }
            break;
        case BLENotificationCodeConnectDeviceTimeOut: {
            [Utility hideIndicatorHUD];
            [self showErrorMessage:LOCALIZED_STRING(keyConnectionTimeout)];
        }
            break;
        case BLENotificationCodeInitDeviceTimeOut: {
            [Utility hideIndicatorHUD];
            [self showErrorMessage:LOCALIZED_STRING(keyInitializationFailed)];
        }
            break;
        case BLENotificationCodeFailToPerformOperation: {
            
        }
            break;
        case BLENotificationCodeDisconnectPeripheral: {
            
        }
            break;
        case BLENotificationCodeFailToConnect: {
            
        }
            break;
    }
    
}


//=====================================================================================
#pragma mark - UIAlertViewDelegate
//=====================================================================================
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TagValueScanDeviceTimeoutAlertView) { //扫描设备超时
        if (buttonIndex == 0) {
            [[BLECommandHelper shareBLECommandHelper] scan];
        }
        else {
            [[BLECommandHelper shareBLECommandHelper] stopScan];
            [self.activityIndicatorView stopAnimating];
        }
    }
    else if (alertView.tag == TagValueAddDeviceAlertView) { //添加设备
        if (buttonIndex == 0) {
            [Utility showIndicatorHUD:@""];
            [self.bleHelper connectPeripheral:self.selectedPeripheral];
            [self.bleHelper stopScan];
        }
        else {
            
        }
    }
    
}



//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.discoveredPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *titleLabel = [cell.contentView viewWithTag:TagValueTitleLabel];
    UILabel *bottomLine = [cell.contentView viewWithTag:TagValuebottomLine];
    UILabel *topLine    = [cell.contentView viewWithTag:TagValueTopLine];
    
    DiscoveredPeripheral *discoveredPeripheral = [self.discoveredPeripherals objectAtIndex:indexPath.row];
    [titleLabel setText:discoveredPeripheral.peripheralName];
    DebugLog(@"indexPath:%@ -- %@", indexPath, discoveredPeripheral.peripheral);
    
    if (indexPath.row == 0) {
        [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(kBorder_Line_Height));
        }];
    }
    else {
        [topLine setHidden:YES];
    }
    
    if (indexPath.row == (self.discoveredPeripherals.count - 1)) {
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
    DiscoveredPeripheral *discoveredPeripheral = [self.discoveredPeripherals objectAtIndex:indexPath.row];
    self.selectedPeripheral = discoveredPeripheral.peripheral;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@",  LOCALIZED_STRING(keyAddDevice), discoveredPeripheral.peripheral.name] message:@"" delegate:self cancelButtonTitle:LOCALIZED_STRING(keyAdd) otherButtonTitles:LOCALIZED_STRING(keyNotAdd), nil];
    alertView.tag = TagValueAddDeviceAlertView;
    [alertView show];
}




@end
