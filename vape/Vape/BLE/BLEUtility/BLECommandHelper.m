//
//  BLECommandHelper.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BLECommandHelper.h"
#import "Utility.h"

//=========================Services与Characteristics的UUID======================================
//设备的Servie UUID
NSString *const kBLE_Service_UUID                                           = @"0783b03e-8535-b5a0-7140-a304d2495cb0";
//设置上传特征的UUID
NSString *const kBLE_Notify_Characteristic_UUID                             = @"0783b03e-8535-b5a0-7140-a304d2495cb1";
//APP下发特征的UUID
NSString *const kBLE_WriteWithoutResponse_Characteristic_UUID               = @"0783b03e-8535-b5a0-7140-a304d2495cb2";
//=============================================================================================


//=========================================公用常量=============================================
const NSInteger kDiscoveryDevice_TimeOut            = 60;
const NSInteger kConnectDevice_TimeOut              = 10;
const NSInteger kInitDevice_TimeOut                 = 15;
const NSInteger kPerformOperation_HeartRate_TimeOut = 20;
const NSInteger kPerformOperation_Other_TimeOut     = 5;
//=============================================================================================


static BLECommandHelper *shareBLECommandHelper = nil;

@interface BLECommandHelper () {

}

@property (strong, nonatomic)   BabyBluetooth       *baby;

@property (strong, nonatomic)   CBPeripheral        *currentPeripheral;
@property (strong, nonatomic)   CBCharacteristic    *writeWithoutResponseCharacteristic;
@property (strong, nonatomic)   CBCharacteristic    *notifyCharacteristic;

//=========================================超时定时器=============================================
@property (strong, nonatomic)   NSTimer             *timerForDiscoveryDeviceTimeout; //发现设备超时定时器
@property (strong, nonatomic)   NSTimer             *timerForConnectDeviceTimeOut;  //连接超时定时器
@property (strong, nonatomic)   NSTimer             *timerForInitDeviceTimeOut;     //初始化超时定时器
@property (strong, nonatomic)   NSTimer             *timerForFailToPerformOperation;    //执行操作超时定时器
//=============================================================================================


@property (strong, nonatomic)   BLEOperationCommand *currentSendOperationCommand;
@property (strong, nonatomic)   BLEOperationCommand *autoSendOperationCommand;

@property (assign, nonatomic)   BLEConnectStatus    currentStatus;

@end


@implementation BLECommandHelper

//=====================================================================================
#pragma mark - 获取对象的实例
//=====================================================================================
/**
 * 获取类的公用实例对象
 **/
+ (BLECommandHelper *)shareBLECommandHelper {
    static dispatch_once_t predicate;
    if (shareBLECommandHelper == nil) {
        dispatch_once(&predicate, ^{
            shareBLECommandHelper = [[BLECommandHelper alloc] init];
        });
    }
    return shareBLECommandHelper;
}

- (instancetype)init {
    if (self=[super init]) {
        self.baby = [BabyBluetooth shareBabyBluetooth];
        [self babyDelegate];
    }
    return self;
}

- (void)dealloc {
 
}

//=====================================================================================
#pragma mark - 扫描/停止扫描设备
//=====================================================================================
/**
 * 扫描蓝牙设备
 **/
- (void)scan {
    if ([self.baby centralManager].state != CBCentralManagerStatePoweredOn) {
        BLEMessage *message = [BLEMessage new];
        message.notificationCode = BLENotificationCodeDeviceUnSupported;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
    }
    self.baby.scanForPeripherals().begin();
    [self startTimerForDiscoveryDeviceTimeout:kDiscoveryDevice_TimeOut];
}

/**
 * 停止扫描蓝牙设备
 **/
- (void)stopScan {
    [self.baby cancelScan];
    [self abortTimerForDiscoveryDeviceTimeout];
}

//=====================================================================================
#pragma mark - 连接设备
//=====================================================================================
/**
 * 连接设备
 **/
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    ///设备不支持或蓝牙已经关闭
    if ([self.baby centralManager].state != CBCentralManagerStatePoweredOn) {
        BLEMessage *message = [BLEMessage new];
        message.notificationCode = BLENotificationCodeDeviceUnSupported;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
        return;
    }
    self.currentPeripheral = peripheral;
    ///连成功，取消连接
    if (self.currentPeripheral.state == CBPeripheralStateConnected){
        return;
    }
    self.baby.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin();
    [self startTimerForConnectDeviceTimeout:kConnectDevice_TimeOut NotificationCode:BLENotificationCodeConnectDeviceTimeOut];
    [self startTimerForInitDeviceTimeOut:kInitDevice_TimeOut];
    
}

