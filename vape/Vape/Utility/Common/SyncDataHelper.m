//
//  SyncDataHelper.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "SyncDataHelper.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NSManagedObject+Custom.h"
#import "TcpCommandHelper.h"
#import "Smoking.h"
#import "DBSmoking.h"
#import "DBSmokingDetail.h"
#import "UserHelper.h"
#import "Utility.h"


#define kESmoking_SmokingDataSyncTime                   @"kESmoking_SmokingDataSyncTime"
#define kESmoking_SmokingLocationDataSyncTime           @"kESmoking_SmokingLocationDataSyncTime"
#define kESmoking_HeartRateDataSyncTime                 @"kESmoking_HeartRateDataSyncTime"

#define kFieldName_UserId           @"userId"
#define kFieldName_SyncTag          @"syncTag"
#define kFieldName_SmokingId        @"smokingId"
#define kFieldName_HeartRateId      @"heartRateId"

const NSInteger  kNumber_Per_Time     = 50000;

static SyncDataHelper   *shareSyncDataHelper;

@interface SyncDataHelper () <TcpCommandHelperDelegate>

@property (strong, nonatomic) TcpCommandHelper  *tcpCommandHelper;


@end

@implementation SyncDataHelper

//=====================================================================================
#pragma mark - 获取类的实例对象
//=====================================================================================
/**
 * 获取SyncDataHelper的公用实例对象
 **/
+ (SyncDataHelper *)shareSyncDataHelperWithDelegate:(id<SyncDataHelperDelegate>)delegate {
    static dispatch_once_t  predicate;
    if (shareSyncDataHelper == nil) {
        dispatch_once(&predicate, ^{
            shareSyncDataHelper = [[SyncDataHelper alloc] init];
        });
    }
    [shareSyncDataHelper setDelegate:delegate];
    return shareSyncDataHelper;
}

/**
 * 初始化方法
 **/
- (instancetype)init {
    if (self = [super init]) {
        self.tcpCommandHelper = [TcpCommandHelper tcpCommandHelperWithDelegate:self];
    }
    return self;
}

//=====================================================================================
#pragma mark - 处理用户登录的辅助方法
//=====================================================================================
/**
 * 保存吸烟数据的上一次同步时间
 **/
