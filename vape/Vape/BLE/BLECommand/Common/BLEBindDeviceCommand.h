//
//  BLEBindDeviceCommand.h
//  Vape
//
//  Created by Zhoucy on 2017/3/3.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEOperationCommand.h"

@interface BLEBindDeviceCommand : BLEOperationCommand

- (instancetype)initBLEBindDeviceCommandWithMacAddress:(NSArray *)macAddress;

@end
