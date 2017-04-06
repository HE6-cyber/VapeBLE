//
//  DownloadSmokingLocationDataCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DownloadSmokingLocationDataCommand.h"

@interface DownloadSmokingLocationDataCommand () {
    NSString    *pSession;
    long long   pLastSyncTime;
}

@end

@implementation DownloadSmokingLocationDataCommand

- (instancetype)initDownloadSmokingLocationCommandWithSession:(NSString *)session LastSyncTime:(long long)lastSyncTime {
    if (self = [super init]) {
        opCode          = OperationCodeDownloadSmokingLocationData;
        pSession        = session;
        pLastSyncTime   = lastSyncTime;
    }
    return self;
}

- (NSData *)getCommandData {
    
    DownloadSmokingLocationDataRequestMessage *requestMsg = [DownloadSmokingLocationDataRequestMessage new];
    requestMsg.session  = pSession;
    requestMsg.time     = pLastSyncTime;
    messageData         = [requestMsg data];
    
    return [super getCommandData];
}

@end
