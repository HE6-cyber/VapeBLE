//
//  GetCommentListCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "GetCommentListCommand.h"

@interface GetCommentListCommand () {
    NSString        *pSession;
    long long       pBlogId;
    NSInteger       pPageIndex;
}

@end

@implementation GetCommentListCommand

- (instancetype)initGetCommentListCommandWithSession:(NSString *)session BlogId:(long long)blogId PageIndex:(NSInteger)pageIndex {
    if (self = [super init]) {
        opCode      = OperationCodeGetCommentList;
        pSession    = session;
        pBlogId     = blogId;
        pPageIndex  = pageIndex;
    }
    return self;
}

- (NSData *)getCommandData {
    GetCommentListRequestMessage *requestMsg = [GetCommentListRequestMessage new];
    requestMsg.session      = pSession;
    requestMsg.blogId       = pBlogId;
    requestMsg.pageIndex    = pPageIndex;
    
    messageData             = [requestMsg data];
    
    return [super getCommandData];
}

@end
