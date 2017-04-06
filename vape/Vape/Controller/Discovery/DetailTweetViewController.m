//
//  DetailTweetViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DetailTweetViewController.h"
#import "TweetCell.h"
#import "MJRefresh.h"
#import "Tweet.h"
#import "MReplyTweetCell.h"
#import "LikeCell.h"
#import "SendTweetViewController.h"
#import "LikeListViewController.h"
#import "LikeInfo.h"


static NSString *const kCellIdentifier_OnePhoto     = @"OnePhotoCell";
static NSString *const kCellIdentifier_TwoPhotos    = @"TwoPhotosCell";
static NSString *const kCellIdentifier_ThreePhotos  = @"ThreePhotosCell";
static NSString *const kCellIdentifier_FourPhotos   = @"FourPhotosCell";
static NSString *const kCellIdentifier_FivePhotos   = @"FivePhotosCell";
static NSString *const kCellIdentifier_SixPhotos    = @"SixPhotosCell";
static NSString *const kCellIdentifier_SevenPhotos  = @"SevenPhotosCell";
static NSString *const kCellIdentifier_EightPhotos  = @"EightPhotosCell";
static NSString *const kCellIdentifier_NinePhotos   = @"NinePhotosCell";

static NSString *const kCellIdentifier_ReplyTweet   = @"ReplyTweet";

static NSString *const kCellIdentifier_LikeCell     = @"LikeCell";

static const NSInteger kInputView_Height             = 50;
static const NSInteger kFirst_PageNumber            = 1 ; //第一页的页码



@interface DetailTweetViewController ()<UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, MReplyTweetCellDelegate> {
    
    CGFloat             contentOffsetYOfTableView; //存储表格的当前contentOffset
}

@property (weak, nonatomic) IBOutlet UITableView        *layoutTableView;

//===========================回复输入视图===============================
@property (weak, nonatomic) IBOutlet UIView             *inputView;
@property (weak, nonatomic) IBOutlet UIView             *backViewOfReplyTweetTextView;
@property (weak, nonatomic) IBOutlet UITextView         *replyTweetTextView;
@property (weak, nonatomic) IBOutlet UILabel            *promptLabel;

@property (weak, nonatomic) IBOutlet UIView             *coverView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardViewHeightConstraint;
//====================================================================


//===========================回复输入视图===============================
- (IBAction)onShowInputViewButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine2HeightConstraint;
@property (weak, nonatomic) IBOutlet UIView             *backViewInBottomView;
//====================================================================

@property (strong, nonatomic) NSMutableArray    *comments;
@property (strong, nonatomic) Tweet             *currentReplyComment;
@property (assign, nonatomic) NSInteger         lastDownloadedPageIndex;
@property (assign, nonatomic) NSInteger         currentPageIndex;
@property (assign, nonatomic) long long         currentDeletedCommentId;

@property (strong, nonatomic) NSMutableArray    *likeInfos;

@end

@implementation DetailTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyComments);//@"详情";
    [self setupBorderLineConstraint];
    
    self.comments   = [NSMutableArray new];
    self.likeInfos  = [NSMutableArray new];
    
    [self.layoutTableView registerClass:[MReplyTweetCell class] forCellReuseIdentifier:kCellIdentifier_ReplyTweet];
    [self.layoutTableView registerClass:[LikeCell class] forCellReuseIdentifier:kCellIdentifier_LikeCell];
    
    [self addTapGestureInCoverView];
    [self setupMJRefresh];
    [self getLikeListByByBlogId:self.currentTweet.tweetId PageIndex:kFirst_PageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
        [weakSelf getCommentListByBlogId:self.currentTweet.tweetId PageIndex:(self.lastDownloadedPageIndex+1)];
    }];
//    [self.layoutTableView.mj_footer beginRefreshing];
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    self.topLineHeightConstraint.constant                   = kBorder_Line_Width;
    self.backViewOfReplyTweetTextView.layer.borderColor     = KBorder_Line_Default_Color.CGColor;
    self.backViewOfReplyTweetTextView.layer.borderWidth     = kBorder_Line_Width;
    self.backViewOfReplyTweetTextView.layer.cornerRadius    = (kInputView_Height-kMargin_WH*2) * 0.5;
    
    self.topLine2HeightConstraint.constant                  = kBorder_Line_Width;
    self.backViewInBottomView.layer.borderColor             = KBorder_Line_Default_Color.CGColor;
    self.backViewInBottomView.layer.borderWidth             = kBorder_Line_Width;
    self.backViewInBottomView.layer.cornerRadius            = (kInputView_Height-kMargin_WH*2) * 0.5;
}

