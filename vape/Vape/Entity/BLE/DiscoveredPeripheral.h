//
//  DiscoveredPeripheral.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DiscoveredPeripheral : NSObject

@property (strong, nonatomic) CBPeripheral  *peripheral;
@property (strong, nonatomic) NSDictionary  *advertisementData;
@property (strong, nonatomic) NSNumber      *RSSI;
@property (strong, nonatomic) NSString      *peripheralName;
@property (assign, nonatomic) BOOL          isConnected;

@property (strong, nonatomic) NSArray       *macAddress; //设备的MAC地址

-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral AdvertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI PeripheralName:(NSString *)peripheralName IsConnected:(BOOL)isConnected;

@end
