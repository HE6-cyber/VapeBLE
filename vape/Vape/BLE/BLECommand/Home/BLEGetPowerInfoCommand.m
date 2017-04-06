//
//  BLEGetPowerInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetPowerInfoCommand.h"

@implementation BLEGetPowerInfoCommand

- (instancetype)initBLEPickUpPowerInfoCommandWithSessionNo:(Byte)passSsession {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetPowerInfo;
    }
    return self;
}

@end