/**
 * 添加单击手势
 **/
- (void)addTapGestureInCoverView {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.coverView addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

/**
 * 从服务器获取指定帖的回复列表
 **/
- (void)getCommentListByBlogId:(long long)blogId PageIndex:(NSInteger)pageIndex {
    if ([UserHelper isLogin]) {
//        [Utility showIndicatorHUD:@""];
        self.currentPageIndex = pageIndex;
        GetCommentListCommand *getCommentListCommand = [[GetCommentListCommand alloc] initGetCommentListCommandWithSession:[UserHelper currentUserSession] BlogId:blogId PageIndex:pageIndex];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:getCommentListCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
        [self.layoutTableView.mj_footer endRefreshing];
    }
}

/**
 * 从服务器获取点赞信息
 **/
- (void)getLikeListByByBlogId:(long long)blogId PageIndex:(NSInteger)pageIndex {
    if ([UserHelper isLogin]) {
        GetLikeListCommand *getLikeListCommand = [[GetLikeListCommand alloc] initGetLikeListCommandWithSession:[UserHelper currentUserSession] BlogId:blogId PageIndex:pageIndex];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:getLikeListCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
}

/**
 * 发送回复
 **/
- (void)sendComment {
    SendTweetViewController *sendTweetVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Discovery, @"SendTweetViewController");
    sendTweetVC.sendType = SendTypeComment;
    sendTweetVC.currentRepliedTweet = self.currentTweet;
    __weak typeof(self) weakSelf = self;
    sendTweetVC.didSendNewComment = ^(Tweet *newComment) {
        [weakSelf.comments insertObject:newComment atIndex:0];
        weakSelf.currentTweet.replyCount = self.comments.count;
        [weakSelf.layoutTableView reloadData];//刷新主题内容，因为回复变了需要刷新显示
        [weakSelf.layoutTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]
                                    atScrollPosition:UITableViewScrollPositionBottom
                                            animated:NO];
        if (self.didReply != nil) {
            self.didReply(self.currentTweet);
        }
    };
    BaseNavigationController *baseNavVC = [[BaseNavigationController alloc] initWithRootViewController:sendTweetVC];
    [self presentViewController:baseNavVC animated:YES completion:^{}];
}

//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
- (IBAction)onShowInputViewButton:(UIButton *)sender {
    [self sendComment];
}




//=====================================================================================
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
//=====================================================================================
/**
 * 表格的section个数
 **/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
/**
 * 单元格个数
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return self.likeInfos.count>0?1:0;
    }
    else {
        return self.comments.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 7.5f;
    }
    else {
        return 0.5f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

/**
 * 生成单元格
 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { //帖子的正文
        TweetCell *tweetCell;
     
        NSInteger photosCount = [self.currentTweet getPhotosCount];
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
        [tweetCell setCurrentTweet:self.currentTweet];
        [tweetCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return tweetCell;
    }
    else if (indexPath.section == 1) {
        LikeCell *likeCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LikeCell forIndexPath:indexPath];
        [likeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [likeCell setLikeInfos:self.likeInfos LikeCount:self.currentTweet.likeCount];
        return likeCell;
    }
    else { //帖子的回复
        Tweet *replyTweet = self.comments[indexPath.row];
        MReplyTweetCell *replyTweetCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReplyTweet forIndexPath:indexPath];
        [replyTweetCell setDelegate:self];
        [replyTweetCell setCurrentTweet:replyTweet];
        [replyTweetCell.topLine setHidden:YES];
        [replyTweetCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return replyTweetCell;
    }
}

/**
 * 获取单元格的高度
 **/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heightForCell = 0;
    if (indexPath.section == 0) {
        heightForCell = [TweetCell calculateContentViewHeightByReplyTweet:self.currentTweet] + 1;
    }
    else if (indexPath.section == 1) {
        heightForCell = [LikeCell calculateContentViewHeight];
    }
    else {
        Tweet *replyTweet = self.comments[indexPath.row];
        heightForCell = [MReplyTweetCell calculateContentViewHeightByReplyTweet:replyTweet] + 1;
    }
    
    return heightForCell;
}


