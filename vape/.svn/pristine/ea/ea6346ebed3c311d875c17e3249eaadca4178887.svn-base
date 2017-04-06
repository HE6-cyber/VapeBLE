//
//  DownloadHeartRateDataCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DownloadHeartRateDataCommand.h"

@interface DownloadHeartRateDataCommand () {
    NSString    *pSession;
    long long   pLastSyncTime;
}

@end

@implementation DownloadHeartRateDataCommand

- (instancetype)initDownloadHeartRateDataCommandWithSession:(NSString *)session LastSyncTime:(long long)lastSyncTime {
    if (self = [super init]) {
        opCode          = OperationCodeDownloadHeartRateData;
        pSession        = session;
        pLastSyncTime   = lastSyncTime;
    }
    return self;
}

- (NSData *)getCommandData {
    DownloadHeartRateDataRequestMessage *requestMsg = [DownloadHeartRateDataRequestMessage new];
    requestMsg.session  = pSession;
    requestMsg.time     = pLastSyncTime;
    messageData         = [requestMsg data];
    
    return [super getCommandData];
}

@end
