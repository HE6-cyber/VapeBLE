//
//  BLEOperationCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEOperationCommand.h"
#import "BLEEncryptDescryptHelper.h"

const int   kCommandLength   = 20;
const int   kPayloadLength   = 16;
const Byte  kSTART_CODE      = 0x3A;  //帧头起始码

@interface BLEOperationCommand () {
//    NSMutableData       *commandData; 字节数组[20]
    Byte               commandBuffer[kCommandLength];    //指令缓冲区，固定20个字节
}

@end


@implementation BLEOperationCommand

- (instancetype)init {
    if (self = [super init]) {
//        commandData = [[NSMutableData alloc] initWithCapacity:kCommandLength];
        memset(commandBuffer, 0, kCommandLength); //将数组的所有元素初始化为0
        memset(payloadBuffer, 0, kPayloadLength);
    }
    return self;
}


- (NSData *)getCommandData {
    
    //==================================================================
    //起始码
    //==================================================================
    commandBuffer[0] = kSTART_CODE;
    
    //==================================================================
    //序号、命令
    //指令使用大端字节序(即网络字节序)，高位字节在前，低位字节在后；
    //会话标识使用高位字节中的最高3位
    //==================================================================
    Byte highByteOfBleOpCode    = (Byte)(bleOpCode >> 8 & 0xFF);
    Byte lowerByteOfBleOpCode   = (Byte)(bleOpCode & 0xFF);
    commandBuffer[1] = highByteOfBleOpCode | (sessionNo << 5);
    commandBuffer[2] = lowerByteOfBleOpCode;
    
    //==================================================================
    //对净荷部分进行异或与RC5加密
    //==================================================================
    Byte macLast3Byte[3] = {macAddressBytes[3], macAddressBytes[4], macAddressBytes[5]};
    Byte encryptedPayload[kPayloadLength];
    memset(encryptedPayload, 0, kPayloadLength);
    xorAndRC5Encrypt(payloadBuffer, encryptedPayload, kPayloadLength, macLast3Byte, 3);
    
    //将加密的净荷部分填充到消息缓冲区
    for (int i=0; i<kPayloadLength; i++) {
        commandBuffer[3+i] = encryptedPayload[i];
    }
    
//    //测试解密
//    Byte dst2[kMessageLength];
//    memset(dst2, 0, kMessageLength);
//    rc5AndXORDecrypt(dst, dst2, kMessageLength, macLast3Byte, 3);
//    for (int i=0; i<kMessageLength; i++) {
//        commandBuffer[3+i] = dst2[i];
//    }
    
    //==================================================================
    //校验：对所有的字节进行异或运算
    //==================================================================
    Byte checkXOR8 = commandBuffer[0];
    for (int i=1; i<(kCommandLength-1); i++) {
        checkXOR8 = checkXOR8 ^ commandBuffer[i];
    }
    commandBuffer[kCommandLength-1] = checkXOR8;
    
    return [NSData dataWithBytes:commandBuffer length:kCommandLength];
}

///get command operationcode
- (BLEOperationCode)getOperationCode{
    return bleOpCode;
}



@end
