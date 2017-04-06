//
//  SyncDataHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationCommand.h"

@protocol SyncDataHelperDelegate;

extern const NSInteger  kNumber_Per_Time;

@interface SyncDataHelper : NSObject

@property (weak, nonatomic) id<SyncDataHelperDelegate> delegate;

//=====================================================================================
#pragma mark - 获取类的实例对象
//=====================================================================================
/** 获取SyncDataHelper的公用实例对象 */
+ (SyncDataHelper *)shareSyncDataHelperWithDelegate:(id<SyncDataHelperDelegate>)delegate;

/** 开始下载吸烟数据 */
- (void)startDownloadSmokingData;

@end


@protocol SyncDataHelperDelegate <NSObject>

- (void)didSyncSuccessWithOpCode:(OperationCode)opCode;
- (void)didSyncFailureWithOpCode:(OperationCode)opCode ErrorMsg:(NSString *)errorMsg;

@end
