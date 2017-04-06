//
//  BLEGetCentigradeInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetCentigradeInfoCommand.h"

@implementation BLEGetCentigradeInfoCommand

- (instancetype)initBLEPickUpCentigradeInfoCommand:(Byte)passSsession {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetCentigrade;
    }
    return self;
}

@end
