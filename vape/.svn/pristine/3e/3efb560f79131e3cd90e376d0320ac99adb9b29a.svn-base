//
//  SmokingLocationViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "SmokingLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "PMCalendar.h"

static NSString *const kAnnotationViewIdentifier = @"pinAnnotationView";

static const CLLocationDegrees kDefault_LatitudeDelta       = 0.02f;
static const CLLocationDegrees kDefault_LongitudeDelta      = 0.02f;

@interface SmokingLocationViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, PMCalendarControllerDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UIView *mapBackView;
@property (weak, nonatomic) IBOutlet UIView *positionView;

@property (strong, nonatomic) BMKMapView            *baiduMapView;
@property (strong, nonatomic) BMKLocationService    *baiduLocationService;
@property (strong, nonatomic) PMCalendarController  *calendarVC;

@property (strong, nonatomic) NSDate                *showedDate;

@end

@implementation SmokingLocationViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyToday);//@"今天";
    [self setupCalendarButtonInRightBarButtonItem];
    [self setupBaiduMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [self.baiduMapView viewWillAppear];
    self.baiduMapView.delegate = self;
    self.baiduLocationService.delegate = self;
    
    self.showedDate = [NSDate date];
    [self showAnnotationWithSmokingDayIndex:[IDGenerator generateDayIndexByDate:self.showedDate]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [self.baiduMapView viewWillDisappear];
    self.baiduMapView.delegate = nil;
    self.baiduLocationService.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 配置百度地图
 **/
- (void)setupBaiduMapView {
    self.baiduMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    [self.mapBackView addSubview:self.baiduMapView];
    
    self.baiduLocationService = [[BMKLocationService alloc] init];
    
    [self.baiduMapView setZoomLevel:11];
    
    
}

/**
 * 在NavigationBar右边添加日历按钮
 **/
- (void)setupCalendarButtonInRightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar22"] style:UIBarButtonItemStylePlain target:self action:@selector(onCalendarButton:)] animated:NO];
}

/**
 * 在地图上标点
 **/
- (void)showAnnotationWithSmokingDayIndex:(NSInteger)smokingDayIndex {
    [self.baiduMapView removeAnnotations:self.baiduMapView.annotations];
    
    NSArray *smokings = [SmokingDetailDataAccessor findSmokingDetailByDayIndex:smokingDayIndex];
    if (smokings.count > 0) {
        NSMutableArray *pointAnnotations = [NSMutableArray new];
        Smoking *firstSmoking = [smokings firstObject];
        CLLocationCoordinate2D firstCoordinate = [self ConvertBaiduCoorFromGPS:CLLocationCoordinate2DMake(firstSmoking.latitude, firstSmoking.longitude)];
        CLLocationDegrees minLatitude   = firstCoordinate.latitude;
        CLLocationDegrees maxLatitude   = firstCoordinate.latitude;
        CLLocationDegrees minLongitude  = firstCoordinate.longitude;
        CLLocationDegrees maxLongitude  = firstCoordinate.longitude;
        for (Smoking *smoking in smokings) {
            BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
            pointAnnotation.coordinate = [self ConvertBaiduCoorFromGPS:CLLocationCoordinate2DMake(smoking.latitude, smoking.longitude)];
            pointAnnotation.title = @"";
            pointAnnotation.subtitle = @"";
            [pointAnnotations addObject:pointAnnotation];
            
            if (smoking.latitude < minLatitude) {
                minLatitude = smoking.latitude;
            }
            if (smoking.latitude > maxLatitude) {
                maxLatitude = smoking.latitude;
            }
            
            if (smoking.longitude < minLongitude) {
                minLongitude = smoking.longitude;
            }
            if (smoking.longitude > maxLongitude) {
                maxLongitude = smoking.longitude;
            }
        }
        [self.baiduMapView addAnnotations:pointAnnotations];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLatitude+maxLatitude)/2.0, (minLongitude+maxLongitude)/2.0);
        CLLocationDegrees latitudeDelta = (maxLatitude - minLatitude)/2.0*1.4;
        CLLocationDegrees longitudeDelta = (maxLongitude - minLongitude)/2.0*1.4;
        latitudeDelta   = latitudeDelta < kDefault_LatitudeDelta ? kDefault_LatitudeDelta : latitudeDelta;
        longitudeDelta  = longitudeDelta < kDefault_LongitudeDelta ? kDefault_LongitudeDelta : longitudeDelta;
        BMKCoordinateSpan span = BMKCoordinateSpanMake(latitudeDelta, longitudeDelta);
        BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
        [self.baiduMapView setRegion:region animated:YES];
//        [self.baiduLocationService startUserLocationService];
    }
    else {
        [self showSuccessMessage:LOCALIZED_STRING(keyNoSmokingAddressData)];//@"无吸烟地址数据"
        [self.baiduLocationService startUserLocationService];
    }
    
}

/**
 * 将GPS坐标转换成百度坐标
 **/
