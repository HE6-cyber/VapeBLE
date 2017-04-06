//
//  GetBlogListCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "GetLikeListCommand.h"

@interface GetLikeListCommand () {
    NSString        *pSession;
    long long       pBlogId;
    NSInteger       pPageIndex;
}

@end

@implementation GetLikeListCommand

- (instancetype)initGetLikeListCommandWithSession:(NSString *)session BlogId:(long long)blogId PageIndex:(NSInteger)pageIndex {
    if (self = [super init]) {
        opCode      = OperationCodeGetLikeList;
        pSession    = session;
        pBlogId     = blogId;
        pPageIndex  = pageIndex;
    }
    return self;
}

- (NSData *)getCommandData {
    GetLikeListRequestMessage *requestMsg = [GetLikeListRequestMessage new];
    requestMsg.session      = pSession;
    requestMsg.blogId       = pBlogId;
    requestMsg.pageIndex    = pPageIndex;
    
    messageData             = [requestMsg data];
    
    return [super getCommandData];
}

@end
