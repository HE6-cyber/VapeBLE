//
//  BLECommandHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "BLEOperationCommand.h"
#import "DiscoveredPeripheral.h"
#import "BLEMessage.h"


//=========================================公用常量=============================================

//=============================================================================================

/** 蓝牙的连接状态 */
typedef NS_ENUM(NSInteger, BLEConnectStatus) {
    ///设备不支持或蓝牙已关闭
    BLEConnectStatusDeviceUnSupport,
    ///设备开启并可用
    BLEConnectStatusDevicePoweredOn,
    ///已发现设备
    BLEConnectStatusDiscoveredDevice,
    ///设备连接成功
    BLEConnectStatusConnected,
    ///设备连接失败
    BLEConnectStatusConnectDeviceFailure,
    ///设备断开连接
    BLEConnectStatusDisConnected,
    ///设备初始化完成
    BLEConnectStatusDeviceInitCompleted
};


@interface BLECommandHelper : NSObject



///获取类的公用实例对象
+ (BLECommandHelper *)shareBLECommandHelper;

- (BLEConnectStatus)connectStatus;

///扫描蓝牙设备
- (void)scan;

- (void)stopScan;

- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)connectToPeripheralWithUUIDString:(NSString *)UUIDString;

/** 断开当前连接 **/
- (void)cancelCurrentPeripheral;

/** 返回当前连接的蓝牙设备的UUID */
- (NSString *)currentPeripheralUUIDString;

///获取已配对的蓝牙设备列表
- (NSArray *)retrieveConnectedPeripherals;

- (void)sendOperationCommandWithoutResponse:(BLEOperationCommand *)command;

@end
