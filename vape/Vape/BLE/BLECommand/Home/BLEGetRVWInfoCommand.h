//
//  BLEGetRVWInfoCommand.h
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEOperationCommand.h"

@interface BLEGetRVWInfoCommand : BLEOperationCommand

- (instancetype)initBLEPickUpRVWInfoCommand:(Byte)passSsession OperationCode:(Byte)operationCode;

@end