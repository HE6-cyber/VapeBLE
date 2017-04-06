//
//  BLEGetVoltageInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetVoltageInfoCommand.h"

@implementation BLEGetVoltageInfoCommand

- (instancetype)initBLEPickUpVoltageInfoCommandWith:(Byte)passSsession {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetVoltageInfo;
    }
    return self;
}


@end
