//
//  SendTweetViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "SendTweetViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "PhotoCell.h"
#import "Tweet.h"
#import <NYXImagesKit/NYXImagesKit.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

#define kPhotoCell_WH                   ((kScreen_Width-10-10)/3)

static NSString *const  kCellIdentifier_PhotoCell   = @"PhotoCell";

static const NSInteger  kMaximumNumber_Of_Photos        = 9; //照片最大可选张数
static const NSInteger  kColumnNumber_Of_Photos         = 4; //图片选择器中图片的列数
static const NSInteger  kReply_Min_Word_Count           = 1;
static const NSInteger  kReply_Max_Word_Count           = 500;
static const BOOL       kAllowPickingOriginalPhoto      = NO;

@interface SendTweetViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate> {

}


@property (weak, nonatomic) IBOutlet UITextView         *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel            *promptLabel;
@property (weak, nonatomic) IBOutlet UICollectionView   *photosCollectionView;
@property (weak, nonatomic) IBOutlet UIView             *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView             *userLocationBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLocationBackViewHeightConstraint;


@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
- (IBAction)onGetUserLocationButton:(UIButton *)sender;

@property (nonatomic, strong) UIImagePickerController   *imagePickerVc;

@property (nonatomic, strong) NSMutableArray            *selectedPhotos;
@property (nonatomic, strong) NSMutableArray            *selectedAssets;
@property (nonatomic, assign) BOOL                      isSelectOriginalPhoto;

@property (nonatomic, strong) Tweet                     *currentNewTweet;

@property (strong, nonatomic) BMKLocationService        *locationService;
@property (strong, nonatomic) BMKGeoCodeSearch          *geoCodeSearch;
@property (strong, nonatomic) BMKReverseGeoCodeResult   *userAddress;

@end