/**
 * 重连以前连接过的设备（即设备的UUID已知的设备）
 **/
- (void)connectToPeripheralWithUUIDString:(NSString *)UUIDString {
    ///设备不支持或蓝牙已经关闭
    if ([self.baby centralManager].state != CBCentralManagerStatePoweredOn) {
        BLEMessage *message = [BLEMessage new];
        message.notificationCode = BLENotificationCodeDeviceUnSupported;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
        return;
    }
    ///通过设备的UUID没有找到蓝牙设备
    CBPeripheral *peripheral = [self.baby retrievePeripheralWithUUIDString:UUIDString];
    if (peripheral == nil) {
        BLEMessage *message = [BLEMessage new];
        message.notificationCode    = BLENotificationCodeNotFoundDevice;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
        return;
    }
    self.currentPeripheral = peripheral;
    ///连成功，取消连接
    if (self.currentPeripheral.state == CBPeripheralStateConnected){
        return;
    }
    DebugLog(@"connect device with UUID : %@.", UUIDString);
    self.baby.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin();
    [self startTimerForConnectDeviceTimeout:kConnectDevice_TimeOut NotificationCode:BLENotificationCodeReconnectDeviceTimeOut];
    [self startTimerForInitDeviceTimeOut:kInitDevice_TimeOut];
    
}

/**
 * 断开当前连接
 **/
- (void)cancelCurrentPeripheral {
    if (self.currentPeripheral != nil) {
        [self.baby AutoReconnectCancel:self.currentPeripheral];
        [self.baby cancelPeripheralConnection:self.currentPeripheral];
        self.currentPeripheral = nil;
    }
}

//=====================================================================================
#pragma mark - 其他方法
//=====================================================================================
/**
 * 获取已配对的蓝牙设备列表
 **/
- (NSArray *)retrieveConnectedPeripherals {
    return [[self.baby centralManager] retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:kBLE_Service_UUID]]];
}


///连接状态
- (BLEConnectStatus)connectStatus{
    return self.currentStatus;
}

/**
 * 返回当前连接的蓝牙设备的UUID
 **/
- (NSString *)currentPeripheralUUIDString {
    if (self.currentPeripheral != nil) {
        return self.currentPeripheral.identifier.UUIDString;
    }
    else {
        return nil;
    }
}


//=====================================================================================
#pragma mark - 发送指令
//=====================================================================================
///发送操作指令
- (void)sendOperationCommandWithoutResponse:(BLEOperationCommand *)command {
    ///设备不支持或蓝牙已经关闭
    if ([self.baby centralManager].state != CBCentralManagerStatePoweredOn) {
        BLEMessage *message = [BLEMessage new];
        message.notificationCode = BLENotificationCodeDeviceUnSupported;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
        return;
    }
    ///未添加设备
    if (![UserHelper isBoundDevice]) {
        BLEMessage *message = [BLEMessage new];
        message.notificationCode = BLENotificationCodeNotAddDevice;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
        return;
    }
    ///设备已经初始化完成，可以执行操作
    if (self.currentStatus == BLEConnectStatusDeviceInitCompleted) {
        self.currentSendOperationCommand = command;
        [self.currentPeripheral writeValue:[command getCommandData]
                         forCharacteristic:self.writeWithoutResponseCharacteristic
                                      type:CBCharacteristicWriteWithoutResponse];
//        NSTimeInterval timeInterval = ([command getOperationCode]==BLEOperationCodeDetectHeartRateAndBloodOxygen?
//                                       kPerformOperation_HeartRate_TimeOut:
//                                       kPerformOperation_Other_TimeOut);
//        [self startTimerForFailToPerformOperation:command Interval:timeInterval];
        DebugLog(@"%@", [command getCommandData]);
    }
    else {
        self.autoSendOperationCommand = command;
        [self connectToPeripheralWithUUIDString:[UserHelper currentDeviceUUID]];
    }
}





