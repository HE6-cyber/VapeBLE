//
//  EditWorkingParameterViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "EditWorkingParameterViewController.h"

static NSString *const CellIdentifier   = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104
};


typedef NS_ENUM(NSInteger, EditedDeviceParameterType) {
    EditedDeviceParameterTypeWorkMode,
    EditedDeviceParameterTypePowerValue,
    EditedDeviceParameterTypeCentigrade,
    EditedDeviceParameterTypeFahrenheit
};



@interface EditWorkingParameterViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray             *titlesInLayoutTableView;   //个人信息标题数组
    
    NSArray             *workModeStrings;
    NSMutableArray      *wattStrings;
    NSMutableArray      *centigradeStrings;
    NSMutableArray      *fahrenheitStrings;
    
}

//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (assign, nonatomic) EditedDeviceParameterType       currentEditedParameterType;  //当前修改的信息类型
@property (assign, nonatomic) NSInteger                       currentEditedValue;        //当前修改值

@end

@implementation EditWorkingParameterViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyModeAndParameter);//@"模式及参数";
//    titlesInLayoutTableView = @[@"工作模式", @"参数"];
    titlesInLayoutTableView = @[LOCALIZED_STRING(keyWorkMode), LOCALIZED_STRING(keyParameter)];
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
    
