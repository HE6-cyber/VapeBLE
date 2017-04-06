//
//  BLEGetRVVInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetRVVInfoCommand.h"

@implementation BLEGetRVVInfoCommand

- (instancetype)initBLEPickUpVoltageInfoCommandWith:(Byte)passSsession {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetRVV;
    }
    return self;
}

@end
