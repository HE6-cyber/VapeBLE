//
//  BLEDataDecodingHelper.m
//  Vape
//
//  Created by Zhoucy on 2017/3/6.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLEDataDecodingHelper.h"
#import "BLEOperationCommand.h"
#import "BLEEncryptDescryptHelper.h"

@implementation BLEDataDecodingHelper

/**
 * 对收到的消息帧进行初始解码，获取会话ID、命令操作码、解密后的消息净荷
 **/
+ (BLEFrame *)decodeReceivedData:(NSData *)receivedData macAddress:(NSArray *)macAddress {
    
    BLEFrame *frame = nil;
    if (receivedData.length == kCommandLength && macAddress.count == 6) {
        UInt64 startCode = [self decodeData:[receivedData subdataWithRange:NSMakeRange(0, 1)]];
        //==================================================================
        //校验：对所有的字节进行异或运算
        //==================================================================
        Byte commandBuffer[kCommandLength];
        [receivedData getBytes:commandBuffer range:NSMakeRange(0, kCommandLength)];
        Byte checkXOR8 = commandBuffer[0];
        for (int i=1; i<(kCommandLength-1); i++) {
            checkXOR8 = checkXOR8 ^ commandBuffer[i];
        }
        
        if (startCode == kSTART_CODE && checkXOR8 == commandBuffer[kCommandLength-1]) {
            UInt64 functionPart = [self decodeData:[receivedData subdataWithRange:NSMakeRange(1, 2)]];
            Byte sessionNo = (functionPart & 0xE000) >> 13;
            UInt16 bleOpcode = functionPart & 0x1FFF;
            
            Byte encryptedPayload[kPayloadLength], payload[kPayloadLength];
            [receivedData getBytes:encryptedPayload range:NSMakeRange(3, kPayloadLength)];
            Byte macLast3Byte[3] = {[macAddress[3] unsignedCharValue],
                                    [macAddress[4] unsignedCharValue],
                                    [macAddress[5] unsignedCharValue]};
            rc5AndXORDecrypt(encryptedPayload, payload, kPayloadLength, macLast3Byte, 3);
            
            frame = [BLEFrame new];
            frame.sessionNo = sessionNo;
            frame.bleOpCode = bleOpcode;
            frame.payloadData = [NSData dataWithBytes:payload length:kPayloadLength];
        }
        
    }
    
    return  frame;
    
}




//=========================================================================================
#pragma mark - 辅助方法
//=========================================================================================
/**
 * 将NSData转换成UInt64：
 * 1）NSData的长度不能大于8字节；
 * 2）解码使用的大端字节序：高位字节在前，低位字节在后的规则
 **/
+ (UInt64)decodeData:(NSData *)data {
    int length = (int)data.length;
    UInt64 returnValue = 0;
    if (length > 0 && length <= 8) {
        Byte buffer[length];
        Byte dstBuffer[length];
        [data getBytes:buffer length:length];
        
        for (int i=0; i<length; i++) {
            dstBuffer[length-(i+1)] = buffer[i];
        }
        memcpy(&returnValue, dstBuffer, length);
    }
    
    return returnValue;
}



@end
