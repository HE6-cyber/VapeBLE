//
//  BLEGetRVWInfoCommand.m
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEGetRVWInfoCommand.h"

@implementation BLEGetRVWInfoCommand

- (instancetype)initBLEPickUpRVWInfoCommand:(Byte)passSsession OperationCode:(Byte)operationCode {
    if (self = [super init]) {
        sessionNo = passSsession;
        bleOpCode = BLEOperationCodeGetRVW;
        payloadBuffer[0] = operationCode;
    }
    return self;
}


@end
