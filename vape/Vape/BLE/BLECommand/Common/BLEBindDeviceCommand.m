//
//  BLEBindDeviceCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/3.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEBindDeviceCommand.h"

@implementation BLEBindDeviceCommand

- (instancetype)initBLEBindDeviceCommandWithMacAddress:(NSArray *)macAddress {
    if (self = [super init]) {
        sessionNo = 1;
        bleOpCode = BLEOperationCodeBindDevice;
        
        if (macAddress != nil && macAddress.count == 6) {
            for (int i=0; i<6; i++) {
                macAddressBytes[i] = [macAddress[i] unsignedCharValue];
                payloadBuffer[i] = [macAddress[i] unsignedCharValue];
            }
        }
//        messageBuffer[0] = 0x01;
//        messageBuffer[1] = 0x02;
//        messageBuffer[2] = 0x03;
//        messageBuffer[3] = 0x04;
//        messageBuffer[4] = 0x05;
//        messageBuffer[5] = 0x06;
//        messageBuffer[6] = 0x07;
//        messageBuffer[7] = 0x08;
//        messageBuffer[8] = 0x09;
//        messageBuffer[9] = 0x0A;
//        messageBuffer[10] = 0x0B;
//        messageBuffer[11] = 0x0C;
//        messageBuffer[12] = 0x0D;
//        messageBuffer[13] = 0x0E;
//        messageBuffer[14] = 0x0F;
//        messageBuffer[15] = 0x10;
        
    }
    return self;
}

@end