@implementation SendTweetViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self setupCancelButtonInLeftBarButtonItem];
    [self setupSendButtonInRightBarButtonItem];
    [self setupBorderLineConstraint];
    
    self.selectedPhotos = [NSMutableArray array];
    self.selectedAssets = [NSMutableArray array];
    [self configCollectionView];
    
    if (self.sendType == SendTypeBlog) {
        [self.userLocationBackView setHidden:NO];
        self.userLocationBackViewHeightConstraint.constant = 35;
        [self.promptLabel setText:LOCALIZED_STRING(keyEnterYouWantToSay)];
        self.geoCodeSearch      = [[BMKGeoCodeSearch alloc] init];
        self.locationService    = [[BMKLocationService alloc] init];
        [self startUserLocation];
    }
    else {
        [self.userLocationBackView setHidden:YES];
        self.userLocationBackViewHeightConstraint.constant = 0;
        [self.promptLabel setText:[NSString stringWithFormat:@"%@...", LOCALIZED_STRING(keyComment)]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    if (self.sendType == SendTypeBlog) {
        [self.locationService setDelegate:self];
        [self.geoCodeSearch setDelegate:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    if (self.sendType == SendTypeBlog) {
        [self.locationService setDelegate:nil];
        [self.geoCodeSearch setDelegate:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    self.topLineHeightConstraint.constant    = kBorder_Line_Width;
}

/**
 * 在NavigationBar右边添加取消按钮
 **/
- (void)setupCancelButtonInLeftBarButtonItem {
   [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:LOCALIZED_STRING(keyCancel) style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton:)]];
}

/**
 * 在NavigationBar右边添加发送按钮
 **/
- (void)setupSendButtonInRightBarButtonItem {
    NSString *buttonTitle = (self.sendType == SendTypeBlog ? LOCALIZED_STRING(keyPublish) : LOCALIZED_STRING(keyReply));
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStylePlain target:self action:@selector(onSendButton:)]];//@"发布"
}

- (void)configCollectionView {
    self.collectionViewHeightConstraint.constant = kPhotoCell_WH;
    self.photosCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

/**
 * 计算CollectionView的高度
 **/
- (CGFloat)getCollectionViewHeight {
    if (self.selectedPhotos.count>=kMaximumNumber_Of_Photos) { //最多3行
        return 3 *kPhotoCell_WH;
    }
    else {
        return (self.selectedPhotos.count/3 + 1) * kPhotoCell_WH;
    }
}

/**
 * 开始获取用户位置
 **/
- (void)startUserLocation {
    
    if([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        if( [CLLocationManager locationServicesEnabled] &&
           ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways ||
            [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)) {
               [self.locationService startUserLocationService];
           }
        else {
            [self showErrorMessage:LOCALIZED_STRING(keyPleaseOpenTheLocationServiceToAllowAPPToAccessYourLocationInformation)];//@"请打开”定位服务“来允许APP访问您的位置信息"
        }
    }
    else {
        if([CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied&&[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusRestricted) {
            [self.locationService startUserLocationService];
        }
        else {
            [self showErrorMessage:LOCALIZED_STRING(keyPleaseOpenTheLocationServiceToAllowAPPToAccessYourLocationInformation)];//@"请打开”定位服务“来允许APP访问您的位置信息"
        }
    }
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = [Utility getAppDelegate].userLocation.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag) {
        DebugLog(@"反geo检索发送成功");
    }
    else {
        DebugLog(@"反geo检索发送失败");
    }
}

//=====================================================================================
#pragma mark - UIButton事件处理方法
//=====================================================================================
/**
 * 取消
 **/
- (void)onCancelButton:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.selectedPhotos.count>0 || [self.tweetTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:LOCALIZED_STRING(keyDoYouWantToExitTheEditor) message:@""];
        [alertView bk_setCancelButtonWithTitle:LOCALIZED_STRING(keyCancel) handler:nil];//@"退出此次编辑?"
        [alertView bk_addButtonWithTitle:LOCALIZED_STRING(keyConfirm) handler:nil];
        __weak typeof(self) weakSelf = self;
        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
            if (index == 1) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{}];
            }
        }];
        [alertView show];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (NSData *)compressImage:(UIImage *)uploadImage {
    //========================压缩图片==========================
    CGSize maxSize = CGSizeMake(1242, 1242);
    if (uploadImage.size.width > maxSize.width || uploadImage.size.height > maxSize.height) {
        uploadImage = [uploadImage scaleToSize:maxSize usingMode:NYXResizeModeAspectFit];
    }
    NSData *editedImageData = [uploadImage dataForCodingUpload];
    //=========================================================
    return editedImageData;
}


/**
 * 发帖/回复
 *
 **/
- (void)onSendButton:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.sendType == SendTypeBlog) {
        [self sendTweet];
    }
    else {
        [self sendCommentForBlogId:self.currentRepliedTweet.tweetId];
    }
}

/**
 * 发布新主题
 * 要求：文本1-500字，图片数量必须大于1
 **/
