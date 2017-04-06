//
//  BLEGetVapeInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetVapeInfoCommand.h"

@implementation BLEGetVapeInfoCommand

- (instancetype)initBLEPickUpVapeInfoCommandWithSessionNo:(Byte)passSsession {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetDeviceInfo;
    }
    return self;
}


@end