//=====================================================================================
#pragma mark - 配置BabyBluetooth
//=====================================================================================
- (void)babyDelegate {
    
    __weak typeof(self) weakSelf = self;
    
    //============================================================================================
    //设置蓝牙运行时的参数 |  set ble runtime parameters
    //============================================================================================
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    NSDictionary *connectOptions                = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                                    CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                                    CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
//    NSArray *scanForPeripheralsWithServices     = @[[CBUUID UUIDWithString:kBLE_Service_UUID]];  //加了就扫描不到设备
    NSArray *discoverWithServices               = @[[CBUUID UUIDWithString:kBLE_Service_UUID]];
    NSArray *discoverWithCharacteristics        = @[[CBUUID UUIDWithString:kBLE_WriteWithoutResponse_Characteristic_UUID],
                                                    [CBUUID UUIDWithString:kBLE_Notify_Characteristic_UUID]];
    [self.baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                                  connectPeripheralWithOptions:connectOptions
                                scanForPeripheralsWithServices:nil
                                          discoverWithServices:discoverWithServices
                                   discoverWithCharacteristics:discoverWithCharacteristics];
    
    
    //============================================================================================
    //设备状态改变的block |  when CentralManager state changed
    //============================================================================================
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        DebugLog(@"center.state: %ld", (long)central.state);
        if (central.state == CBCentralManagerStatePoweredOn) {
            weakSelf.currentStatus = BLEConnectStatusDevicePoweredOn;
            if ([UserHelper isBoundDevice]) {
                [weakSelf connectToPeripheralWithUUIDString:[UserHelper currentDeviceUUID]];
            }
            BLEMessage *message = [BLEMessage new];
            message.notificationCode    = BLENotificationCodeDevicePowerOn;
            [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                                object:nil
                                                              userInfo:@{kUserInfo_Key_Message: message}];
        }
        else {
            weakSelf.currentStatus = BLEConnectStatusDeviceUnSupport;
            BLEMessage *message = [BLEMessage new];
            message.notificationCode    = BLENotificationCodeDeviceUnSupported;
            [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                                object:nil
                                                              userInfo:@{kUserInfo_Key_Message: message}];
        }
    }];
    
    
    //============================================================================================
    //找到Peripherals的block |  when find peripheral
    //============================================================================================
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        weakSelf.currentStatus = BLEConnectStatusDiscoveredDevice;
        [weakSelf abortTimerForDiscoveryDeviceTimeout];
        BLEMessage *message = [BLEMessage new];
        message.notificationCode        = BLENotificationCodeDiscoverPeripheral;
        message.discoveredPeripheral    = [[DiscoveredPeripheral alloc] initWithPeripheral:peripheral AdvertisementData:advertisementData RSSI:RSSI PeripheralName:peripheral.name IsConnected:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
    }];
    
    
    //============================================================================================
    //连接Peripherals成功的block|  when connected peripheral
    //============================================================================================
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        weakSelf.currentStatus = BLEConnectStatusConnected;
        if ([peripheral.identifier.UUIDString isEqualToString:weakSelf.currentPeripheral.identifier.UUIDString]) {
            [weakSelf abortTimerForConnectDeviceTimeOut];
        }
        [weakSelf.baby AutoReconnect:peripheral];
        BLEMessage *message = [BLEMessage new];
        message.notificationCode    = BLENotificationCodeSucceedToConnectPeripheral;
        message.peripheral          = peripheral;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
    }];
    
    
    //============================================================================================
    //连接Peripherals失败的block |  when fail to connect peripheral
    //============================================================================================
    [self.baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.currentStatus = BLEConnectStatusConnectDeviceFailure;
        BLEMessage *message = [BLEMessage new];
        message.notificationCode    = BLENotificationCodeFailToConnect;
        message.peripheral          = peripheral;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
    }];
    
    
    //============================================================================================
    //断开Peripherals的连接的block|  when disconnected peripheral
    //============================================================================================
    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.currentStatus = BLEConnectStatusDisConnected;
        /* 断开连接后，将初始化设备超时、执行命令超时定时器中止 */
        [weakSelf abortTimerForInitDeviceTimeOut];
        [weakSelf abortTimerForFailToPerformOperation];
        BLEMessage *message = [BLEMessage new];
        message.notificationCode    = BLENotificationCodeDisconnectPeripheral;
        message.peripheral          = peripheral;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                            object:nil
                                                          userInfo:@{kUserInfo_Key_Message: message}];
    }];
    
    
    //============================================================================================
    //设置查找服务的block |  when discover services of peripheral
    //============================================================================================
    [self.baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        DebugLog(@"Services: %@", peripheral.services);
    }];
    
    
    //============================================================================================
    //设置查找到Characteristics的block |  when discovered Characteristics
    //============================================================================================
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        BOOL isExistedForWriteWithoutResponseCharacteristic = NO;
        BOOL isExistedForNotifyCharacteristic = NO;
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBLE_WriteWithoutResponse_Characteristic_UUID]]) {
                weakSelf.writeWithoutResponseCharacteristic = characteristic;
                isExistedForWriteWithoutResponseCharacteristic = YES;
            }
            else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBLE_Notify_Characteristic_UUID]]) {
                weakSelf.notifyCharacteristic = characteristic;
                isExistedForNotifyCharacteristic = YES;
                if (characteristic.isNotifying == NO) {
                    [weakSelf.currentPeripheral setNotifyValue:YES forCharacteristic:weakSelf.notifyCharacteristic];
                }
            }
            
        }
        if (isExistedForWriteWithoutResponseCharacteristic && isExistedForNotifyCharacteristic) {
            weakSelf.currentStatus = BLEConnectStatusDeviceInitCompleted;
            [weakSelf abortTimerForInitDeviceTimeOut];
            BLEMessage *message = [BLEMessage new];
            message.notificationCode    = BLENotificationCodeInitPeripheralCompleted;
            message.peripheral          = peripheral;
            [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                                object:nil
                                                              userInfo:@{kUserInfo_Key_Message: message}];
            
//            BLEBindDeviceCommand *bindDeviceCommand = [[BLEBindDeviceCommand alloc] initWithBindDeviceCommand]; //初始化完成后发送设备绑定命令
//             [weakSelf.currentPeripheral writeValue:[bindDeviceCommand getCommandData]
//                              forCharacteristic:weakSelf.writeWithoutResponseCharacteristic
//                                               type:CBCharacteristicWriteWithoutResponse];
            
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                if (weakSelf.autoSendOperationCommand != nil) {
                    [weakSelf sendOperationCommandWithoutResponse:weakSelf.autoSendOperationCommand];
                    weakSelf.autoSendOperationCommand = nil;
                }
            });
        }
        
    }];
    
    
    //============================================================================================
    //设置获取到最新Characteristics值的block|  when read new characteristics value  or notiy a characteristics value
    //============================================================================================
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBLE_Notify_Characteristic_UUID]]) {
            DebugLog(@"characteristic.value: %@", characteristic.value);
            //处理收到的消息数据
            [weakSelf HandleReceiveValueForNotifyCharacteristic:characteristic.value];
            //对通知消息进行确认
//            NSData *commandData = [NSData dataWithBytes:&kConfirm_Packet_Content length:1];
//            [weakSelf.currentPeripheral writeValue:commandData
//                                 forCharacteristic:weakSelf.writeWithoutResponseCharacteristic
//                                              type:CBCharacteristicWriteWithoutResponse];
//            DebugLog(@"sendCommand: %@", commandData);
        }
    }];
    
    
    //============================================================================================
    //写Characteristic成功后的block |  when did write value for characteristic successed
    //============================================================================================
    [self.baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
    
    //============================================================================================
    //读取RSSI的委托 |  when did read RSSI
    //============================================================================================
    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        
    }];
    
    
    //============================================================================================
    //babyBluettooth cancelScan方法调用后的回调 |  when after call cancelScan
    //============================================================================================
    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        
    }];
    
    
    //============================================================================================
    //babyBluettooth cancelAllPeripheralsConnectionBlock 方法执行后并且全部设备断开后的回调|  when did all peripheral disConnect
    //============================================================================================
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        
    }];
    
}