- (void)sendTweet {
    if ([UserHelper isLogin]) {
        self.currentNewTweet = [Tweet new];
        self.currentNewTweet.content        = self.tweetTextView.text;
        self.currentNewTweet.userId         = [UserHelper currentUserId];
        self.currentNewTweet.userName       = [[UserHelper currentUser] userName];
        self.currentNewTweet.userIconUrl    = [[UserHelper currentUser] userPhotoUrl];
        self.currentNewTweet.createTime     = [NSDate date];
        if (self.userAddress != nil) {
            self.currentNewTweet.latitude   = self.userAddress.location.latitude;
            self.currentNewTweet.longitude  = self.userAddress.location.longitude;
            self.currentNewTweet.address    = self.userAddress.address;
        }
        NSMutableArray *uploadImageDatas = [NSMutableArray new];
        for (UIImage *image in self.selectedPhotos) {
            NSData *imageData = [self compressImage:image];//[image dataSmallerThan:500*1024];
            [uploadImageDatas addObject:imageData];
        }
        
        if (uploadImageDatas.count == 0) {
            [self showErrorMessage:LOCALIZED_STRING(keyPleaseUploadAtLeastOnePicture)];//@"请至少上传一张图片"
            return;
        }
        CValidator *validator = [CValidator new];
        [validator validateMinLength:kReply_Min_Word_Count MaxLength:kReply_Max_Word_Count
                                Text:[self.currentNewTweet.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                           FieldName:LOCALIZED_STRING(keyPost)];//@"帖子"
        if ([validator isValid]) {
            [Utility showIndicatorHUD:@""];
//            NewBlogCommand *newBlogCommand = [[NewBlogCommand alloc] initNewBlogCommandWithSession:[UserHelper currentUserSession] Tweet:self.currentNewTweet UploadImageDataArray:uploadImageDatas];
//            [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:newBlogCommand];
        }
        else {
            NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
            [self showErrorMessage:errorMsg];
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }

}

/**
 * 发送回复
 * 要求：文本1-500字
 **/
- (void)sendCommentForBlogId:(long long)blogId {
    
    if ([UserHelper isLogin]) {
        self.currentNewTweet = [Tweet new];
        self.currentNewTweet.userId         = [UserHelper currentUserId];
        self.currentNewTweet.userName       = [[UserHelper currentUser] userName];
        self.currentNewTweet.userIconUrl    = [[UserHelper currentUser] userPhotoUrl];
        self.currentNewTweet.content        = self.tweetTextView.text;
        self.currentNewTweet.createTime     = [NSDate date];

        NSMutableArray *uploadImageDatas = [NSMutableArray new];
        for (UIImage *image in self.selectedPhotos) {
            NSData *imageData = [self compressImage:image];
            [uploadImageDatas addObject:imageData];
        }
        
        CValidator *validator = [CValidator new];
        [validator validateMinLength:kReply_Min_Word_Count MaxLength:kReply_Max_Word_Count
                                Text:[self.currentNewTweet.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                           FieldName:LOCALIZED_STRING(keyComment)];//@"回复"
        if ([validator isValid]) {
            [Utility showIndicatorHUD:@""];
//            NewCommentCommand *newCommentCommand = [[NewCommentCommand alloc] initNewCommentCommandWithSession:[UserHelper currentUserSession] BlogId:blogId Content:self.currentNewTweet.content UploadImageDataArray:uploadImageDatas];
//            [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:newCommentCommand];
        }
        else {
            NSString *errorMsg = [[validator errorMsgs] componentsJoinedByString:@" "];
            [self showErrorMessage:errorMsg];
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }

}

/**
 * 获取用户位置
 **/
- (IBAction)onGetUserLocationButton:(UIButton *)sender {
    if (self.sendType == SendTypeBlog) {
        [self startUserLocation];
    }
}

//=====================================================================================
#pragma mark - UICollectionView
//=====================================================================================
/**
 * 单元格个数
 **/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count+1;
}

/**
 * 生成单元格
 **/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_PhotoCell forIndexPath:indexPath];
    if (indexPath.row == self.selectedPhotos.count) {
        photoCell.photoImgView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
    } else {
        photoCell.photoImgView.image = self.selectedPhotos[indexPath.row];
        photoCell.asset = self.selectedAssets[indexPath.row];
    }
    photoCell.row = indexPath.row;
    return photoCell;
}


/**
 * 选中单元格
 **/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedPhotos.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED_STRING(keyCancel) destructiveButtonTitle:nil otherButtonTitles:LOCALIZED_STRING(keyPhotograph),LOCALIZED_STRING(keyUploadFromAlbum), nil];//@"拍照",@"去相册选择"
        [sheet showInView:self.view];
    }
    else { //预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = kMaximumNumber_Of_Photos;
        imagePickerVc.allowPickingOriginalPhoto = kAllowPickingOriginalPhoto;
        imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            self.selectedAssets = [NSMutableArray arrayWithArray:assets];
            isSelectOriginalPhoto = isSelectOriginalPhoto;
            weakSelf.collectionViewHeightConstraint.constant = [self getCollectionViewHeight];
            [weakSelf.photosCollectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}

//==============================================================
#pragma mark UICollectionViewDelegateFlowLayout
//==============================================================
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kPhotoCell_WH, kPhotoCell_WH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}


