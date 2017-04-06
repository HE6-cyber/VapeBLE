//
//  DiscoveryViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "MJRefresh.h"
#import "TweetCell.h"
#import "DetailTweetViewController.h"
#import "SendTweetViewController.h"

#define kTextContent_MaxHeight              ([UIFont systemFontOfSize:14].lineHeight*2)

static const NSInteger kFirst_PageNumber            = 1; //第一页的页码

static NSString *const kCellIdentifier_OnePhoto     = @"OnePhotoCell";
static NSString *const kCellIdentifier_TwoPhotos    = @"TwoPhotosCell";
static NSString *const kCellIdentifier_ThreePhotos  = @"ThreePhotosCell";
static NSString *const kCellIdentifier_FourPhotos   = @"FourPhotosCell";
static NSString *const kCellIdentifier_FivePhotos   = @"FivePhotosCell";
static NSString *const kCellIdentifier_SixPhotos    = @"SixPhotosCell";
static NSString *const kCellIdentifier_SevenPhotos  = @"SevenPhotosCell";
static NSString *const kCellIdentifier_EightPhotos  = @"EightPhotosCell";
static NSString *const kCellIdentifier_NinePhotos   = @"NinePhotosCell";

@interface DiscoveryViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (strong, nonatomic) NSMutableArray    *tweets;
@property (assign, nonatomic) NSInteger         lastDownloadedPageIndex;
@property (assign, nonatomic) NSInteger         currentPageIndex;

@property (assign, nonatomic) long long         currentDeletedTweetId;
@property (assign, nonatomic) long long         currentLikedTweetId;

@property (weak, nonatomic) IBOutlet UILabel    *errorMsgLabel;

@end

@implementation DiscoveryViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyDiscover);
    [self setupSendTweetButtonInRightBarButtonItem];
    
    self.tweets = [NSMutableArray new];
    self.currentPageIndex = kFirst_PageNumber;//页码从1开始
    
    [self setupMJRefresh];
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
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getBlogListByPageIndex:kFirst_PageNumber];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    self.layoutTableView.mj_header = header;
    [self.layoutTableView.mj_header beginRefreshing]; //马上进入刷新状态
    
    self.layoutTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getBlogListByPageIndex:(weakSelf.lastDownloadedPageIndex+1)];
    }];
}




//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 在NavigationBar左边添加发帖按钮
 **/
- (void)setupSendTweetButtonInRightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sendTweet"] style:UIBarButtonItemStylePlain target:self action:@selector(onSendTweetButton:)] animated:NO];
}

/**
 * 从服务器获取帖子列表
 **/
- (void)getBlogListByPageIndex:(NSInteger)pageIndex {
    if ([UserHelper isLogin]) {
//        [Utility showIndicatorHUD:@""];
        self.currentPageIndex = pageIndex;
        GetBlogListCommand *getBlogListCommand = [[GetBlogListCommand alloc] initGetBlogListCommandWithSession:[UserHelper currentUserSession] PageIndex:pageIndex];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:getBlogListCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
        [self.layoutTableView.mj_header endRefreshing];
        [self.layoutTableView.mj_footer endRefreshing];
    }
}

/**
 * 查看主题的详情与回复
 **/
- (void)showTweetDetailByIndexPath:(NSIndexPath *)indexPath {
    DetailTweetViewController *detailTweetVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Discovery, @"DetailTweetViewController");
    detailTweetVC.currentTweet = self.tweets[indexPath.section];
    __weak typeof(self) weakSelf = self;
    detailTweetVC.didReply = ^(Tweet *tweet) {
        Tweet *originalTweet        = weakSelf.tweets[indexPath.section];
        originalTweet.replyCount    = tweet.replyCount;
        [weakSelf.layoutTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        DebugLog(@"replycount");
    };
    detailTweetVC.didDeleteBlog = ^(Tweet *tweet) {
        [weakSelf.tweets removeObjectAtIndex:indexPath.section];
        [weakSelf.layoutTableView reloadData];
        DebugLog(@"deleteTweet");
    };
    detailTweetVC.didDeleteComment = ^(Tweet *tweet) {
        Tweet *originalTweet        = weakSelf.tweets[indexPath.section];
        originalTweet.replyCount    = tweet.replyCount;
        [weakSelf.layoutTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        DebugLog(@"replycount");
    };
    detailTweetVC.didLikeBlog = ^(Tweet *tweet) {
        Tweet *originalTweet    = weakSelf.tweets[indexPath.section];
        originalTweet.isLike    = tweet.isLike;
        originalTweet.likeCount = tweet.likeCount;
        [weakSelf.layoutTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        DebugLog(@"replycount");
    };
    [self.navigationController pushViewController:detailTweetVC animated:YES];
    DebugLog(@"show tweet detail");
}

//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
/**
 * 发帖
 **/
- (void)onSendTweetButton:(UIButton *)sender {
    SendTweetViewController *sendTweetVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Discovery, @"SendTweetViewController");
    sendTweetVC.sendType = SendTypeBlog;
    __weak typeof(self) weakSelf = self;
    sendTweetVC.didSendNewTweet = ^(Tweet *newTweet) {
        [weakSelf.tweets insertObject:newTweet atIndex:0];
        [weakSelf.layoutTableView reloadData];
        [weakSelf.layoutTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                        atScrollPosition:UITableViewScrollPositionBottom
                                                animated:NO];
    };
    BaseNavigationController *baseNavVC = [[BaseNavigationController alloc] initWithRootViewController:sendTweetVC];
    [self presentViewController:baseNavVC animated:YES completion:^{}];
}



//=====================================================================================
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tweets.count;
}