//=====================================================================================
#pragma mark -  处理从特征接收到的数据
//=====================================================================================
/**
 * 处理从kBLE_Notify_Characteristic_UUID特征收到的消息
 **/
- (void)HandleReceiveValueForNotifyCharacteristic:(NSData *)value {
    
}



//=====================================================================================
#pragma mark - 定时器
//=====================================================================================
//==================================================
// 扫描设备超时定时器
//==================================================
/**
 * 启动发现设备超时定时器
 **/
- (void)startTimerForDiscoveryDeviceTimeout:(NSTimeInterval)interval {
    [self abortTimerForDiscoveryDeviceTimeout];
    self.timerForDiscoveryDeviceTimeout = [NSTimer timerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(handleDiscoveryDeviceTimeout:)
                                                           userInfo:nil
                                                            repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timerForDiscoveryDeviceTimeout forMode:NSRunLoopCommonModes];
}

/**
 * 中止发现设备超时定时器
 **/
- (void)abortTimerForDiscoveryDeviceTimeout {
    if (self.timerForDiscoveryDeviceTimeout != nil) {
        if ([self.timerForDiscoveryDeviceTimeout isValid]) {
            [self.timerForDiscoveryDeviceTimeout invalidate];
        }
        self.timerForDiscoveryDeviceTimeout = nil;
    }
}

/**
 * 处理发现设备超时
 **/
- (void)handleDiscoveryDeviceTimeout:(NSTimer *)timer {
    BLEMessage *message = [BLEMessage new];
    message.notificationCode    = BLENotificationCodeDiscoverDeviceTimeOut;
    [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                        object:nil
                                                      userInfo:@{kUserInfo_Key_Message: message}];
    [self abortTimerForDiscoveryDeviceTimeout];
    
}


