//
//  BLEFrame.h
//  Vape
//
//  Created by Zhoucy on 2017/3/7.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEFrame : NSObject

@property (assign, nonatomic) int       sessionNo;  //会话ID
@property (assign, nonatomic) int       bleOpCode;  //命令操作码
@property (strong, nonatomic) NSData    *payloadData; //净荷

@end
