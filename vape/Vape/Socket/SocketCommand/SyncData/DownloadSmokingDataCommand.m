//
//  DownloadSmokingDataCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DownloadSmokingDataCommand.h"

@interface DownloadSmokingDataCommand () {
    NSString    *pSession;
    long long   pLastSyncTime;
}

@end

@implementation DownloadSmokingDataCommand

- (instancetype)initDownloadSmokingDataCommandWithSession:(NSString *)session LastSyncTime:(long long)lastSyncTime {
    if (self = [super init]) {
        opCode          = OperationCodeDownloadSmokingData;
        pSession        = session;
        pLastSyncTime   = lastSyncTime;
    }
    return self;
}

- (NSData *)getCommandData {
    
    DownloadSmokingDataRequestMessage *requestMsg = [DownloadSmokingDataRequestMessage new];
    requestMsg.session  = pSession;
    requestMsg.time     = pLastSyncTime;
    messageData         = [requestMsg data];
    
    return [super getCommandData];
}

@end