//=====================================================================================
#pragma mark - UIImagePickerController
//=====================================================================================
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZED_STRING(keyUnableToUseCamera) message:LOCALIZED_STRING(keyPleaseAllowAccessToTheCameraInTheiPhoneSettingsPrivacyCamera) delegate:self cancelButtonTitle:LOCALIZED_STRING(keyCancel) otherButtonTitles:LOCALIZED_STRING(keySettings), nil];//@"无法使用相机" @"请在iPhone的""设置-隐私-相机""中允许访问相机"
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZED_STRING(keyUnableToAccessAlbum) message:LOCALIZED_STRING(keyPleaseAllowAccessToAlbumsIniPhoneSettingsPrivacyPhotos) delegate:self cancelButtonTitle:LOCALIZED_STRING(keyCancel) otherButtonTitles:LOCALIZED_STRING(keySettings), nil];//@"无法访问相册" @"请在iPhone的""设置-隐私-相册""中允许访问相册"
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];//
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            if (_imagePickerVc == nil) {
                _imagePickerVc = [[UIImagePickerController alloc] init];
                _imagePickerVc.delegate = self;
                //改变相册选择页的导航栏外观
                _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
                _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
                UIBarButtonItem *tzBarItem, *BarItem;
                if (iOS9Later) {
                    tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
                    BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
                } else {
                    tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
                    BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
                }
                NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
                [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
            }
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            DebugLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

/**
 * 使用相机拍照后会调用该方法
 **/
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaximumNumber_Of_Photos delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //保存图片，获取到asset
        __weak typeof(self) weakSelf = self;
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                DebugLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [weakSelf.selectedAssets addObject:assetModel.asset];
                        [weakSelf.selectedPhotos addObject:image];
                        weakSelf.collectionViewHeightConstraint.constant = [self getCollectionViewHeight];
                        [weakSelf.photosCollectionView reloadData];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//=====================================================================================
#pragma mark - UIActionSheetDelegate
//=====================================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

/**
 * TZImagePickerController
 **/
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaximumNumber_Of_Photos columnNumber:kColumnNumber_Of_Photos delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = self.selectedAssets; // 设置目前已经选中的图片数组
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    //在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = kNavigationBar_Bg_Color;
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = kNavigationBar_Bg_Color;
    
    //设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = kAllowPickingOriginalPhoto;
    
    imagePickerVc.sortAscendingByModificationDate = YES; //照片排列按修改时间升序
    
    //你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//=====================================================================================
#pragma mark - UIAlertViewDelegate
//=====================================================================================
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZED_STRING(keySorry) message:LOCALIZED_STRING(keyCanNotJumpToThePrivacySettingsPagePleaseGoToTheSettingsPageManually) delegate:nil cancelButtonTitle:LOCALIZED_STRING(keyConfirm) otherButtonTitles: nil];//@"抱歉" @"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" @"确定"
                [alert show];
            }
        }
    }
}

//=====================================================================================
#pragma mark - TZImagePickerControllerDelegate
//=====================================================================================
/**
 * 用户点击取消调用该方法
 **/
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
     DebugLog(@"tz_imagePickerControllerDidCancel");
}

/**
 * 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法; 如果isSelectOriginalPhoto为YES，表明用户选择了原图
 * 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
 * photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
 **/
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    self.isSelectOriginalPhoto = isSelectOriginalPhoto;
    self.collectionViewHeightConstraint.constant = [self getCollectionViewHeight];
    [self.photosCollectionView reloadData];

    // 1.打印图片名字
    [self printAssetsName:assets];
}



#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        DebugLog(@"图片名字:%@",fileName);
    }
}