- (CLLocationCoordinate2D)ConvertBaiduCoorFromGPS:(CLLocationCoordinate2D)coordinate {
    NSDictionary *baiduCoorDict = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoordinate = BMKCoorDictionaryDecode(baiduCoorDict);//转换后的百度坐标
    return baiduCoordinate;
}

//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    [super handleBLENotification:notification];
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    switch (message.notificationCode) {
        case BLENotificationCodeDiscoverPeripheral: {
            
        }
            break;
        case BLENotificationCodeSucceedToConnectPeripheral: {

        }
            break;
        case BLENotificationCodeInitPeripheralCompleted: {
            
        }
            break;
        case BLENotificationCodeReceiveNotifyForCharacteristic: {
            
        }
            break;
        case BLENotificationCodeDeviceUnSupported: {

        }
            break;
        case BLENotificationCodeNotAddDevice: {
           
        }
            break;
        case BLENotificationCodeDiscoverDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeConnectDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeInitDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeFailToPerformOperation: {
            
        }
            break;
        case BLENotificationCodeDisconnectPeripheral: {
            
        }
            break;
        case BLENotificationCodeReconnectDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeNotFoundDevice: {
            
        }
            break;
        case BLENotificationCodeFailToConnect: {
            
        }
            break;
    }
    
}


//=====================================================================================
#pragma mark - 日历
//=====================================================================================
- (void)onCalendarButton:(UIButton *)sender {
    if ([self.calendarVC isCalendarVisible]) {
        [self.calendarVC dismissCalendarAnimated:YES];
        return;
    }
    CGSize calendarSize = CGSizeMake(kScreen_Width, 300);
    switch (kiPhone_Version) {
        case kiPhone_5_5:
            calendarSize = CGSizeMake(kScreen_Width, 400);
            break;
        case kiPhone_4_7:
            calendarSize = CGSizeMake(kScreen_Width, 380);
            break;
    }
    self.calendarVC = [[PMCalendarController alloc] initWithThemeName:@"Smoking" andSize:calendarSize];
    self.calendarVC.allowsPeriodSelection = NO;
    self.calendarVC.delegate = self;
    [self.calendarVC presentCalendarFromView:self.positionView
               permittedArrowDirections:PMCalendarArrowDirectionDown
                              isPopover:YES
                               animated:YES];
    
    //注意，该调用必须在presentCalendarFromView后面，否则会出现控件中的日期显示不全的问题
    self.calendarVC.period = [PMPeriod oneDayPeriodWithDate:self.showedDate];
    //    [self calendarController:calendarVC didChangePeriod:calendarVC.period];
}

//=========================================================
#pragma mark - PMCalendarControllerDelegate
//=========================================================
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod {
    
    if (newPeriod.isUserSelected) {
        self.showedDate = newPeriod.startDate;
        NSInteger showedDayIndex = [IDGenerator generateDayIndexByDate:self.showedDate];
        if (showedDayIndex == [IDGenerator generateDayIndexByDate:[NSDate date]]) {
            self.navigationItem.title = LOCALIZED_STRING(keyToday);//@"今天"
        }
        else {
            self.navigationItem.title = [self.showedDate string_yyyy_MM_dd];
        }
        [self showAnnotationWithSmokingDayIndex:[IDGenerator generateDayIndexByDate:self.showedDate]];
//        if ([[newPeriod.startDate dateWithoutTime] isEqualToDate:[DATE_NOW dateWithoutTime]]) {
//            [self.layoutTableView.header beginRefreshing];
//        }
//        else if ([[newPeriod.startDate dateWithoutTime] isEqualToDate:[lastSelectedDate dateWithoutTime]]==NO) {
//            
//            [self refreshSelfViewWithSportDt:newPeriod.startDate PageIndex:6];
//            [self.layoutTableView.header endRefreshing];
//            
//        }
    }
    
}




//=====================================================================================
#pragma mark - BMKLocationServiceDelegate
//=====================================================================================
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.02, 0.02);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, span);
    [self.baiduMapView setRegion:region animated:YES];
    
    BMKLocationViewDisplayParam *param = [BMKLocationViewDisplayParam new];
    param.isAccuracyCircleShow = NO;
    param.isRotateAngleValid = YES;
    [self.baiduMapView updateLocationViewWithParam:param];
    self.baiduMapView.showsUserLocation = YES;//显示定位图层
    [self.baiduMapView updateLocationData:userLocation];
    
    [self.baiduLocationService stopUserLocationService];
    
    
//    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
//    pointAnnotation.coordinate = userLocation.location.coordinate;
//    pointAnnotation.title = @"ddd";
//    pointAnnotation.subtitle = @"";
//    [self.baiduMapView addAnnotation:pointAnnotation];
}

//=====================================================================================
#pragma mark - BMKMapViewDelegate
//=====================================================================================
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    BMKPinAnnotationView *pinAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationViewIdentifier];
    if (pinAnnotationView == nil) {
        pinAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationViewIdentifier];
    }
    pinAnnotationView.size = CGSizeMake(10, 10);
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.image = [UIImage imageNamed:@"smokingLocationx"];
    return pinAnnotationView;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    
}











@end
