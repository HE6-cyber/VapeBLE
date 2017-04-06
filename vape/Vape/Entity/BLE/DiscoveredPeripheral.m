//
//  DiscoveredPeripheral.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DiscoveredPeripheral.h"

@implementation DiscoveredPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral AdvertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI PeripheralName:(NSString *)peripheralName IsConnected:(BOOL)isConnected {
    if (self = [super init]) {
        self.peripheral         = peripheral;
        self.advertisementData  = advertisementData;
        self.RSSI               = RSSI;
        self.peripheralName     = peripheralName;
        self.isConnected        = isConnected;
    }
    return self;
}

@end