//=====================================================================================
#pragma mark - UITextViewDelegate
//=====================================================================================
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
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
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (void)KeyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];

    CGFloat bottomViewHeight = self.bottomView.frame.size.height;
    CGFloat keyboradViewHeight = (bottomViewHeight>=keyboardFrame.size.height ?
                                  0 :
                                  (kScreen_Height-keyboardFrame.origin.y-bottomViewHeight));
    keyboradViewHeight = (keyboradViewHeight>0 ? keyboradViewHeight : 0);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.keyboardViewHeightConstraint.constant = keyboradViewHeight;
        DebugLog(@"y=%f, height=%f", keyboardFrame.origin.y, keyboardFrame.size.height);
    }];
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
//    if (opCode == OperationCodeNewBlog) {
//        NewBlogResponseMessage *newBlogResponseMsg = [NewBlogResponseMessage parseFromData:result error:&error];
//        DebugLog(@"newBlogResponseMsg: %@", newBlogResponseMsg);
//        if (error == nil && newBlogResponseMsg != nil && newBlogResponseMsg.errorMsg.errorCode == 0) {
//            self.currentNewTweet.tweetId    = newBlogResponseMsg.blogId;
//            self.currentNewTweet.userId     = newBlogResponseMsg.userId;
//            [self.currentNewTweet setPhotoUrls:newBlogResponseMsg.imagesArray];
//            
//            self.didSendNewTweet(self.currentNewTweet);
//            [self dismissViewControllerAnimated:YES completion:^{}];
//            
//        }
//        else {
//            [self showErrorMessage:(newBlogResponseMsg!=nil?newBlogResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyPostFailure))];//@"发帖失败"
//            if (error ==nil && newBlogResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginOrRegisterViewControllerByIsSessionExpired:YES];
//            }
//        }
//        
//    }
//    else if (opCode == OperationCodeNewComment) {
//        NewCommentResponseMessage *newCommentResponseMsg = [NewCommentResponseMessage parseFromData:result error:&error];
//        DebugLog(@"commonResponseMsg: %@", newCommentResponseMsg);
//        if (error == nil && newCommentResponseMsg != nil && newCommentResponseMsg.errorMsg.errorCode == 0) {
//            self.currentNewTweet.tweetId    = newCommentResponseMsg.commentId;
//            self.currentNewTweet.userId     = newCommentResponseMsg.userId;
//            [self.currentNewTweet setPhotoUrls:newCommentResponseMsg.imagesArray];
//            
//            self.didSendNewComment(self.currentNewTweet);
//           [self dismissViewControllerAnimated:YES completion:^{}];
//        }
//        else {
//            [self showErrorMessage:(newCommentResponseMsg!=nil?newCommentResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keyLoadFailure))];//@"加载失败"
//            if (error ==nil && newCommentResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
//                [UserHelper presentLoginOrRegisterViewControllerByIsSessionExpired:YES];
//            }
//        }
//    }
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
}


//=====================================================================================
#pragma mark - BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate
//=====================================================================================
/**
 * 获取用户位置成功
 **/
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.locationService stopUserLocationService];
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

/**
 * 获取用户位置失败
 **/
-(void)didFailToLocateUserWithError:(NSError *)error {
    [self showErrorMessage:LOCALIZED_STRING(keyFailedToObtainUserLocation)];//@"获取用户位置失败"
    [self.locationService stopUserLocationService];
}



/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    [Utility hideIndicatorHUD];
    if (error==BMK_SEARCH_NO_ERROR) {
        if (result.address != nil && ![result.address isEqualToString:@""]) {
            self.userAddress = result;
            [self.userAddressLabel setText:self.userAddress.address];
        }
        else {
            [self showErrorMessage:LOCALIZED_STRING(keyFailedToObtainUserLocation)];//@"获取用户位置失败"
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyFailedToObtainUserLocation)];//@"获取用户位置失败"
    }
}



@end
