//
//  UploadSmokingLocationDataCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UploadSmokingLocationDataCommand.h"

@interface UploadSmokingLocationDataCommand () {
    NSString    *pSession;
    NSArray     *pSmokingLocationDataMsgs;
}

@end

@implementation UploadSmokingLocationDataCommand

- (instancetype)initUploadSmokingLocationDataCommandWithWithSession:(NSString *)session SmokingLocationDataMsgs:(NSArray *)smokingLocationDataMsgs {
    if (self = [super init]) {
        opCode                      = OperationCodeUploadSmokingLocationData;
        pSession                    = session;
        pSmokingLocationDataMsgs    = smokingLocationDataMsgs;
    }
    return self;
}

- (NSData *)getCommandData {
    
    UploadSmokingLocationDataRequestMessage *requestMsg = [UploadSmokingLocationDataRequestMessage new];
    requestMsg.session                      = pSession;
    requestMsg.phoneType                    = PhoneType_IPhone;
    requestMsg.smokingLocationDatasArray    = [NSMutableArray arrayWithArray:pSmokingLocationDataMsgs];
    messageData                     = [requestMsg data];
    
    return [super getCommandData];
}

@end
