//
//  LikeListViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LikeListViewController.h"
#import "Utility.h"
#import "MJRefresh.h"
#import "LikeListItemCell.h"

static NSString *const kCellIdentifier_LikeListItemCell     = @"LikeListItemCell";

static const NSInteger kFirst_PageNumber            = 1 ; //第一页的页码

@interface LikeListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (strong, nonatomic) NSMutableArray    *likeInfos;
@property (assign, nonatomic) NSInteger         lastDownloadedPageIndex;
@property (assign, nonatomic) NSInteger         currentPageIndex;
@property (weak, nonatomic) IBOutlet UILabel    *errorMsgLabel;

@end

@implementation LikeListViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:LOCALIZED_STRING(key_PeopleLiked), self.currentTweet.likeCount];
    self.likeInfos = [NSMutableArray new];
    [self setupMJRefresh];
//    [self getLikeListByByBlogId:self.currentTweet.tweetId PageIndex:kFirst_PageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - MJRefresh
//=====================================================================================
/**
 * 配置MJRefresh
 **/
- (void)setupMJRefresh {
    __weak typeof(self) weakSelf = self;
    self.layoutTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getLikeListByByBlogId:self.currentTweet.tweetId PageIndex:(self.lastDownloadedPageIndex+1)];
    }];
    [self.layoutTableView.mj_footer beginRefreshing];
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 从服务器获取点赞信息
 **/
- (void)getLikeListByByBlogId:(long long)blogId PageIndex:(NSInteger)pageIndex {
    if ([UserHelper isLogin]) {
        self.currentPageIndex = pageIndex;
        GetLikeListCommand *getLikeListCommand = [[GetLikeListCommand alloc] initGetLikeListCommandWithSession:[UserHelper currentUserSession] BlogId:blogId PageIndex:pageIndex];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:getLikeListCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
}


//=====================================================================================
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
//=====================================================================================
/**
 * 表格的section个数
 **/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/**
 * 单元格个数
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likeInfos.count;
}


/**
 * 生成单元格
 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LikeListItemCell *likeListItemCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LikeListItemCell forIndexPath:indexPath];
    LikeInfo *likeInfo = self.likeInfos[indexPath.row];
    [likeListItemCell setLikeInfo:likeInfo];
    return likeListItemCell;
}

/**
 * 获取单元格的高度
 **/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}


/**
 * 选中单元格
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"show tweet detail");
}


//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
/**
 * Socket调用正常返回
 **/
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    [super didCommandSuccessWithResult:result andOpCode:opCode];
    [Utility hideIndicatorHUD];
    NSError *error;
    if (opCode == OperationCodeGetLikeList) {
        GetLikeListResponseMessage *getLikeListResponseMsg = [GetLikeListResponseMessage parseFromData:result error:&error];
        DebugLog(@"getLikeListResponseMsg: %@", getLikeListResponseMsg);
        if (error == nil && getLikeListResponseMsg != nil && getLikeListResponseMsg.errorMsg.errorCode == 0) {
            self.lastDownloadedPageIndex = self.currentPageIndex;
            for (LikeMessage *likeMsg in getLikeListResponseMsg.likesArray) {
                LikeInfo *likeInfo      = [LikeInfo new];
                likeInfo.userId         = likeMsg.userId;
                likeInfo.author         = likeMsg.author;
                likeInfo.authorPhotoUrl = likeMsg.authorPhoto;
                likeInfo.createDt       = [NSDate dateWithTimeIntervalSince1970:(likeMsg.createDt/1000)];
                [self.likeInfos addObject:likeInfo];
            }
            [self.layoutTableView reloadData];
            if (getLikeListResponseMsg.isLastPage) {
                [self.layoutTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.layoutTableView.mj_footer endRefreshing];
            }
            if (self.likeInfos.count == 0) {
                self.errorMsgLabel.hidden = NO;
                self.errorMsgLabel.text = LOCALIZED_STRING(keyNoData);
            }
            else {
                self.errorMsgLabel.hidden = YES;
            }
        }
        else {
            [self.layoutTableView.mj_footer endRefreshing];
            [self showErrorMessage:(getLikeListResponseMsg!=nil?getLikeListResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLoadFailure))];//@"加载失败"
            if (error ==nil && getLikeListResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
            }
        }
    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    [self.layoutTableView.mj_footer endRefreshing];
    if (errorCode == ReturnErrorCodeNotNetwork && self.likeInfos.count == 0) {
        self.errorMsgLabel.hidden = NO;
        self.errorMsgLabel.text = LOCALIZED_STRING(keyNoNetworkPleaseCheckTheNetworkSettings);
    }
}






@end
