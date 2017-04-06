//
//  BLEMessage.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEOperationCommand.h"

#define BLECommandHelperNotification                @"BLECommandHelperNotification"
#define kUserInfo_Key_Message                       @"UserInfo_Key_Message"

typedef NS_ENUM(NSInteger, BLENotificationCode) {
    ///开启蓝牙功能
    BLENotificationCodeDevicePowerOn                    = 0x0001,
    
    
    ///发现设备
    BLENotificationCodeDiscoverPeripheral               = 0x0002,
    ///设备已连接成功
    BLENotificationCodeSucceedToConnectPeripheral       = 0x0003,
    ///设备已经初始化完成
    BLENotificationCodeInitPeripheralCompleted          = 0x0004,
    ///从通知特征收到消息
    BLENotificationCodeReceiveNotifyForCharacteristic   = 0x0005,
    
    
    ///设备不支持蓝牙或者未开启蓝牙功能
    BLENotificationCodeDeviceUnSupported                = 0x0006,
    ///未添加设备
    BLENotificationCodeNotAddDevice                     = 0x0007,
    
    
    BLENotificationCodeDiscoverDeviceTimeOut            = 0x0008,
    ///连接设备超时
    BLENotificationCodeConnectDeviceTimeOut             = 0x0009,
    ///重连设备超时
    BLENotificationCodeReconnectDeviceTimeOut           = 0x0010,
    ///初始化设备超时
    BLENotificationCodeInitDeviceTimeOut                = 0x0011,
    ///执行操作失败
    BLENotificationCodeFailToPerformOperation           = 0x0012,
    
    
    ///断开设备连接
    BLENotificationCodeDisconnectPeripheral             = 0x0013,
    ///设备连接失败
    BLENotificationCodeFailToConnect                    = 0x0014,
    ///未找到指定UUID的设备（重连未找到设备）
    BLENotificationCodeNotFoundDevice                   = 0x0015
    
    
};

@class DiscoveredPeripheral;
@class CBPeripheral;

@interface BLEMessage : NSObject

@property (assign, nonatomic) BLENotificationCode       notificationCode;

@property (assign, nonatomic) BLEOperationCode          bleOpCode;
@property (strong, nonatomic) DiscoveredPeripheral      *discoveredPeripheral;
@property (strong, nonatomic) CBPeripheral              *peripheral;

+ (BLEMessage *)messageWithNotificationCode:(BLENotificationCode)notificationCode BleOpCode:(BLEOperationCode)bleOpCode DiscoveredPeripheral:(DiscoveredPeripheral *)discoveredPeripheral Peripheral:(CBPeripheral *)peripheral;

+ (BLEMessage *)messageWithNotificationCode:(BLENotificationCode)notificationCode;

@end