/**
 * 单元格个数
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.5f;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.tweets.count -1) {
        return 0.5f;
    }
    return 1;
}

/**
 * 生成单元格
 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *tweetCell;
    Tweet *tweet = self.tweets[indexPath.section];
    NSInteger photosCount = [tweet getPhotosCount];
    switch (photosCount) {
        case 0:
        case 1: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_OnePhoto];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_OnePhoto CellType:TweetCellTypeOnePhoto];
            }
        }
            break;
        case 2: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TwoPhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_TwoPhotos CellType:TweetCellTypeTwoPhotos];
            }
        }
            break;
        case 3: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ThreePhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_ThreePhotos CellType:TweetCellTypeThreePhotos];
            }
        }
            break;
        case 4: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FourPhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_FourPhotos CellType:TweetCellTypeFourPhotos];
            }
        }
            break;
        case 5: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FivePhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_FivePhotos CellType:TweetCellTypeFivePhotos];
            }
        }
            break;
        case 6: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SixPhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_SixPhotos CellType:TweetCellTypeSixPhotos];
            }
        }
            break;
        case 7: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SevenPhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_SevenPhotos CellType:TweetCellTypeSevenPhotos];
            }
        }
            break;
        case 8: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_EightPhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_EightPhotos CellType:TweetCellTypeEightPhotos];
            }
        }
            break;
        case 9: {
            tweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_NinePhotos];
            if (tweetCell == nil) {
                tweetCell = [[TweetCell alloc] initWithReuseIdentifier:kCellIdentifier_NinePhotos CellType:TweetCellTypeNinePhotos];
            }
        }
            break;
    }

    [tweetCell setDelegate:self];
    [tweetCell setIndexPath:indexPath];
    [tweetCell setCurrentTweet:tweet];
    [tweetCell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return tweetCell;
}

/**
 * 获取单元格的高度
 **/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat heightForCell = 0;
    Tweet *tweet = self.tweets[indexPath.section];
    heightForCell = [TweetCell calculateContentViewHeightByReplyTweet:tweet MaxHeightOfTextContent:kTextContent_MaxHeight] + 1;
    return heightForCell;
}