+ (void)saveSmokingDataSyncTime:(long long)smokingDataSyncTime {
    [[NSUserDefaults standardUserDefaults] setObject:@(smokingDataSyncTime) forKey:kESmoking_SmokingDataSyncTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 保存吸烟位置的上一次同步时间
 **/
+ (void)saveSmokingLocationDataSyncTime:(long long)smokingLocationDataSyncTime {
    [[NSUserDefaults standardUserDefaults] setObject:@(smokingLocationDataSyncTime) forKey:kESmoking_SmokingLocationDataSyncTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 保存心率血氧的上一次同步时间
 **/
+ (void)saveHeartRateDataSyncTime:(long long)heartRateDataSyncTime {
    [[NSUserDefaults standardUserDefaults] setObject:@(heartRateDataSyncTime) forKey:kESmoking_HeartRateDataSyncTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 * 获取吸烟数据的上一次同步时间
 **/
+ (long long)getSmokingDataSyncTime {
    NSNumber *smokingDataSyncTime  = [[NSUserDefaults standardUserDefaults] objectForKey:kESmoking_SmokingDataSyncTime];
    if (smokingDataSyncTime != nil) {
        return [smokingDataSyncTime longLongValue];
    }
    else {
        return 0;
    }
}

/**
 * 获取吸烟位置的上一次同步时间
 **/
+ (long long)getSmokingLocationDataSyncTime {
    NSNumber *smokingLocationDataSyncTime  = [[NSUserDefaults standardUserDefaults] objectForKey:kESmoking_SmokingLocationDataSyncTime];
    if (smokingLocationDataSyncTime != nil) {
        return [smokingLocationDataSyncTime longLongValue];
    }
    else {
        return 0;
    }
}

/**
 * 获取心率血氧的上一次同步时间
 **/
+ (long long)getHeartRateDataSyncTime {
    NSNumber *heartRateDataSyncTime  = [[NSUserDefaults standardUserDefaults] objectForKey:kESmoking_HeartRateDataSyncTime];
    if (heartRateDataSyncTime != nil) {
        return [heartRateDataSyncTime longLongValue];
    }
    else {
        return 0;
    }
}




//=====================================================================================
#pragma mark - 下载吸烟数据与吸烟位置数据
//=====================================================================================
/**
 * 开始下载吸烟数据
 **/
- (void)startDownloadSmokingData {
    if ([UserHelper isLogin]) {
        DownloadSmokingDataCommand *downloadSmokingDataCommand = [[DownloadSmokingDataCommand alloc] initDownloadSmokingDataCommandWithSession:[UserHelper currentUserSession]
                                                                                                                                  LastSyncTime:[SyncDataHelper getSmokingDataSyncTime]];
        [self.tcpCommandHelper sendCommandWithNoCheckNetworkStatus:downloadSmokingDataCommand];
    }
}


/**
 * 开始下载吸烟位置数据
 **/
- (void)startDownloadSmokingLocationData {
    if ([UserHelper isLogin]) {
        DownloadSmokingLocationDataCommand *downloadSmokingLocationDataCommand = [[DownloadSmokingLocationDataCommand alloc] initDownloadSmokingLocationCommandWithSession:[UserHelper currentUserSession] LastSyncTime:[SyncDataHelper getSmokingLocationDataSyncTime]];
        [self.tcpCommandHelper sendCommandWithNoCheckNetworkStatus:downloadSmokingLocationDataCommand];
    }
}

/**
 * 开始下载吸烟位置数据
 **/
- (void)startDownloadHeartRateData {
    if ([UserHelper isLogin]) {
        DownloadHeartRateDataCommand *downloadHeartRateDataCommand = [[DownloadHeartRateDataCommand alloc] initDownloadHeartRateDataCommandWithSession:[UserHelper currentUserSession] LastSyncTime:[SyncDataHelper getHeartRateDataSyncTime]];
        [self.tcpCommandHelper sendCommandWithNoCheckNetworkStatus:downloadHeartRateDataCommand];
    }
}




//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
/**
 * Socket调用正常返回
 **/
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    DebugLog(@"syncData---------------------------------");
    NSError *error;
    switch (opCode) {
        case OperationCodeDownloadSmokingData: {
            DownloadSmokingDataResponseMessage *downloadSmokingDataResponseMsg = [DownloadSmokingDataResponseMessage parseFromData:result error:&error];
            if (error == nil && downloadSmokingDataResponseMsg != nil && downloadSmokingDataResponseMsg.errorMsg.errorCode == 0) {
                
                //===================================================
                //处理下载吸烟数据时从服务端返回的结果
                //===================================================
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
                    NSInteger index = 0;
                    for (SmokingDataMessage *smokingDataMsg in downloadSmokingDataResponseMsg.smokingDatasArray) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%lld", kFieldName_SmokingId, smokingDataMsg.smokingId, kFieldName_UserId, [UserHelper currentUserId]];
                        DBSmoking *sSmoking = [DBSmoking MR_findFirstWithPredicate:predicate inContext:localContext];
                        if (sSmoking == nil) {
                            sSmoking = [DBSmoking MR_createEntityInContext:localContext];
                            sSmoking.smokingId       = @(smokingDataMsg.smokingId);
                            sSmoking.userId          = @(smokingDataMsg.userId);
                            
                            sSmoking.smokingDt       = [NSDate dateWithTimeIntervalSince1970:(smokingDataMsg.smokingDt/1000)];
                            sSmoking.hourIndex       = @(smokingDataMsg.hourIndex);
                            sSmoking.dayIndex        = @(smokingDataMsg.dayIndex);
                            sSmoking.monthIndex      = @(smokingDataMsg.monthIndex);
                            sSmoking.yearIndex       = @(smokingDataMsg.yearIndex);
                            sSmoking.numberOfPuffs   = @(smokingDataMsg.numberOfPuffs);
                            
                            sSmoking.workMode        = @(smokingDataMsg.workMode);
                            sSmoking.powerOrTemp     = @(smokingDataMsg.powerTemp);
                            sSmoking.smokingTime     = @(smokingDataMsg.smokingTime);
                            sSmoking.battery         = @(smokingDataMsg.battery);
                            sSmoking.resistanceValue = @(smokingDataMsg.resistanceValue);
                            
                            sSmoking.longitude       = @(smokingDataMsg.longitude);
                            sSmoking.latitude        = @(smokingDataMsg.latitude);
                            sSmoking.address         = smokingDataMsg.address;
                            sSmoking.syncTag         = @(SyncTagSynchronized);
                        }
                        else {
                            sSmoking.syncTag = @(SyncTagSynchronized);
                        }
                        if (index%100 == 0) {
                            [localContext MR_saveToPersistentStoreAndWait];
                            [SyncDataHelper saveSmokingDataSyncTime:smokingDataMsg.smokingId];
                            DebugLog(@"----------%ld----------", (long)index);
                        }
                        index++;
                    }
                    [localContext MR_saveToPersistentStoreAndWait];
                    [SyncDataHelper saveSmokingDataSyncTime:[downloadSmokingDataResponseMsg.smokingDatasArray lastObject].smokingId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startDownloadSmokingLocationData];
                        if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(didSyncSuccessWithOpCode:)]) {
                            [weakSelf.delegate didSyncSuccessWithOpCode:OperationCodeDownloadSmokingData];
                            
                        }
                        DebugLog(@"finish download smokingData: %ld", (long)downloadSmokingDataResponseMsg.smokingDatasArray.count);
                    });
                });
            }
            else {
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSyncFailureWithOpCode:ErrorMsg:)]) {
                    NSString *errorMsg = downloadSmokingDataResponseMsg != nil ? downloadSmokingDataResponseMsg.errorMsg.errorMsg : LOCALIZED_STRING(keySynchronousDataFailed);//@"下载吸烟数据失败"
                    [self.delegate didSyncFailureWithOpCode:OperationCodeDownloadSmokingData ErrorMsg:errorMsg];
                }
            }
        }
            break;
        case OperationCodeDownloadSmokingLocationData: {
            DownloadSmokingLocationDataResponseMessage *downloadSmokingLocationDataResponseMsg = [DownloadSmokingLocationDataResponseMessage parseFromData:result error:&error];
            if (error == nil && downloadSmokingLocationDataResponseMsg != nil && downloadSmokingLocationDataResponseMsg.errorMsg.errorCode == 0) {
                
                //===================================================
                //处理下载吸烟位置数据时从服务端返回的结果
                //===================================================
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
                    NSInteger index = 0;
                    for (SmokingLocationDataMessage *smokingLocationDataMsg in downloadSmokingLocationDataResponseMsg.smokingDatasArray) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%lld", kFieldName_SmokingId, smokingLocationDataMsg.smokingId, kFieldName_UserId, [UserHelper currentUserId]];
                        DBSmokingDetail *sSmokingDetail = [DBSmokingDetail MR_findFirstWithPredicate:predicate inContext:localContext];
                        if (sSmokingDetail == nil) {
                            sSmokingDetail = [DBSmokingDetail MR_createEntityInContext:localContext];
                            sSmokingDetail.smokingId       = @(smokingLocationDataMsg.smokingId);
                            sSmokingDetail.userId          = @(smokingLocationDataMsg.userId);
                            sSmokingDetail.smokingDt       = [NSDate dateWithTimeIntervalSince1970:(smokingLocationDataMsg.smokingDt/1000)];
                            
                            sSmokingDetail.workMode        = @(smokingLocationDataMsg.workMode);
                            sSmokingDetail.powerOrTemp     = @(smokingLocationDataMsg.powerTemp);
                            sSmokingDetail.smokingTime     = @(smokingLocationDataMsg.smokingTime);
                            sSmokingDetail.battery         = @(smokingLocationDataMsg.battery);
                            sSmokingDetail.resistanceValue = @(smokingLocationDataMsg.resistanceValue);
                            
                            sSmokingDetail.longitude       = @(smokingLocationDataMsg.longitude);
                            sSmokingDetail.latitude        = @(smokingLocationDataMsg.latitude);
                            sSmokingDetail.address         = smokingLocationDataMsg.address;
                            sSmokingDetail.syncTag         = @(SyncTagSynchronized);
                        }
                        else {
                            sSmokingDetail.syncTag = @(SyncTagSynchronized);
                        }
                        if (index%100 == 0) {
                            [localContext MR_saveToPersistentStoreAndWait];
                            [SyncDataHelper saveSmokingLocationDataSyncTime:smokingLocationDataMsg.smokingId];
                            DebugLog(@"-------smokingLocationDataMsg---%ld----------", (long)index);
                        }
                        index++;
                    }
                    [localContext MR_saveToPersistentStoreAndWait];
                    [SyncDataHelper saveSmokingLocationDataSyncTime:[downloadSmokingLocationDataResponseMsg.smokingDatasArray lastObject].smokingId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startDownloadHeartRateData];
                        if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(didSyncSuccessWithOpCode:)]) {
                            [weakSelf.delegate didSyncSuccessWithOpCode:OperationCodeDownloadSmokingLocationData];
                            
                        }
                        DebugLog(@"finish download smokingLocationData: %ld", (long)downloadSmokingLocationDataResponseMsg.smokingDatasArray.count);
                    });
                });

            }
            else {
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSyncFailureWithOpCode:ErrorMsg:)]) {
                    NSString *errorMsg = downloadSmokingLocationDataResponseMsg != nil ? downloadSmokingLocationDataResponseMsg.errorMsg.errorMsg : LOCALIZED_STRING(keySynchronousDataFailed);//@"下载吸烟位置数据失败"
                    [self.delegate didSyncFailureWithOpCode:OperationCodeDownloadSmokingLocationData ErrorMsg:errorMsg];
                }
            }
        }
            break;
        case OperationCodeDownloadHeartRateData: {
            DownloadHeartRateDataResponseMessage *downloadHeartRateDataResponseMsg = [DownloadHeartRateDataResponseMessage parseFromData:result error:&error];
            if (error == nil && downloadHeartRateDataResponseMsg != nil && downloadHeartRateDataResponseMsg.errorMsg.errorCode == 0) {
                
                //===================================================
                //处理下载心率血氧数据时从服务端返回的结果
                //===================================================
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
                    NSInteger index = 0;
                    for (HeartRateDataMessage *heartRateDataMsg in downloadHeartRateDataResponseMsg.heartRateDatasArray) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%lld",
                                                  kFieldName_HeartRateId, heartRateDataMsg.heartRateId, kFieldName_UserId, [UserHelper currentUserId]];
                        DBHeartRate *sHeartRate = [DBHeartRate MR_findFirstWithPredicate:predicate inContext:localContext];
                        if (sHeartRate == nil) {
                            sHeartRate = [DBHeartRate MR_createEntityInContext:localContext];
                            sHeartRate.heartRateId  = @(heartRateDataMsg.heartRateId);
                            sHeartRate.userId   = @(heartRateDataMsg.userId);
                            sHeartRate.heartRateDt = [NSDate dateWithTimeIntervalSince1970:(heartRateDataMsg.heartRateDt/1000)];
                            
                            sHeartRate.heartRate = @(heartRateDataMsg.heartRate);
                            sHeartRate.bloodOxygen = @(heartRateDataMsg.bloodOxygen);
                            
                            sHeartRate.createDt = [NSDate date];
                            sHeartRate.lastUpdateDt = [NSDate date];
                            sHeartRate.syncTag = @(SyncTagSynchronized);
                        }
                        else {
                            sHeartRate.syncTag = @(SyncTagSynchronized);
                        }
                        if (index%100 == 0) {
                            [localContext MR_saveToPersistentStoreAndWait];
                            [SyncDataHelper saveHeartRateDataSyncTime:heartRateDataMsg.heartRateId];
                            DebugLog(@"------heartRateDataMsg----%ld----------", (long)index);
                        }
                        index++;
                    }
                    [localContext MR_saveToPersistentStoreAndWait];
                    [SyncDataHelper saveHeartRateDataSyncTime:[downloadHeartRateDataResponseMsg.heartRateDatasArray lastObject].heartRateId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(didSyncSuccessWithOpCode:)]) {
                            [weakSelf.delegate didSyncSuccessWithOpCode:OperationCodeDownloadHeartRateData];
                            
                        }
                        DebugLog(@"finish download heartRate: %ld", (long)downloadHeartRateDataResponseMsg.heartRateDatasArray.count);
                    });
                });
                
            }
            else {
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSyncFailureWithOpCode:ErrorMsg:)]) {
                    NSString *errorMsg = downloadHeartRateDataResponseMsg != nil ? downloadHeartRateDataResponseMsg.errorMsg.errorMsg : LOCALIZED_STRING(keySynchronousDataFailed);//@"下载心率血氧数据失败"
                    [self.delegate didSyncFailureWithOpCode:OperationCodeDownloadHeartRateData ErrorMsg:errorMsg];
                }
            }
        }
            break;
    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSyncFailureWithOpCode:ErrorMsg:)]) {
        [self.delegate didSyncFailureWithOpCode:OperationCodeDownloadSmokingLocationData ErrorMsg:errorMsg];
    }
    
}



@end