//===================================================
// 设备连接超时定时器
//===================================================
/**
 * 启动设备连接超时定时器
 **/
- (void)startTimerForConnectDeviceTimeout:(NSTimeInterval)interval NotificationCode:(BLENotificationCode)notificationCode {
    [self abortTimerForConnectDeviceTimeOut];
    self.timerForConnectDeviceTimeOut = [NSTimer timerWithTimeInterval:interval
                                                                target:self
                                                              selector:@selector(handleConnectDeviceTimeOut:)
                                                              userInfo:@(notificationCode)
                                                               repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timerForConnectDeviceTimeOut forMode:NSRunLoopCommonModes];
}

/**
 * 中止设备连接超时定时器
 **/
- (void)abortTimerForConnectDeviceTimeOut {
    if (self.timerForConnectDeviceTimeOut != nil) {
        if ([self.timerForConnectDeviceTimeOut isValid]) {
            [self.timerForConnectDeviceTimeOut invalidate];
        }
        self.timerForConnectDeviceTimeOut = nil;
    }
}

/**
 * 处理设备连接超时
 **/
- (void)handleConnectDeviceTimeOut:(NSTimer *)timer {
    BLEMessage *message = [BLEMessage new];
    message.notificationCode    = (BLENotificationCode)[timer.userInfo integerValue];
    message.peripheral          = self.currentPeripheral;
    [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                        object:nil
                                                      userInfo:@{kUserInfo_Key_Message: message}];
    [self abortTimerForConnectDeviceTimeOut];
}

//===================================================
// 设备初始化超时定时器
//===================================================
/**
 * 启动设备初始化超时定时器
 **/
- (void)startTimerForInitDeviceTimeOut:(NSTimeInterval)interval {
    [self abortTimerForInitDeviceTimeOut];
    self.timerForInitDeviceTimeOut = [NSTimer timerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(handleInitDeviceTimeOut:)
                                                           userInfo:nil
                                                            repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timerForInitDeviceTimeOut forMode:NSRunLoopCommonModes];
}

/**
 * 中止设备初始化超时定时器
 **/
- (void)abortTimerForInitDeviceTimeOut {
    if (self.timerForInitDeviceTimeOut != nil) {
        if ([self.timerForInitDeviceTimeOut isValid]) {
            [self.timerForInitDeviceTimeOut invalidate];
        }
        self.timerForInitDeviceTimeOut = nil;
    }
}

/**
 * 处理设备初始化超时
 **/
- (void)handleInitDeviceTimeOut:(NSTimer *)timer {
    [self cancelCurrentPeripheral];//不能完成初始化的设备直接断开连接
    
    BLEMessage *message = [BLEMessage new];
    message.notificationCode    = BLENotificationCodeInitDeviceTimeOut;
    message.peripheral          = self.currentPeripheral;
    [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                        object:nil
                                                      userInfo:@{kUserInfo_Key_Message: message}];
    [self abortTimerForInitDeviceTimeOut];
}

//===================================================
// 执行操作超时定时器
//===================================================
/**
 * 开始执行操作失败定时器
 **/
- (void)startTimerForFailToPerformOperation:(BLEOperationCommand *)bleOpCommand Interval:(NSTimeInterval)interval {
    [self abortTimerForFailToPerformOperation];
    self.timerForFailToPerformOperation = [NSTimer timerWithTimeInterval:interval
                                                                  target:self
                                                                selector:@selector(handleFailToPerformOperation:)
                                                                userInfo:bleOpCommand
                                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timerForFailToPerformOperation forMode:NSRunLoopCommonModes];
}

/**
 * 中止执行操作失败定时器
 **/
- (void)abortTimerForFailToPerformOperation {
    if (self.timerForFailToPerformOperation != nil) {
        if ([self.timerForFailToPerformOperation isValid]) {
            [self.timerForFailToPerformOperation invalidate];
        }
        self.timerForFailToPerformOperation = nil;
    }
}

/**
 * 处理执行操作失败
 **/
- (void)handleFailToPerformOperation:(NSTimer *)timer {
    BLEMessage *message = [BLEMessage new];
    message.notificationCode            = BLENotificationCodeFailToPerformOperation;
    BLEOperationCommand *bleOpCommand   = [timer userInfo];
    message.bleOpCode                   = [bleOpCommand getOperationCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:BLECommandHelperNotification
                                                        object:nil
                                                      userInfo:@{kUserInfo_Key_Message: message}];
    [self abortTimerForFailToPerformOperation];
}




@end