/**
 * 选中单元格
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"show tweet detail");
    if (indexPath.section == 1 && self.currentTweet.likeCount > 0) {
        LikeListViewController *likeListVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Discovery, @"LikeListViewController");
        likeListVC.currentTweet = self.currentTweet;
        [self.navigationController pushViewController:likeListVC animated:YES];
    }
}

//=====================================================================================
#pragma mark - TweetCellDelegate
//=====================================================================================
- (void)tweetCell:(TweetCell *)tweetCell didDeleteTweet:(Tweet *)tweet {
    DebugLog(@"delete tweet");
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:LOCALIZED_STRING(keyAreYouSureYouWantToDeleteIt) message:@""];//@"您确定要删除吗?"
    [alertView bk_setCancelButtonWithTitle:LOCALIZED_STRING(keyCancel) handler:nil];
    [alertView bk_addButtonWithTitle:LOCALIZED_STRING(keyConfirm) handler:nil];
    [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
        if (index == 1) {
            if ([UserHelper isLogin]) {
                [Utility showIndicatorHUD:@""];
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
    [self sendComment];
}

- (void)tweetCell:(TweetCell *)tweetCell didLikeTweet:(Tweet *)tweet {
    if ([UserHelper isLogin]) {
        [Utility showIndicatorHUD:@""];
//        NewLikeCommand *newLikeCommand = [[NewLikeCommand alloc] initNewLikeCommandWithSession:[UserHelper currentUserSession] BlogId:tweet.tweetId IsLike:!tweet.isLike];
//        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:newLikeCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
}

//=====================================================================================
#pragma mark - ReplyTweetCellDelegate
//=====================================================================================
- (void)replyTweetCell:(MReplyTweetCell *)tweetCell didDeleteTweet:(Tweet *)tweet {
    DebugLog(@"delete replyTweet");
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:LOCALIZED_STRING(keyAreYouSureYouWantToDeleteIt) message:@""];//@"您确定要删除吗?"
    [alertView bk_setCancelButtonWithTitle:LOCALIZED_STRING(keyCancel) handler:nil];
    [alertView bk_addButtonWithTitle:LOCALIZED_STRING(keyConfirm) handler:nil];
    __weak typeof(self) weakSelf = self;
    [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
        if (index == 1) {
            if ([UserHelper isLogin]) {
                [Utility showIndicatorHUD:@""];
                weakSelf.currentDeletedCommentId = tweet.tweetId;
//                DeleteCommentCommand *deleteCommentCommand = [[DeleteCommentCommand alloc] initDeleteCommentCommandWithSession:[UserHelper currentUserSession] CommentId:tweet.tweetId];
//                [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:deleteCommentCommand];
            }
            else {
                [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
            }
        }
    }];
    [alertView show];
}



//=====================================================================================
#pragma mark - UITextViewDelegate
//=====================================================================================
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    contentOffsetYOfTableView = self.layoutTableView.contentOffset.y;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [self.promptLabel setHidden:YES];
    }
    else {
        [self.promptLabel setHidden:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    DebugLog(@"---text----%@", text);
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendComment];
        return NO;
    }
    
    if (self.inputView.frame.origin.y > kMargin_WH*4) { //让输入框不至于顶到导航栏
        NSString *content = [NSString stringWithFormat:@"%@%@", textView.text, text];
        CGFloat contentWeight = kScreen_Width - kMargin_WH*2 - kMargin_WH*2 - kMargin_WH - kMargin_WH;//UITextView的内边距是4
        CGFloat contentHeight = [self calculateContentHeightByContentString:content Width:contentWeight];
        CGFloat offset = contentHeight - (kInputView_Height-kMargin_WH-kMargin_WH);
        if (offset>0) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.15f animations:^{
                weakSelf.inputViewHeightConstraint.constant = kInputView_Height + offset;
                DebugLog(@"offset=%f", offset);
            }];
        }
    }
    
    return YES;
}

/**
 * 键盘的Frame改变通知
 **/
