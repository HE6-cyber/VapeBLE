//
//  OperationCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "OperationCommand.h"

//=============================================================================
/// 消息头部相关的宏定义
//=============================================================================
const int START_CODE                = 0xAAAAAAAA;
const int START_CODE_LENGTH         = 4;
const int DATA_SIZE_VALUE_LENGTH    = 4;
const int OPERATION_CODE_LENGTH     = 4;



@implementation OperationCommand

///返回命令所发送的字节码：消息长度值 = 长度(4byte) + 操作码(4byte)
- (NSData *)getCommandData {
    
    int startCodeByToBig        = NSSwapHostIntToBig(START_CODE);
    int lengthByToBig           = NSSwapHostIntToBig((int)messageData.length + DATA_SIZE_VALUE_LENGTH + OPERATION_CODE_LENGTH);
    int operationCodeByToBig    = NSSwapHostIntToBig(opCode);
    
    NSMutableData *sendData = [NSMutableData new];
    [sendData appendData:[NSData dataWithBytes:&startCodeByToBig        length:START_CODE_LENGTH]];
    [sendData appendData:[NSData dataWithBytes:&lengthByToBig           length:DATA_SIZE_VALUE_LENGTH]];
    [sendData appendData:[NSData dataWithBytes:&operationCodeByToBig    length:OPERATION_CODE_LENGTH]];
    [sendData appendData:messageData];
    
    return sendData;
}

///返回命令的操作码
- (OperationCode)getOperationCode {
    return opCode;
}

///判断指定的数值是否是正确的操作码
+ (BOOL)isOperationCode:(NSInteger)codeValue {
    if (codeValue==OperationCodeRegister ||
        codeValue==OperationCodeLogin ||
        codeValue==OperationCodeUpdatePassword ||
        codeValue==OperationCodeResetPassword ||
        codeValue==OperationCodeUpdateProfile ||
        codeValue==OperationCodeUploadSmokingData ||
        codeValue==OperationCodeDownloadSmokingData ||
        codeValue==OperationCodeUploadSmokingLocationData ||
        codeValue==OperationCodeDownloadSmokingLocationData ||
        codeValue==OperationCodeGetBlogList ||
        codeValue==OperationCodeGetCommentList ||
        codeValue==OperationCodeGetLikeList ||
        codeValue==OperationCodeUploadHeartRateData ||
        codeValue==OperationCodeDownloadHeartRateData) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
