//
//  BLEMessage.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEMessage.h"

@implementation BLEMessage

+ (BLEMessage *)messageWithNotificationCode:(BLENotificationCode)notificationCode BleOpCode:(BLEOperationCode)bleOpCode DiscoveredPeripheral:(DiscoveredPeripheral *)discoveredPeripheral Peripheral:(CBPeripheral *)peripheral {
    BLEMessage *bleMessage = [[BLEMessage alloc] init];
    bleMessage.notificationCode     = notificationCode;
    bleMessage.bleOpCode            = bleOpCode;
    bleMessage.discoveredPeripheral = discoveredPeripheral;
    bleMessage.peripheral           = peripheral;
    return bleMessage;
}

+ (BLEMessage *)messageWithNotificationCode:(BLENotificationCode)notificationCode {
    BLEMessage *bleMessage = [BLEMessage messageWithNotificationCode:notificationCode BleOpCode:0 DiscoveredPeripheral:nil Peripheral:nil];
    return bleMessage;
}
@end