- (void)KeyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfo      = notification.userInfo;
    CGRect keyboardFrame        = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboradViewHeight  = kScreen_Height-keyboardFrame.origin.y;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        if (weakSelf.comments.count > 0) {
            [weakSelf.layoutTableView setContentOffset:CGPointMake(0, (contentOffsetYOfTableView+keyboradViewHeight)) animated:YES]; //随着键盘的隐藏/显示自动的滚动表格内容
        }
        weakSelf.keyboardViewHeightConstraint.constant = (keyboradViewHeight>0 ? keyboradViewHeight+kInputView_Height*10 : 0); //随着键盘的隐藏/显示来移动回复输入视图
        DebugLog(@"y=%f, height=%f", keyboardFrame.origin.y, keyboardFrame.size.height);
    }];
}

/**
 *
 **/
- (void)KeyboardWillShowNotification:(NSNotification *)notification {
    self.coverViewHeightConstraint.constant = kScreen_Height;
}

/**
 *
 **/
- (void)KeyboardWillHideNotification:(NSNotification *)notification {
    self.coverViewHeightConstraint.constant = 0;
}


/**
 * 根据给定的字符串来计算其所占有的矩形区域的高度
 **/
-(CGFloat)calculateContentHeightByContentString:(NSString*)contentString Width:(CGFloat)width {
    CGSize size = CGSizeMake(width - 24, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle,
                                 NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize returnSize = [contentString boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil].size;
    return CGSizeMake(returnSize.width, returnSize.height).height;
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
    if (opCode == OperationCodeGetCommentList) {
        GetCommentListResponseMessage *getCommentListResponseMsg = [GetCommentListResponseMessage parseFromData:result error:&error];
        DebugLog(@"getCommentListResponseMsg: %@", getCommentListResponseMsg);
        if (error == nil && getCommentListResponseMsg != nil && getCommentListResponseMsg.errorMsg.errorCode == 0) {
            self.lastDownloadedPageIndex = self.currentPageIndex;
            for (CommentMessage *commentMsg in getCommentListResponseMsg.commentsArray) {
                Tweet *tweet        = [Tweet new];
                tweet.tweetId       = commentMsg.commentId;
                tweet.userId        = commentMsg.userId;
                tweet.userName      = commentMsg.author;
                tweet.userIconUrl   = commentMsg.authorPhoto;
                tweet.createTime    = [NSDate dateWithTimeIntervalSince1970:commentMsg.createDt/1000];
                tweet.content       = commentMsg.content;
                
                [tweet setPhotoUrls:commentMsg.imagesArray];
                
                [self.comments addObject:tweet];
            }
            
            [self.layoutTableView reloadData];
            if (getCommentListResponseMsg.isLastPage) {
                [self.layoutTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.layoutTableView.mj_footer endRefreshing];
            }
            
        }
        else {
            [self.layoutTableView.mj_footer endRefreshing];
            [self showErrorMessage:(getCommentListResponseMsg!=nil?getCommentListResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLoadFailure))];//@"加载失败"
            if (error ==nil && getCommentListResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                __weak typeof(self) weakSelf = self;
                [UserHelper presentLoginViewControllerByIsSessionExpired:YES DidLogin:^{
                    [weakSelf.layoutTableView.mj_footer beginRefreshing];
                } DidCacenl:^{
                    
                }];
            }
            
        }
        
    }
//    else if (opCode == OperationCodeDeleteBlog) {
//        CommonResponseMessage *commonResponseMsg = [CommonResponseMessage parseFromData:result error:&error];
//        DebugLog(@"commonResponseMsg: %@", commonResponseMsg);
//        if (error == nil && commonResponseMsg != nil && commonResponseMsg.errorMsg.errorCode == 0) {
//            if (self.didDeleteBlog != nil) {
//                self.didDeleteBlog(self.currentTweet);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else {
//            [self showErrorMessage:(commonResponseMsg!=nil?commonResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyDeletePostFailed))];//@"删帖失败"
//            if (error ==nil && commonResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginOrRegisterViewControllerByIsSessionExpired:YES];
//            }
//        }
//        
//    }
//    else if (opCode == OperationCodeDeleteComment) {
//        CommonResponseMessage *commonResponseMsg = [CommonResponseMessage parseFromData:result error:&error];
//        DebugLog(@"commonResponseMsg: %@", commonResponseMsg);
//        if (error == nil && commonResponseMsg != nil && commonResponseMsg.errorMsg.errorCode == 0) {
//            NSInteger index = -1;
//            for (int i=0; i<self.comments.count; i++) {
//                if ([self.comments[i] tweetId] == self.currentDeletedCommentId) {
//                    index = i;
//                    break;
//                }
//            }
//            if (index >= 0) {
//                [self.comments removeObjectAtIndex:index];
//                [self.layoutTableView reloadData];
//            }
//            self.currentTweet.replyCount = self.comments.count;
//            if (self.didDeleteComment != nil) {
//                self.didDeleteComment(self.currentTweet);
//            }
//        }
//        else {
//            [self showErrorMessage:(commonResponseMsg!=nil?commonResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyDeleteCommentFailed))];//@"删除回复失败"
//            if (error ==nil && commonResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginOrRegisterViewControllerByIsSessionExpired:YES];
//            }
//        }
//        
//    }
//    else if (opCode == OperationCodeNewLike) {
//        NewLikeResponseMessage *newLikeResponseMsg = [NewLikeResponseMessage parseFromData:result error:&error];
//        DebugLog(@"newLikeResponseMsg: %@", newLikeResponseMsg);
//        if (error == nil && newLikeResponseMsg != nil && newLikeResponseMsg.errorMsg.errorCode == 0) {
//            self.currentTweet.isLike = newLikeResponseMsg.isLike;
//            self.currentTweet.likeCount = self.currentTweet.likeCount + (newLikeResponseMsg.isLike?1:-1);
//            
//            //==========================刷新点赞信息展示单元格的内容==============================
//            NSInteger index = -1;
//            for (NSInteger i = 0; i < self.likeInfos.count; i++) {
//                LikeInfo *likeInfo = self.likeInfos[i];
//                if (likeInfo.userId == [UserHelper currentUserId]) {
//                    index = i;
//                    break;
//                }
//            }
//            
//            if (newLikeResponseMsg.isLike) {
//                LikeInfo *newLikeInfo = [LikeInfo new];
//                newLikeInfo.userId = [UserHelper currentUserId];
//                newLikeInfo.author = [[UserHelper currentUser] userName];
//                newLikeInfo.authorPhotoUrl = [[UserHelper currentUser] userPhotoUrl];
//                newLikeInfo.createDt = [NSDate date];
//                [self.likeInfos insertObject:newLikeInfo atIndex:0];
//            }
//            else {
//                if (index > -1) {
//                    [self.likeInfos removeObjectAtIndex:index];
//                }
//            }
//            
//            [self.layoutTableView reloadData];
//            if (self.didLikeBlog != nil) {
//                self.didLikeBlog(self.currentTweet);
//            }
//        }
//        else {
//            [self showErrorMessage:(newLikeResponseMsg!=nil?newLikeResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLikeFailure))];//@"点赞失败"
//            if (error ==nil && newLikeResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
//            }
//        }
    
//    }
    else if (opCode == OperationCodeGetLikeList) {
        GetLikeListResponseMessage *getLikeListResponseMsg = [GetLikeListResponseMessage parseFromData:result error:&error];
        DebugLog(@"getLikeListResponseMsg: %@", getLikeListResponseMsg);
        if (error == nil && getLikeListResponseMsg != nil && getLikeListResponseMsg.errorMsg.errorCode == 0) {
            for (LikeMessage *likeMsg in getLikeListResponseMsg.likesArray) {
                LikeInfo *likeInfo      = [LikeInfo new];
                likeInfo.userId         = likeMsg.userId;
                likeInfo.author         = likeMsg.author;
                likeInfo.authorPhotoUrl = likeMsg.authorPhoto;
                likeInfo.createDt       = [NSDate dateWithTimeIntervalSince1970:(likeMsg.createDt/1000)];
                [self.likeInfos addObject:likeInfo];
            }
            [self.layoutTableView reloadData];
        }
        else {
            [self showErrorMessage:(getLikeListResponseMsg!=nil?getLikeListResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLoadFailure))];//@"加载失败"
            if (error ==nil && getLikeListResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
            }
        }
        [self getCommentListByBlogId:self.currentTweet.tweetId PageIndex:kFirst_PageNumber];
    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    [self.layoutTableView.mj_footer endRefreshing];
    if (opCode == OperationCodeGetLikeList) {
        [self getCommentListByBlogId:self.currentTweet.tweetId PageIndex:kFirst_PageNumber];
    }
    
}



@end