//    workModeStrings = @[@"功率模式", @"温度模式(摄氏)", @"温度模式(华氏)"]; //工作模式
    workModeStrings = @[LOCALIZED_STRING(keyPowerMode),
                        LOCALIZED_STRING(keyTemperatureModeC),
                        LOCALIZED_STRING(keyTemperatureModeF)]; //工作模式
    wattStrings = [NSMutableArray new]; //功率
    for (NSInteger i=kPowerValue_Minimum_Value; i<=kPowerValue_Maximum_Value; i=i+5) {
        double powerValue = i*0.1;
        [wattStrings addObject:[NSString stringWithFormat:@"%.1f%@", powerValue, kMark_Watt]];
    }
    centigradeStrings = [NSMutableArray new]; //摄氏度
    for (NSInteger i=kCentigrade_Minimum_Value; i<=kCentigrade_Maximum_Value; i=i+5) {
        [centigradeStrings addObject:[NSString stringWithFormat:@"%ld%@", (long)i, kMark_Centigrade]];
    }
    fahrenheitStrings = [NSMutableArray new]; //华氏度
    for (NSInteger i=kFahrenheit_Minimum_Value; i<=kFahrenheit_Maximum_Value; i=i+10) {
        [fahrenheitStrings addObject:[NSString stringWithFormat:@"%ld%@", (long)i, kMark_Fahrenheit]];
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
    
    Device *device = [UserHelper currentDevice];
    
    if (indexPath.section == 0) {
        NSString *workModeString = @"--";
        if (device != nil) {
            workModeString = [workModeStrings objectAtIndex:(device.workMode-1)];
        }
        [valueLabel setText:workModeString];
    }
    else {
        NSString *workingParamter = @"--";
        if (device != nil) {
            switch (device.workMode) {
                case BLEDeviceWorkModePower: {
                    workingParamter = [NSString stringWithFormat:@"%.1f%@", device.powerValue*0.1, kMark_Watt];
                }
                    break;
                case BLEDeviceWorkModeDegreesCentigrade:
                    workingParamter = [NSString stringWithFormat:@"%ld%@", (long)device.centigradeValue, kMark_Centigrade];
                    break;
                case BLEDeviceWorkModeDegreesFahrenheit:
                    workingParamter = [NSString stringWithFormat:@"%ld%@", (long)device.fahrenheitValue, kMark_Fahrenheit];
                    break;
            }
        }
        [valueLabel setText:workingParamter];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    
    Device *device = [UserHelper currentDevice];
    if (device == nil) {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseAddDevice)];
        return;
    }
    else { //防止出现不该出现的数值引起数组的越界崩溃
        device.powerValue       = (device.powerValue>=kPowerValue_Minimum_Value && device.powerValue<=kPowerValue_Maximum_Value)?device.powerValue:kPowerValue_Minimum_Value;
        device.centigradeValue  = (device.centigradeValue>=kCentigrade_Minimum_Value && device.centigradeValue<=kCentigrade_Maximum_Value)?device.centigradeValue:kCentigrade_Minimum_Value;
        device.fahrenheitValue  = (device.fahrenheitValue>=kFahrenheit_Minimum_Value && device.fahrenheitValue<=kFahrenheit_Maximum_Value)?device.fahrenheitValue:kFahrenheit_Minimum_Value;
    }
    
    switch (indexPath.section) {
        case 0: {
            ActionSheetStringPicker *picker =
            [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                      rows:workModeStrings
                                          initialSelection:(device.workMode-1)
                                                 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                     weakSelf.currentEditedParameterType    = EditedDeviceParameterTypeWorkMode;
                                                     weakSelf.currentEditedValue            = (selectedIndex+1);
                                                     [self sendSetWorkModeCommandByWorkMode:weakSelf.currentEditedValue];
                                                     
                                                 }
                                               cancelBlock:^(ActionSheetStringPicker *picker) {
                                                   
                                               }
                                                    origin:self.view];
            picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
            [picker showActionSheetPicker];
        }
            break;
        case 1: {
            switch (device.workMode) {
                case BLEDeviceWorkModePower: {
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:wattStrings
                                                  initialSelection:(device.powerValue-kPowerValue_Minimum_Value)/5
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             weakSelf.currentEditedParameterType    = EditedDeviceParameterTypePowerValue;
                                                             weakSelf.currentEditedValue            = (kPowerValue_Minimum_Value + selectedIndex*5);
                                                             
                                                             [self sendSetWorkModeCommandByWorkMode:BLEDeviceWorkModePower PowerOrTemp:weakSelf.currentEditedValue];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
                case BLEDeviceWorkModeDegreesCentigrade: {
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:centigradeStrings
                                                  initialSelection:(device.centigradeValue-kCentigrade_Minimum_Value)/5
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             weakSelf.currentEditedParameterType    = EditedDeviceParameterTypeCentigrade;
                                                             weakSelf.currentEditedValue            = (kCentigrade_Minimum_Value + selectedIndex*5);
                                                             
                                                             [self sendSetWorkModeCommandByWorkMode:BLEDeviceWorkModeDegreesCentigrade PowerOrTemp:weakSelf.currentEditedValue];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
                case BLEDeviceWorkModeDegreesFahrenheit: {
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:fahrenheitStrings
                                                  initialSelection:(device.fahrenheitValue-kFahrenheit_Minimum_Value)/10
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                            weakSelf.currentEditedParameterType = EditedDeviceParameterTypeFahrenheit;
                                                            weakSelf.currentEditedValue         = (kFahrenheit_Minimum_Value + selectedIndex*10);
                                                            
                                                            [self sendSetWorkModeCommandByWorkMode:BLEDeviceWorkModeDegreesFahrenheit PowerOrTemp:weakSelf.currentEditedValue];
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
            break;
    }
    
}


//=====================================================================================
#pragma mark - 发送蓝牙命令
//=====================================================================================
/**
 * 发送切换工作模式的指令
 **/
- (void)sendSetWorkModeCommandByWorkMode:(BLEDeviceWorkMode)workMode {
    Device *device = [UserHelper currentDevice];
    NSInteger settingValue;
    
    switch (workMode) {
        case BLEDeviceWorkModePower: {
            settingValue = kPowerValue_Minimum_Value;
            if (device.powerValue >= kPowerValue_Minimum_Value && device.powerValue <= kPowerValue_Maximum_Value) {
                settingValue = device.powerValue;
            }
            
        }
            break;
        case BLEDeviceWorkModeDegreesCentigrade: {
            settingValue = kCentigrade_Minimum_Value;
            if (device.centigradeValue >= kCentigrade_Minimum_Value && device.centigradeValue <= kCentigrade_Maximum_Value) {
                settingValue = device.centigradeValue;
            }
        }
            break;
        case BLEDeviceWorkModeDegreesFahrenheit: {
            settingValue = kFahrenheit_Minimum_Value;
            if (device.fahrenheitValue >= kFahrenheit_Minimum_Value && device.fahrenheitValue <= kFahrenheit_Maximum_Value) {
                settingValue = device.fahrenheitValue;
            }
        }
            break;
    }
    
    [Utility showIndicatorHUD:@""];
//    BLESetPowerOrTemperatureCommand *setPowerOrTemperatureCommand = [[BLESetPowerOrTemperatureCommand alloc] initWithSetPowerOrTemperatureCommandWithWorkMode:workMode PowerOrTemperatureValue:settingValue];
//    [[BLECommandHelper shareBLECommandHelper] sendOperationCommandWithoutResponse:setPowerOrTemperatureCommand];
}

/**
 * 发送设置工作参数的指令
 **/
- (void)sendSetWorkModeCommandByWorkMode:(BLEDeviceWorkMode)workMode PowerOrTemp:(NSInteger)powerTemp {
    [Utility showIndicatorHUD:@""];
//    BLESetPowerOrTemperatureCommand *setPowerOrTemperatureCommand = [[BLESetPowerOrTemperatureCommand alloc] initWithSetPowerOrTemperatureCommandWithWorkMode:workMode PowerOrTemperatureValue:powerTemp];
//    [[BLECommandHelper shareBLECommandHelper] sendOperationCommandWithoutResponse:setPowerOrTemperatureCommand];
}

//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    [super handleBLENotification:notification];
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    Device *device = [UserHelper currentDevice];
    
    switch (message.notificationCode) {
        case BLENotificationCodeReceiveNotifyForCharacteristic: {
//            if (message.bleOpCode == BLEOperationCodeConfirm) { /*设置成功后返回0x06*/
//                [Utility hideIndicatorHUD];
//                switch (self.currentEditedParameterType) {
//                    case EditedDeviceParameterTypeWorkMode:
//                        device.workMode = self.currentEditedValue;
//                        break;
//                    case EditedDeviceParameterTypePowerValue:
//                        device.powerValue = self.currentEditedValue;
//                        break;
//                    case EditedDeviceParameterTypeCentigrade:
//                        device.centigradeValue = self.currentEditedValue;
//                        break;
//                    case EditedDeviceParameterTypeFahrenheit:
//                        device.fahrenheitValue = self.currentEditedValue;
//                        break;
//                }
//                [DeviceDataAccessor saveDevice:device];
//                [self.layoutTableView reloadData];
//                [self showSuccessMessage:LOCALIZED_STRING(keyDeviceSetupSuccessful)];
//            }
//            else if (message.bleOpCode == BLEOperationCodeBindDevice ||
//                     message.bleOpCode == BLEOperationCodeSyncSmokingData) { /*收到从设备发来的吸烟数据，则直接刷新界面显示设备的当前值*/
//                [self.layoutTableView reloadData];
//            }
        }
            break;
        case BLENotificationCodeFailToPerformOperation: {
            [Utility hideIndicatorHUD];
            [self showErrorMessage:LOCALIZED_STRING(keyDeviceSetupFailed)];
        }
            break;
        case BLENotificationCodeDisconnectPeripheral: {
            
        }
            break;
    }
    
}




@end
