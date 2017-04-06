//
//  BLEGetFahrenheitInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetFahrenheitInfoCommand.h"

@implementation BLEGetFahrenheitInfoCommand

- (instancetype)initBLEPickUpFahrenheitInfoCommand:(Byte)passSsession {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetFahreheit;
    }
    return self;
}

@end
