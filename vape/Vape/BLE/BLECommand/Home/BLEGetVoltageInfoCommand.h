//
//  BLEGetVoltageInfoCommand.h
//  Vape
//
//  Created by WestWood on 2017/3/15.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEOperationCommand.h"

@interface BLEGetVoltageInfoCommand : BLEOperationCommand

- (instancetype)initBLEPickUpVoltageInfoCommandWith:(Byte)passSsession;

@end