//
//  UploadSmokingDataCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UploadSmokingDataCommand.h"

@interface UploadSmokingDataCommand () {
    NSString   *pSession;
    NSArray    *pSmokingDataMsgs;
}

@end

@implementation UploadSmokingDataCommand

- (instancetype)initUploadSmokingDataCommandWithSession:(NSString *)session SmokingDataMsgs:(NSArray *)smokingDataMsgs {
    if (self = [super init]) {
        opCode              = OperationCodeUploadSmokingData;
        pSession            = session;
        pSmokingDataMsgs    = smokingDataMsgs;
    }
    return self;
}

- (NSData *)getCommandData {
    
    UploadSmokingDataRequestMessage *requestMsg = [UploadSmokingDataRequestMessage new];
    requestMsg.session              = pSession;
    requestMsg.phoneType            = PhoneType_IPhone;
    requestMsg.smokingDatasArray    = [NSMutableArray arrayWithArray:pSmokingDataMsgs];
    messageData                     = [requestMsg data];
    
    return [super getCommandData];
}

@end
