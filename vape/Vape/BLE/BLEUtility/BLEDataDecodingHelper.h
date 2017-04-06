//
//  BLEDataDecodingHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/6.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEFrame.h"

@interface BLEDataDecodingHelper : NSObject

/** 对收到的消息帧进行初始解码，获取会话ID、命令操作码、解密后的消息净荷 */
+ (BLEFrame *)decodeReceivedData:(NSData *)receivedData macAddress:(NSArray *)macAddress;

@end
