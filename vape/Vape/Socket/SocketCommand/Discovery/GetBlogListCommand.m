//
//  GetBlogListCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "GetBlogListCommand.h"

@interface GetBlogListCommand () {
    NSString        *pSession;
    NSInteger       pPageIndex;
}

@end

@implementation GetBlogListCommand

- (instancetype)initGetBlogListCommandWithSession:(NSString *)session PageIndex:(NSInteger)pageIndex {
    if (self = [super init]) {
        opCode      = OperationCodeGetBlogList;
        pSession    = session;
        pPageIndex  = pageIndex;
    }
    return self;
}

- (NSData *)getCommandData {
    GetBlogListRequestMessage *requestMsg = [GetBlogListRequestMessage new];
    requestMsg.session      = pSession;
    requestMsg.pageIndex    = pPageIndex;
    
    messageData             = [requestMsg data];
    
    return [super getCommandData];
}

@end
