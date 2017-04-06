//
//  UploadHeartRateDataCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UploadHeartRateDataCommand.h"

@interface UploadHeartRateDataCommand () {
    NSString    *pSession;
    NSArray     *pHeartRateDataMsgs;
}

@end

@implementation UploadHeartRateDataCommand

- (instancetype)initUploadHeartRateDataCommandWithSession:(NSString *)session HeartRateDataMsgs:(NSArray *)heartRateDataMsgs {
    if (self = [super init]) {
        opCode              = OperationCodeUploadHeartRateData;
        pSession            = session;
        pHeartRateDataMsgs  = heartRateDataMsgs;
    }
    return self;
}

- (NSData *)getCommandData {
    UploadHeartRateDataRequestMessage *requestMsg = [UploadHeartRateDataRequestMessage new];
    requestMsg.session              = pSession;
    requestMsg.phoneType            = PhoneType_IPhone;
    requestMsg.heartRateDatasArray  = [NSMutableArray arrayWithArray:pHeartRateDataMsgs];
    messageData                     = [requestMsg data];
    
    return [super getCommandData];
}

@end