/**
 * 选中单元格
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showTweetDetailByIndexPath:indexPath];
}



//=====================================================================================
#pragma mark - TweetCellDelegate
//=====================================================================================
- (void)tweetCell:(TweetCell *)tweetCell didDeleteTweet:(Tweet *)tweet {
    DebugLog(@"delete tweet");
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:LOCALIZED_STRING(keyAreYouSureYouWantToDeleteIt) message:@""];
    [alertView bk_setCancelButtonWithTitle:LOCALIZED_STRING(keyCancel) handler:nil];//@"您确定要删除吗？"
    [alertView bk_addButtonWithTitle:LOCALIZED_STRING(keyConfirm) handler:nil];
    __weak typeof(self) weakSelf = self;
    [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
        if (index == 1) {
            if ([UserHelper isLogin]) {
                [Utility showIndicatorHUD:@""];
                weakSelf.currentDeletedTweetId = tweet.tweetId;
//                DeleteBlogCommand *deleteBlogCommand = [[DeleteBlogCommand alloc] initDeleteCommandWithSession:[UserHelper currentUserSession] BlogId:tweet.tweetId];
//                [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:deleteBlogCommand];
            }
            else {
                [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
            }
        }
    }];
    [alertView show];
}

- (void)tweetCell:(TweetCell *)tweetCell didReplyTweet:(Tweet *)tweet {
    [self showTweetDetailByIndexPath:tweetCell.indexPath];
}

- (void)tweetCell:(TweetCell *)tweetCell didLikeTweet:(Tweet *)tweet {
    if ([UserHelper isLogin]) {
        [Utility showIndicatorHUD:@""];
        self.currentLikedTweetId = tweet.tweetId;
//        NewLikeCommand *newLikeCommand = [[NewLikeCommand alloc] initNewLikeCommandWithSession:[UserHelper currentUserSession] BlogId:tweet.tweetId IsLike:!tweet.isLike];
//        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:newLikeCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
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
    if (opCode == OperationCodeGetBlogList) {
        GetBlogListResponseMessage *getBlogListResponseMsg = [GetBlogListResponseMessage parseFromData:result error:&error];
        DebugLog(@"getBlogListResponseMsg: %@", getBlogListResponseMsg);
        if (error == nil && getBlogListResponseMsg != nil && getBlogListResponseMsg.errorMsg.errorCode == 0) {
            self.lastDownloadedPageIndex = self.currentPageIndex;
            if (self.currentPageIndex == kFirst_PageNumber) {
                self.tweets = [NSMutableArray new];
            }
            for (BlogMessage *blogMsg in getBlogListResponseMsg.blogsArray) {
                Tweet *tweet = [Tweet new];
                tweet.tweetId       = blogMsg.blogId;
                tweet.userId        = blogMsg.userId;
                tweet.userName      = blogMsg.author;
                tweet.userIconUrl   = blogMsg.authorPhoto;
                tweet.createTime    = [NSDate dateWithTimeIntervalSince1970:blogMsg.createDt/1000];
                tweet.content       = blogMsg.content;
                tweet.replyCount    = blogMsg.commentCount;
                
                tweet.longitude     = blogMsg.longitude;
                tweet.latitude      = blogMsg.latitude;
                tweet.address       = blogMsg.address;
                
                tweet.isLike        = blogMsg.isLike;
                tweet.likeCount     = blogMsg.likeCount;
                
                [tweet setPhotoUrls:blogMsg.imagesArray];
                
                [self.tweets addObject:tweet];
            }
            [self.layoutTableView reloadData];
            
            [self.layoutTableView.mj_header endRefreshing];
            if (getBlogListResponseMsg.isLastPage) {
                [self.layoutTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.layoutTableView.mj_footer endRefreshing];
            }
            if (self.tweets.count == 0) {
                self.errorMsgLabel.hidden = NO;
                self.errorMsgLabel.text = LOCALIZED_STRING(keyNoData);
            }
            else {
                self.errorMsgLabel.hidden = YES;
            }
        }
        else {
            [self.layoutTableView.mj_header endRefreshing];
            [self.layoutTableView.mj_footer endRefreshing];
            [self showErrorMessage:(getBlogListResponseMsg!=nil?getBlogListResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLoadFailure))]; //@"加载失败"
            if (error ==nil && getBlogListResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                __weak typeof(self) weakSelf = self;
                [UserHelper presentLoginViewControllerByIsSessionExpired:YES DidLogin:^{
                    if (self.currentPageIndex == kFirst_PageNumber) {
                        [weakSelf.layoutTableView.mj_header beginRefreshing];
                    }
                    else {
                        [weakSelf.layoutTableView.mj_footer beginRefreshing];
                    }
                } DidCacenl:^{
                    
                }];
            }
        }

    }
//    else if (opCode == OperationCodeDeleteBlog) {
//        CommonResponseMessage *commonResponseMsg = [CommonResponseMessage parseFromData:result error:&error];
//        DebugLog(@"commonResponseMsg: %@", commonResponseMsg);
//        if (error == nil && commonResponseMsg != nil && commonResponseMsg.errorMsg.errorCode == 0) {
//            NSInteger index = -1;
//            for (int i=0; i<self.tweets.count; i++) {
//                if ([self.tweets[i] tweetId] == self.currentDeletedTweetId) {
//                    index = i;
//                    break;
//                }
//            }
//            if (index >= 0) {
//                [self.tweets removeObjectAtIndex:index];
//                [self.layoutTableView reloadData];
//            }
//            
//        }
//        else {
//            [self showErrorMessage:(commonResponseMsg!=nil?commonResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyDeletePostFailed))];//@"删帖失败"
//            if (error ==nil && commonResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
//            }
//        }
//
//    }
//    else if (opCode == OperationCodeNewLike) {
//        NewLikeResponseMessage *newLikeResponseMsg = [NewLikeResponseMessage parseFromData:result error:&error];
//        DebugLog(@"newLikeResponseMsg: %@", newLikeResponseMsg);
//        if (error == nil && newLikeResponseMsg != nil && newLikeResponseMsg.errorMsg.errorCode == 0) {
//            NSInteger index = -1;
//            for (int i=0; i<self.tweets.count; i++) {
//                if ([self.tweets[i] tweetId] == newLikeResponseMsg.blogId) {
//                    index = i;
//                    break;
//                }
//            }
//            if (index >= 0) {
//                Tweet *tweet = self.tweets[index];
//                tweet.isLike = newLikeResponseMsg.isLike;
//                tweet.likeCount = tweet.likeCount + (newLikeResponseMsg.isLike?1:-1);
//                [self.layoutTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationFade];
//            }
//            
//        }
//        else {
//            [self showErrorMessage:(newLikeResponseMsg!=nil?newLikeResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLikeFailure))];//@"点赞失败"
//            if (error ==nil && newLikeResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginOrRegisterViewControllerByIsSessionExpired:YES];
//            }
//        }
//        
//    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    [self.layoutTableView.mj_header endRefreshing];
    [self.layoutTableView.mj_footer endRefreshing];
    if (errorCode == ReturnErrorCodeNotNetwork && self.tweets.count == 0) {
        self.errorMsgLabel.hidden = NO;
        self.errorMsgLabel.text = LOCALIZED_STRING(keyNoNetworkPleaseCheckTheNetworkSettings);
    }
    
}




@end
