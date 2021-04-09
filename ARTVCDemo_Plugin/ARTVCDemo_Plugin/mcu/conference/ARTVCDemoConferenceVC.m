//
//  ARTVCDemoConferenceVC.m
//  AntMedia
//
//  Created by aspling on 2017/7/20.
//  Copyright © 2017年 aspling. All rights reserved.
//
#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
//
//  ARTVCDemoConferenceVC.m
//  AntMedia
//
//  Created by aspling on 2017/7/20.
//  Copyright © 2017年 aspling. All rights reserved.
//
#import "ARTVCDemoConferenceVC.h"
#import "ARTVCDemoCollectionViewCell.h"
#import <ARTVC/ARTVC.h>
#import "ARTVCDemoControlView.h"
#import "AMImageSaver.h"
#import "../Toast/UIView+ARTVCToast.h"
#import "../settings/ARTVCDemoSettingsModel.h"
#import <APMUtils/APMLog.h>
#import <ReplayKit/ReplayKit.h>
#import <MPARTVCUpload/EKSampleHandlerClientSocketManager.h>
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "

NSString *identifier = @"Cell";
CGFloat margin10 = 0;
@interface ARTVCDemoMemberInfo:NSObject
@property(nonatomic,strong) ARTVCFeed* feed;
@property(nonatomic,strong) UIView* renderView;
@property(nonatomic,assign) CGSize frameSize;
@property(nonatomic,assign) BOOL firstFrameRendered;
@end
@implementation ARTVCDemoMemberInfo
-(instancetype)init{
    self = [super init];
    _frameSize = CGSizeZero;
    _firstFrameRendered = NO;
    return self;
}
@end
@interface ARTVCDemoConferenceVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ARTVCEngineDelegate,ARTVCDemoControlViewDelegate,ARTVCDynamicConfigProtocol,XRTCVideoCapturerDelegate>
@property(nonatomic,copy) NSString* uid;
@property (nonatomic,copy) NSString* bizname;
@property (nonatomic,copy) NSString* subbiz;
@property (nonatomic,copy) NSString* signature;
@property (nonatomic,copy) NSString* serverUrl;
@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) UILabel* roomInfoView;
@property(nonatomic,strong) UIView* debugView;
@property(nonatomic,strong) ARTVCDemoControlView* controlView;
@property(nonatomic,strong) ARTVCEngine* artvcEgnine;

@property(nonatomic,strong) NSMutableArray<ARTVCDemoMemberInfo*>* renderInfos;
@property(nonatomic,strong) NSLock* viewLock;
@property(nonatomic,assign) CGFloat cWidth;
@property(nonatomic,assign) CGFloat cHeight;
@property(nonatomic,strong) ARTVCDemoSettingsModel *settingModel;

@property(nonatomic,strong) ARTVCFeed* defaultLocalFeed;
@property(nonatomic,strong) ARTVCFeed* customLocalFeed;
@property(nonatomic,strong) ARTVCFeed* screenLocalFeed;
@property(nonatomic,strong) ARTVCFeed* feedForRemote;
@property(nonatomic,assign) BOOL use30Fps;
@property(nonatomic,assign) BOOL shouldUp;
@property(nonatomic,strong) ARTVCCustomVideoCapturer* customCapturer;
@property(nonatomic,strong) ARTVCPublishConfig* customPublishConfig;
@property(nonatomic,strong) ARTVCVideoCapturer* cameraCapturer;
@property(nonatomic,assign) float beautyLevel;
@property(nonatomic,strong) UIImage *virtualBGImage;
@property(nonatomic,strong) NSMutableData *pcmData;
@property(nonatomic,assign) UIBackgroundTaskIdentifier backIden;
@property(nonatomic,strong) UIView *broadcastPickerView;
#ifdef ARTVC_BUILD_FOR_MPAAS
@property (nonatomic,copy) NSString* workspaceId;
#endif
@end

@implementation ARTVCDemoConferenceVC

- (void)viewDidLoad {
    APM_INFO(@"viewDidLoad");
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"多人通话";
    
    NSDate *start = [NSDate date];
    APM_INFO(@"frame:%@",NSStringFromCGRect(self.view.frame));
    // Do any additional setup after loading the view.
    _settingModel = [[ARTVCDemoSettingsModel alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _viewLock = [[NSLock alloc] init];
    _renderInfos = [NSMutableArray array];
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    
    //layout.itemSize = CGSizeMake(100, 100);
    CGFloat navigatorHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _cWidth = self.view.frame.size.width-2*margin10;
    _cHeight = self.view.frame.size.height-2*margin10-navigatorHeight-statusBarHeight;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.center = self.view.center;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[ARTVCDemoCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    NSDate *start2 = [NSDate date];
//    [_artvcEgnine localView];
    APM_INFO(@"1 conference view controller init cost %.3fs",[[NSDate date] timeIntervalSinceDate:start2]);
    
    _roomInfoView = [[UILabel alloc] initWithFrame:CGRectZero];
    _roomInfoView.frame = CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 20);
    _roomInfoView.hidden = YES;
    _roomInfoView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_roomInfoView];
    APM_INFO(@"2 conference view controller init cost %.3fs",[[NSDate date] timeIntervalSinceDate:start]);
    
    
    _controlView = [[ARTVCDemoControlView alloc] initWithFrame:self.view.frame];
    _controlView.delegate = self;
    _controlView.uid = self.uid;
    _controlView.hidden = YES;
    [self.view addSubview:_controlView];
    
    UITapGestureRecognizer *tapRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControlView)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    

    
    UISwipeGestureRecognizer *swipeRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDebugView)];
    swipeRecognizer.numberOfTouchesRequired = 1;
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    _use30Fps = NO;
    if([_settingModel currentFramerate] > 15){
        _use30Fps = YES;
    }
    
    // for mpaas: control useSmartAVProcessing、beautyLevel、virtualBackground by demo setting
    _artvcEgnine = [[ARTVCEngine alloc] init];
//    BOOL useSmartAVProcessing = [self enableBloxWayFromSetting];
//    if ([ARTVCEngine isSmartAVProcessingSupported] && useSmartAVProcessing){
//        _artvcEgnine.useSmartAVProcessing = useSmartAVProcessing;
//    }
//    NSString *beautyLevelStr = [self beautyLevelFromSetting];
//    _beautyLevel = [beautyLevelStr floatValue];
//    BOOL enableVirtualBG = [self enableVirtualBGFromSetting];
//    if (enableVirtualBG) {
//        UIImage *image = [UIImage imageNamed:@"background"];
//        self.virtualBGImage = image;
//    }
    
    NSString *mockedConfigs = [self mockedConfigsFromSetting];
    if (mockedConfigs) {
        _artvcEgnine.mockedCloudConfigs = mockedConfigs;
    }
    
    // for portal: control useSmartAVProcessing、beautyLevel、virtualBackground by cloudConfig
//    _artvcEgnine = [[ARTVCEngine alloc] initWithOptions:@{kARTVCBizName:@"MRTC_Blox_Default",kARTVCSubbiz :@"MRTC_Blox_Default"}];
    
    _artvcEgnine.uid = self.uid;
    _artvcEgnine.delegate = self;
    _artvcEgnine.dynamicConfigProxy = self;
//    _artvcEgnine.enableCameraRawSampleOutput = YES;
#if defined(ARTVC_BUILD_FOR_MPAAS)
    [self setMpaasServerUrlIfNeed];
#else
    if(self.serverUrl && self.serverUrl.length > 0){
        _artvcEgnine.roomServerType = ARTVCRoomServerType_Custom;
        _artvcEgnine.roomServerCustomUrl = self.serverUrl;
    }else{
        _artvcEgnine.roomServerType = [self roomserverTypeFromSetting];
    }
#endif
    
    _artvcEgnine.videoProfileType = [self videoProfileFromSetting];
    _shouldUp = [self canResolutionScaleUp];
    
    ARTVCPublishConfig* config = [[ARTVCPublishConfig alloc] init];
    ARTVCSubscribeOptions* options = [[ARTVCSubscribeOptions alloc] init];
    if(self.audioOnly){
        config.videoEnable = NO;
        config.videoProfile = _artvcEgnine.videoProfileType;
        _artvcEgnine.autoPublishConfig = config;

        options.receiveVideo = NO;
        _artvcEgnine.autoSubscribeOptions = options;
    }else{
        //start camera only when publish is enabled.
        if([self eanblePublish]){
            if(!self.testCustomVideoCapture){
                config.videoProfile = _artvcEgnine.videoProfileType;
                if(self.publishVideoOnly){
                    config.audioEnable = NO;
                    options.receiveAudio = NO;
                }
                [_artvcEgnine startCameraPreviewUsingBackCamera:NO];
            }else{
                [self startCustomVideoCapture];
            }
        }
    }
    _artvcEgnine.autoPublishConfig = config;
    _artvcEgnine.autoSubscribeOptions = options;
    _artvcEgnine.autoPublish = [self eanblePublish];
    _artvcEgnine.autoSubscribe = [self eanbleSubscribe];
    //test setting mute on before call is established.
    //[_artvcEgnine muteMicrophone:YES];
    #ifdef ARTVC_ENABLE_STATS
        _debugView = [_artvcEgnine debugView];
        _debugView.frame = self.view.frame;
        _debugView.hidden = YES;
        [self.view addSubview:_debugView];
    #endif
    
//    _artvcEgnine.enableAudioBufferOutput = YES;
//    _artvcEgnine.degradationPreference = ARTVCDegradationPreferenceMAINTAIN_FRAMERATE;
    
    if(!self.roomId){
        [self createRoom];
    }else{
        [self joinRoom];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    APM_INFO(@"viewWillAppear");
    [super viewWillAppear:animated];
    //ARTVC_ENABLE_DEMO_CONTINUS_IN_OUT
#if 0
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didDisconnectTriggled:nil];
    });
#endif
}
-(void)showControlView{
    [_controlView canResolutionScaleUp:[self canResolutionScaleUp]];
    _controlView.hidden = !_controlView.hidden;
}
-(void)showDebugView{
    _debugView.hidden = !_debugView.hidden;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    APM_INFO(@"ARTVCDemoConferenceVC dealloc");
    [_artvcEgnine stopCameraPreview];
    [_artvcEgnine leaveRoom];
}

#pragma mark - UICollectionViewDataSource 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self cellCount];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ARTVCDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSUInteger index = [indexPath indexAtPosition:1];
    
    UIView *view;
    ARTVCDemoMemberInfo* info;
    NSInteger cellcout;
    [_viewLock lock];
    info = [_renderInfos objectAtIndex:index];
    view = info.renderView;
    cellcout = [_renderInfos count];
    [_viewLock unlock];
    CGRect rect = [self frameForCellWithIndexPath:indexPath];
    view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    for(UIView* it in cell.contentView.subviews){
        [it removeFromSuperview];
    }
    
    [cell.contentView addSubview:view];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = [self frameForCellWithIndexPath:indexPath];
    return rect.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
#pragma mark - View layout
-(NSUInteger)cellCount{
    __block NSUInteger count = 0;
    [_viewLock lock];
    count = [_renderInfos count];
    
    [self.renderInfos enumerateObjectsUsingBlock:^(ARTVCDemoMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.firstFrameRendered){
            --count;
        }
    }];
    [_viewLock unlock];
    return count;
}
-(CGRect)frmaeForCellWithCellNumber:(NSUInteger)cellNum{
    CGRect rect;
    switch (cellNum) {
        case 1:
        {
            rect = CGRectMake(0, 0, _cWidth, _cHeight);
        }
            break;
        case 2:
        //{
        //    rect = CGRectMake(0, 0, _cWidth, (_cHeight-10)/2);
            
        //}
          //  break;
        case 3:
        case 4:
        {
            CGFloat w = (_cHeight-10)/2;
            CGFloat h = w*16/9;
            if((h*2+10) > _cHeight){
                h = (_cHeight-10)/2;
                w = h*9/16;
            }
            rect = CGRectMake(0, 0, w, h);
        }
            break;
        case 5:
        case 6:
        {
            CGFloat w = (_cWidth-20)/3;
            CGFloat h = w*16/9;
            if((h*2+10) > _cHeight){
                h = (_cHeight-10)/2;
                w = h*9/16;
            }
            rect = CGRectMake(0, 0, w, h);
        }
            break;
        case 7:
        case 8:
        case 9:
        {
            CGFloat w = (_cWidth-20)/3;
            CGFloat h = w*16/9;
            if((h*3+20) > _cHeight){
                h = (_cHeight-20)/3;
                w = h*9/16;
            }
            rect = CGRectMake(0, 0, w, h);
        }
            break;
            
        default:{
            rect = CGRectMake(0, 0, 100, 100);
        }
            
            break;
    }
    return rect;
}
-(CGRect)defaultViewFrame{
    CGFloat w = (_cHeight-10)/2;
    CGFloat h = w*16/9;
    if((h*2+10) > _cHeight){
        h = (_cHeight-10)/2;
        w = h*9/16;
    }
    return CGRectMake(0, 0, w, h);
}
-(CGRect)viewFrameWith:(CGSize)size{
    CGFloat ratioV = size.height/size.width;
    CGFloat ratioH = size.width/size.height;
    CGFloat w,h;
    if(size.width < size.height){
        w = _cWidth/2;
        h = w*ratioV;
    }else{
        w = _cWidth-10;
        h = w/ratioH;
    }
    return CGRectMake(0, 0, w, h);
}
-(CGRect)frameForCellWithIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = [indexPath indexAtPosition:1];
    CGRect rect;
    NSUInteger count = 0;
    ARTVCDemoMemberInfo* info;
    [self.viewLock lock];
    info = [self.renderInfos objectAtIndex:index];
    count = self.renderInfos.count;
    [self.viewLock unlock];
    if(!info){
        return CGRectZero;
    }
    if(info.feed.feedType != ARTVCFeedTypeRemoteFeed && [info.feed.tag containsString:@"CAMERA"] && count == 1){
        return CGRectMake(0, 0, _cWidth, _cHeight);
    }
    if(CGSizeEqualToSize(info.frameSize,CGSizeZero)){
        rect = [self defaultViewFrame];
        return rect;
    }else{
        return [self viewFrameWith:info.frameSize];
    }
}

#pragma mark - Conference Create/Join
-(void)createRoom{
    ARTVCCreateRoomParams* params = [[ARTVCCreateRoomParams alloc] init];
    params.uid = self.uid;
    params.bizName = self.bizname;
#if defined(ARTVC_BUILD_FOR_MPAAS)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if([self workspaceId]){
        [params setWorkspaceIdManually:[self workspaceId]];
    }
    if([self subbiz]){
        [params setAppIdManually:[self subbiz]];
    }
#pragma clang diagnostic pop
#else
    params.subBiz = self.subbiz;
#endif
    params.signature = self.signature;
    params.type = self.testBroadcast ?ARTVCRoomServiceType_LIVE:ARTVCRoomServiceType_RTC;
    if(self.testBroadcast){
        NSString* rtmpUrl = [self rtmpUrl];
        if(!rtmpUrl) return;
        params.extraInfo = @{
            ARTVCParamsKey_LiveUrl:rtmpUrl
        };
    }

    [_artvcEgnine createRoom:params];
}
-(void)joinRoom{
    ARTVCJoinRoomParams* params = [[ARTVCJoinRoomParams alloc] init];
    params.uid = self.uid;
    params.bizName = self.bizname;
#if defined(ARTVC_BUILD_FOR_MPAAS)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if([self workspaceId]){
        [params setWorkspaceIdManually:[self workspaceId]];
    }
    if([self subbiz]){
        [params setAppIdManually:[self subbiz]];
    }
#pragma clang diagnostic pop
#else
    params.subBiz = self.subbiz;
#endif
    params.envType = _testAliyunSDK?ARTVCEnvType_AliYun:ARTVCEnvType_Alipay;
    params.roomId = self.roomId;
    if(params.envType == ARTVCEnvType_AliYun){
        NSDictionary* extraInfo = @{
            ARTVCParamsKey_AliYunSDK:@{
                    
            }
        };
        params.extraInfo = extraInfo;
    }else{
        params.signature = self.signature;
        params.rtoken = self.rtoken;
    }
    [_artvcEgnine joinRoom:params];
    [self updateRoomIDToken];
}


#pragma mark - Update roomdID/token
-(void)updateRoomIDToken{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* info = [NSString stringWithFormat:@"%@",self.roomId];
        self.roomInfoView.text = info;
        self.roomInfoView.hidden = NO;
        self.controlView.roomId = self.roomId;
        self.controlView.rtoken = self.rtoken;
    });
}
#pragma mark - ARTVCCallDelegate
-(void)didCameraPermissionNotAllowed{
    [self showToastWith:@"Camera permission not allowed" duration:1.0];
}
-(void)didMicrophonePermissionNotAllowed{
    [self showToastWith:@"Microphone permission not allowed" duration:1.0];
}
-(void)didOutputAudioBuffer:(ARTVCAudioData*)audioData{
    // caller no need to free mData, it will be released in its own dealloc method
    if (audioData.audioBufferList->mBuffers[0].mData != NULL && audioData.audioBufferList->mBuffers[0].mDataByteSize > 0) {
//        AudioBuffer tmpBuffer;
//        tmpBuffer.mData = malloc(audioData.audioBufferList->mBuffers[0].mDataByteSize);
//        memcpy(tmpBuffer.mData, audioData.audioBufferList->mBuffers[0].mData, audioData.audioBufferList->mBuffers[0].mDataByteSize);
//        NSData *pcmData = [NSData dataWithBytes:tmpBuffer.mData length:tmpBuffer.mDataByteSize];
        NSData *srcData = [NSData dataWithBytes:audioData.audioBufferList->mBuffers[0].mData length:audioData.audioBufferList->mBuffers[0].mDataByteSize];
        if (!_pcmData) {
            _pcmData = [[NSMutableData alloc] init];
        }
        [_pcmData appendData:srcData];
        if ([_pcmData length] > 2048*2000) {
            NSArray *docPathAry = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docPath = [docPathAry objectAtIndex:0];
            NSMutableString *path = [[NSMutableString alloc] initWithString:docPath];
            [path appendString:@"/audioData"];
            [_pcmData writeToFile:path atomically:YES];
            _pcmData = nil;
        }
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        BOOL result = [fileManager fileExistsAtPath:path];
//        NSLog(@"%d",result);
//        free(tmpBuffer.mData);
    }
}

#ifdef ARTVC_ENABLE_EXPROT_SAMPLEBUFFER
-(void)didOutputSampleBuffer:(CVImageBufferRef)sampleBuffer processedBuffer:(CVImageBufferRef *)processedBuffer{
    
}
#endif


#pragma mark - ARTVCEngineDelegate

-(void)didReceiveRoomInfo:(ARTVCRoomInfomation*)roomInfo{
    _roomId = roomInfo.roomId;
    _rtoken = roomInfo.rtoken;
    [self updateRoomIDToken];
    if([self enableInviteAfterCreateRoom]){
        [self invite];
    }
    if(self.testCustomVideoCapture && !self.audioOnly){
        [self pubishCustomVideo];
    }
}
-(void)didJoinroomSuccess{
    if(self.testCustomVideoCapture){
        [self pubishCustomVideo];
    }
}
/**
 *  local feed is generated with the specified publish config.
 *  under autoPublish mode,publishConfig is the autoPublishConfig.otherwise,it's the config passed to publish API.
 *
 *  about ARTVCPublishConfig,always using [config1 isEqual:config2]  to make sure whether two ARTVCPublishConfig objects are equal.don't use format of that if( config1 == config2).
 */
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)didReceiveLocalFeed:(ARTVCFeed*)localFeed{
    switch(localFeed.feedType){
        case ARTVCFeedTypeLocalFeedDefault:
            self.defaultLocalFeed = localFeed;
            break;
        case ARTVCFeedTypeLocalFeedCustomVideo:
            self.customLocalFeed = localFeed;
            break;
        case ARTVCFeedTypeLocalFeedScreenCapture:
            self.screenLocalFeed = localFeed;
            break;
        default:
            break;
    }
}
//#pragma clang diagnostic pop

- (void)didEncounterError:(NSError *)error forFeed:(ARTVCFeed*)feed{
    [self showToastWith:[NSString stringWithFormat:@"%@, Error:%@",feed,error] duration:1.0];
    switch(error.code){
        case ARTVCErrorCodeStartAudioDeviceFailed:
        case ARTVCErrorCodeMakeRtcCallUnderCellularCallNotAllowed:{
            [self.artvcEgnine stopCameraPreview];
            [self.artvcEgnine leaveRoom];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didConnectionStatusChangedTo:(ARTVCConnectionStatus)status forFeed:(ARTVCFeed*)feed{
    [self showToastWith:[NSString stringWithFormat:@"connection status:%d\nfeed:%@",status,feed] duration:1.0];
    if((status == ARTVCConnectionStatusClosed)  && [feed isEqual:self.defaultLocalFeed]){
        [self.artvcEgnine stopCameraPreview];
        [self.artvcEgnine leaveRoom];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if((status == ARTVCConnectionStatusConnected)  && [feed isEqual:self.defaultLocalFeed]){
        [self startLoopbackTestIfAllowed];
    }
}
//video render view has been created,but the first video frame has not been rendered yet
- (void)didVideoRenderViewInitialized:(UIView*)renderView forFeed:(ARTVCFeed*)feed{
    if([feed isEqual:self.defaultLocalFeed]){
        [self showToastWith:@"video preview view created" duration:1.0];
    }else if(feed.feedType == ARTVCFeedTypeRemoteFeed){
        self.feedForRemote = feed;
        
        // for unsub / resub test
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            ARTVCUnsubscribeConfig* config = [[ARTVCUnsubscribeConfig alloc] init];
//            config.feed = feed;
//            [_artvcEgnine unsubscribe:config complete:^(NSError *error){
//                ARTVCSubscribeConfig* config = [[ARTVCSubscribeConfig alloc] init];
//                config.feed = feed;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [_artvcEgnine subscribe:config];
//                });
//            }];
//        });
    }
    // set beauty level forFeed background if needed
//    if ([self.artvcEgnine isBeautySupportedForFeed:feed]) {
////        [self.artvcEgnine setBeautyLevel:self.beautyLevel forFeed:feed];
//    }
//    if ([self.artvcEgnine isVirtualBackgroundSupportedForFeed:feed]) {
//        [_artvcEgnine setVirtualBackgroundImageForLocalCamera:self.virtualBGImage];
//        [_artvcEgnine setVirtualBackgroundImage:self.virtualBGImage forFeed:feed];
//        [_artvcEgnine setVirtualBackgroundThreshold:0.4 forFeed:feed];
//        [_artvcEgnine setVirtualBackgroundSmoothing:0.2 forFeed:feed];
//    }
    [_viewLock lock];
    renderView.contentMode = UIViewContentModeScaleAspectFill;
    ARTVCDemoMemberInfo* info = [[ARTVCDemoMemberInfo alloc] init];
    info.renderView = renderView;
    info.feed = feed;
    [_renderInfos addObject:info];
    [_viewLock unlock];
    [self.collectionView reloadData];
}
//fist video frame has been rendered
- (void)didFirstVideoFrameRendered:(UIView*)renderView forFeed:(ARTVCFeed*)feed{
    [_viewLock lock];
    __block ARTVCDemoMemberInfo* info;
    [self.renderInfos enumerateObjectsUsingBlock:^(ARTVCDemoMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.renderView == renderView){
            info = obj;
            *stop = YES;
        }
    }];
    info.firstFrameRendered = YES;
    [_viewLock unlock];
    [self.collectionView reloadData];
    
    // for degradation preference test
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _artvcEgnine.degradationPreference = ARTVCDegradationPreferenceBALANCED;
//   });
}
//video render has stopped.
- (void)didVideoViewRenderStopped:(UIView*)renderView forFeed:(ARTVCFeed*)feed{
    [_viewLock lock];
    __block ARTVCDemoMemberInfo* found;
    [_renderInfos enumerateObjectsUsingBlock:^(ARTVCDemoMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.renderView == renderView){
            *stop = YES;
            found = obj;
        }
    }];
    // Attention!!! renderView must be removed from superView, prevent view not released after render stoped
    [renderView removeFromSuperview];
    if(found){
        [_renderInfos removeObject:found];
    }
    [_viewLock unlock];
    [self.collectionView reloadData];
}
- (void)didVideoSizeChangedTo:(CGSize)size renderView:(UIView*)renderView forFeed:(ARTVCFeed*)feed{
    [_viewLock lock];
    [_renderInfos enumerateObjectsUsingBlock:^(ARTVCDemoMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.renderView == renderView){
            obj.frameSize = size;
            *stop = YES;
        }
    }];
    [_viewLock unlock];
    [self.collectionView reloadData];
}
-(void)didParticepantsEntered:(NSArray<ARTVCParticipantInfo*>*)participants{
    [self showToastWith:[NSString stringWithFormat:@"participants enter:%@",participants] duration:1.0];
}
//-(void)didParticepantsLeft:(NSArray<ARTVCParticipantInfo*>*)participants{
//    [self showToastWith:[NSString stringWithFormat:@"participants left:%@",participants] duration:1.0];
//}
-(void)didParticepant:(ARTVCParticipantInfo*)participant leaveRoomWithReason:(ARTVCParticipantLeaveRoomReasonType)reason{
    [self showToastWith:[NSString stringWithFormat:@"participant left:%@ reason:%d",participant,reason] duration:1.0];
}
-(void)didNewFeedAdded:(ARTVCFeed*)feed{
    [self showToastWith:[NSString stringWithFormat:@"new feed published by others:%@",feed] duration:1.0];
    /*
    // can do subscribe manaully here
    ARTVCSubscribeOptions *options = [[ARTVCSubscribeOptions alloc] init];
    options.receiveVideo = NO;
    options.receiveAudio = YES;
    ARTVCSubscribeConfig *subConfig = [[ARTVCSubscribeConfig alloc] init];
    subConfig.feed = feed;
    subConfig.options = options;
    [self.artvcEgnine subscribe:subConfig];
    ARTVCUnsubscribeConfig* unConfig = [[ARTVCUnsubscribeConfig alloc] init];
    unConfig.feed = feed;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_artvcEgnine unsubscribe:unConfig complete:^(){
            NSLog(@"complete callback");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                options.receiveVideo = YES;
                subConfig.options = options;
                [self.artvcEgnine subscribe:subConfig];
//            });
        }];
//    });
     */
}
-(void)didFeedRemoved:(ARTVCFeed*)feed{
    [self showToastWith:[NSString stringWithFormat:@"feed unpublished by others:%@",feed] duration:1.0];
    
}
-(void)didSubscriber:(NSString*)subscriber subscribedAFeed:(ARTVCFeed*)feed{
    [self showToastWith:[NSString stringWithFormat:@"subscriber subscribed :%@",feed] duration:1.0];
}
-(void)didSubscriber:(NSString*)subscriber unsubscribedAFeed:(ARTVCFeed*)feed{
    [self showToastWith:[NSString stringWithFormat:@"subscriber unsubscribed :%@",feed] duration:1.0];
}
-(void)didAudioPlayModeChangedTo:(ARTVCAudioPlayMode)audioPlayMode{
    NSString *toast = nil;
    switch (audioPlayMode) {
        case ARTVCAudioPlayModeSpeaker:{
            toast = @"扬声器模式";
        }
            break;
        case ARTVCAudioPlayModeReceiver:{
            toast = @"听筒模式";
        }
            break;
        case ARTVCAudioPlayModeHeadphone:{
            toast = @"耳机模式";
        }
            break;
        case ARTVCAudioPlayModeBluetooth:{
            toast = @"蓝牙设备模式";
        }
            break;
        case ARTVCAudioPlayModeInit:{
            toast = @"未知模式";
        }
            break;
    }
    
    [self showToastWith:toast duration:1.0];
}
-(void)didNetworkChangedTo:(APMNetworkReachabilityStatus)netStatus{
    if(netStatus == APMNetReachabilityStatusReachableViaWiFi){
        return ;
    }
    [self showToastWith:[NSString stringWithFormat:@"网络切换到:%@",[APMNetworkStatusManager stringOfNetworkStatus:netStatus]] duration:1.0];
}
-(void)didReceiveClientEventNotify:(NSError*)error{
    [self showToastWith:[NSString stringWithFormat:@"%@",error] duration:1.0];
}
- (void)didAvailabeSendBandwidthBecomeLow:(BOOL)isLow currentBandwidth:(double)bw forFeed:(ARTVCFeed*)feed{
    if(isLow){
        [self showToastWith:@"当前通话质量不佳" duration:1.0];
    }
}
- (void)didRealtimeStatisticGenerated:(ARTVCRealtimeStatisticSummary*)summary forFeed:(ARTVCFeed*)feed{
    
}
- (void)didReceiveIMMessage:(ARTVCIMMessage*)message fromParticipant:(NSString*)participant{
    [self showToastWith:[message description] duration:1.0];
}
- (void)didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    APM_INFO(@"didOutputSampleBuffer:%@",sampleBuffer);
}
- (void)callWillBeClosedAsInterruptionHappened{
    APM_INFO(@"callWillBeClosedAsInterruptionHappened");
    [self.artvcEgnine stopCameraPreview];
    [self.artvcEgnine leaveRoom];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didParticipant:(NSString*)participant replyWith:(ARTVCReplyType)replyType roomId:(NSString*)roomId{
    NSString* str = [NSString stringWithFormat:@"%@ replied,type:%d,roomId:%@",participant,replyType,roomId];
    [self showToastWith:str duration:1.0];
}
#pragma mark - ARTVCDemoControlViewDelegate

-(void)didSnapshotTriggled:(ARTVCDemoControlView*)view{
    [self.artvcEgnine snapshotForFeed:self.defaultLocalFeed complete:^(UIImage* image){
        APM_INFO(@"image:%@",image);
        if(image){
            [AMImageSaver save:image toAlbum:@"mcudemo"];
        }
    }];
    [self.artvcEgnine snapshotForFeed:self.feedForRemote complete:^(UIImage* image){
        APM_INFO(@"image:%@",image);
        if(image){
            [AMImageSaver save:image toAlbum:@"mcudemo"];
        }
    }];
}
-(void)didSwitchCameraTriggled:(ARTVCDemoControlView *)view{
    [_artvcEgnine switchCamera];
    APM_INFO(@"current camera position is back:%d",[_artvcEgnine currentCameraPositionIsBack]);
//    static BOOL muted = YES;
//    [_artvcEgnine muteRemoteVideo:muted forFeed:self.feedForRemote];
//    muted = !muted;
    ARTVCIMMessage* msg = [[ARTVCIMMessage alloc] init];
    static int seq = 1;
    msg.msg = [NSString stringWithFormat:@"send a message %d",seq++];
    [self.artvcEgnine sendMessage:msg toPariticipant:_feedForRemote.uid complete:^(NSError* error){
        if(!error){
            [self showToastWith:@"IM send success" duration:1.0];
        }else{
            [self showToastWith:[error description] duration:1.0];
        }
    }];
    
}
-(void)didDisconnectTriggled:(ARTVCDemoControlView *)view{
    if(self.testCustomVideoCapture){
        [self unpubishCustomVideo];
    }
    [_artvcEgnine leaveRoom];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didEnableCameraTriggled:(ARTVCDemoControlView *)view stop:(BOOL)stop{
    if(stop){
        [_artvcEgnine stopCameraPreview];
    }else{
        [_artvcEgnine startCameraPreviewUsingBackCamera:[_artvcEgnine currentCameraPositionIsBack]];
    }
    
}
-(void)didMuteMicophoneTriggled:(ARTVCDemoControlView *)view mute:(BOOL)mute{
    [_artvcEgnine muteMicrophone:mute];
    //_artvcEgnine.enableCameraRawSampleOutput = !_artvcEgnine.enableCameraRawSampleOutput;
//    static BOOL muted = YES;
//    [_artvcEgnine muteRemoteAudio:muted forFeed:self.feedForRemote];
//    muted = !muted;
}
-(void)didSwithAudioPlaymodeTriggled:(ARTVCDemoControlView *)view{
    ARTVCAudioPlayMode mode = [_artvcEgnine currentAuidoPlayMode];
    if(mode == ARTVCAudioPlayModeSpeaker){
        [_artvcEgnine switchAudioPlayModeTo:ARTVCAudioPlayModeReceiver complete:nil];
    }else if(mode == ARTVCAudioPlayModeReceiver){
        [_artvcEgnine switchAudioPlayModeTo:ARTVCAudioPlayModeSpeaker complete:nil];
    }else{

    }
}
-(void)didSwithEncodeResolutionTriggled:(ARTVCDemoControlView *)view{
    [self scaleUpOrDownResolution];
}
-(void)didScreenshareTriggled:(ARTVCDemoControlView*)view{
    if(![_artvcEgnine isScreenCaptureStarted]){
        [self startScreenSharing];
    }else{
        [self stopScreenSharing];
    }
}

- (void)didBroadCastTriggled:(ARTVCDemoControlView*)view {
    if (@available(iOS 12.2, *)) {
        if (self.broadcastPickerView && self.broadcastPickerView.superview) {
            APM_INFO(@"stop screen sharing ios 12.2");
            ARTVCUnpublishConfig* config = [[ARTVCUnpublishConfig alloc] init];
            config.feed = self.screenLocalFeed;
            [_artvcEgnine unpublish:config];
            if (self.broadcastPickerView && self.broadcastPickerView.superview) {
                [self.broadcastPickerView removeFromSuperview];
                self.broadcastPickerView = nil;
            }
        }else {
            APM_INFO(@"start screen sharing ios 12.2");
            RPSystemBroadcastPickerView *picker = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            picker.center = self.view.center;
            self.broadcastPickerView = picker;
            picker.showsMicrophoneButton = NO;
            // 配置 自己的 id
            picker.preferredExtension = @"com.mpaas.demo.broadcastUpload";
            [self.view addSubview:picker];
            
            [[EKSampleHandlerClientSocketManager sharedManager] setupSocket];
            [[EKSampleHandlerClientSocketManager sharedManager] setGetBufferBlock:^(CMSampleBufferRef  _Nonnull sampleBuffer) {
                UIImage *image = [self imageConvert:sampleBuffer];
                NSLog(@"～～～～～～%@",image);
                [self.customCapturer provideCustomVideoFramePeriodlyWith: CMSampleBufferGetImageBuffer(sampleBuffer)];
                
            }];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
            _artvcEgnine.autoPublish = NO;
            
            ARTVCCreateCustomVideoCaputurerParams* params = [[ARTVCCreateCustomVideoCaputurerParams alloc] init];
            params.provideRenderView = YES;
            self.customCapturer = [_artvcEgnine createCustomVideoCapturer:params];
            
            ARTVCPublishConfig* config = [[ARTVCPublishConfig alloc] init];
            config.videoSource = ARTVCVideoSourceType_Custom;
            config.videoProfile = ARTVCVideoProfileType_640x360_15Fps;
            self.customPublishConfig = config;
            [self pubishCustomVideo];
        }
    }else {
        [self showToastWith:@"当前系统不支持应用间录屏" duration:1.0];
    }
}
-(void)didDegradationPreferenceTriggled:(ARTVCDemoControlView*)view{
    switch (_artvcEgnine.degradationPreference) {
        case ARTVCDegradationPreferenceMAINTAIN_RESOLUTION:
            _artvcEgnine.degradationPreference = ARTVCDegradationPreferenceMAINTAIN_FRAMERATE;
            [self showToastWith:@"degradation preference changed to MAINTAIN_FRAMERATE" duration:1.0];
            break;
            
        case ARTVCDegradationPreferenceMAINTAIN_FRAMERATE:
            _artvcEgnine.degradationPreference = ARTVCDegradationPreferenceBALANCED;
            [self showToastWith:@"degradation preference changed to BALANCED" duration:1.0];
            break;
            
        case ARTVCDegradationPreferenceDISABLED:
            _artvcEgnine.degradationPreference = ARTVCDegradationPreferenceMAINTAIN_RESOLUTION;
            [self showToastWith:@"degradation preference changed to MAINTAIN_RESOLUTION" duration:1.0];
            break;
            
        case ARTVCDegradationPreferenceBALANCED:
            _artvcEgnine.degradationPreference = ARTVCDegradationPreferenceMAINTAIN_RESOLUTION;
            [self showToastWith:@"degradation preference changed to MAINTAIN_RESOLUTION" duration:1.0];
            break;
        default:
            break;
    }
}
#pragma mark - Toast error
-(void)showToastWith:(NSString*)text duration:(NSTimeInterval)duration{
    __weak ARTVCDemoConferenceVC* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong ARTVCDemoConferenceVC* strongSelf = weakSelf;
        [strongSelf.navigationController.view makeToast:text duration:duration position:ARTVCToastPositionCenter];
    });
}
-(void)showError:(NSError*)error{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error happened"
                                                                   message:error.description
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - ARTVCDynamicConfigProtocol
-(NSString *)configWithKey:(NSString *)key{
    if([key isEqualToString:ARTVCDynamicConfigPreferVideoEncodeTypeKey]){
        return @"1";
    }
    if([key isEqualToString:ARTVCDynamicConfigIceTransportPolicyKey]){
        return nil;
    }
    if([key isEqualToString:ARTVCDynamicConfigDisableDTLSKey]){
        NSString * value = [_settingModel isDtlsDisabled] ?@"1":@"0";
        return value;
    }
    if([key isEqualToString:ARTVCDynamicConfigMaxBitrateKey]){
        NSUInteger bitrate = [_settingModel currentBitrate];
        if(bitrate > 0){
            return [NSString stringWithFormat:@"%lu",bitrate];
        }
        return nil;
    }
    if([key isEqualToString:ARTVCDynamicConfigMaxBitrateForScreenSharingKey]){
        NSUInteger bitrate = [_settingModel currentBitrate];
        if(bitrate > 0){
            return [NSString stringWithFormat:@"%lu",bitrate];
        }
        return nil;
    }
    if([key isEqualToString:ARTVCDynamicConfigMaxBitrateForCustomVideoKey]){
        NSUInteger bitrate = [_settingModel currentBitrate];
        if(bitrate > 0){
            return [NSString stringWithFormat:@"%lu",bitrate];
        }
        return nil;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnableFlexFecKey]){
        if([self.settingModel eanbleFlexFEC]){
            return @"1";
        }
        return nil;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnableBWEExperimentKey]){
        NSString* bweFlag = [self.settingModel bweExperimentFlag];
        return bweFlag;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnablePacingExperimentKey]){
        NSString* pacing = [self.settingModel pacingExperiment];
        return pacing;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnableNackExperimentKey]){
        NSString* nack = [self.settingModel nackExperiment];
        return nack;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnablePlayoutDelayExperimentKey]){
        NSString* playoutDelay = [self.settingModel playoutDelayExperiment];
        return playoutDelay;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnableJitterEstimatorExperimentKey]){
        NSString* jitter = [self.settingModel jitterExperiment];
        return jitter;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnableMockedCloudConfigsKey]) {
        NSString *mockedConfig = [self.settingModel mockedConfigs];
        return mockedConfig;
    }
    if([key isEqualToString:ARTVCDynamicConfigEnableVideoSmoothRenderingExperimentKey]){
        NSString* enable = [NSString stringWithFormat:@"%d",![self.settingModel isVideoSmoothRenderingDisabled]];
        return enable;
    }
    return nil;
}
#pragma mark - config from settings
-(NSString*)uid{
    @synchronized (self) {
        if(!_uid){
            _uid = [_settingModel uid];
            if(!_uid || _uid.length <= 0){
                [self showToastWith:@"uid is empty! please set uid in settings." duration:1.0];
                return nil;
            }
        }
        return _uid;
    }
}
-(NSString*)bizname{
    @synchronized (self) {
        if(!_bizname){
            _bizname = [_settingModel bizname];
            if(!_bizname || _bizname.length <= 0){
                [self showToastWith:@"bizname is empty! please set bizname in settings." duration:1.0];
                return nil;
            }
        }
        return _bizname;
    }
}
-(NSString*)subbiz{
    @synchronized (self) {
        if(!_subbiz){
            _subbiz = [_settingModel subbiz];
            if(!_subbiz || _subbiz.length <= 0){
#if defined(ARTVC_BUILD_FOR_MPAAS)
                [self showToastWith:@"use AppId from mPaaS config file " duration:1.0];
#else
                [self showToastWith:@"subbiz is empty! please set subbiz in settings." duration:1.0];
#endif
                
                return nil;
            }
        }
        return _subbiz;
    }
}
-(NSString*)signature{
    @synchronized (self) {
        if(!_signature){
            _signature = [_settingModel signature];
            if(!_signature || _signature.length <= 0){
                [self showToastWith:@"signature is empty! please set signature in settings." duration:1.0];
                return nil;
            }
        }
        return _signature;
    }
}
#ifdef ARTVC_BUILD_FOR_MPAAS
-(NSString *)workspaceId{
    @synchronized (self) {
        if(!_workspaceId){
            _workspaceId = [_settingModel workspaceId];
            if(!_workspaceId || _workspaceId.length <= 0){
                [self showToastWith:@"use workspaceId from mPaaS config file" duration:1.0];
                return nil;
            }
        }
        return _workspaceId;
    }
}
#endif
-(NSString*)serverUrl{
    @synchronized (self) {
        if(!_serverUrl){
            _serverUrl = [_settingModel customServerUrl];
            if(!_serverUrl || _serverUrl.length <= 0){
#ifdef ARTVC_BUILD_FOR_MPAAS
                [self showToastWith:@"use serverUrl from mPaaS config file" duration:1.0];
#endif
                return nil;
            }
        }
        return _serverUrl;
    }
}
-(NSString*)rtmpUrl{
    @synchronized (self) {
        NSString* liveurl = [_settingModel liveUrl];
        if(!liveurl || liveurl.length <= 0){
            [self showToastWith:@"RTMP address is empty.please set RTMP address in settings" duration:1.0];
            return nil;
        }
        return liveurl;
    }
}
-(ARTVCVideoProfileType)videoProfileFromSetting{
    NSString* resolution = [self.settingModel currentVideoResoultionConstraintFromStore];
    //160x90 and 160x90 only support 15fps now.
    if([resolution isEqualToString:@"160x90"]){
        return ARTVCVideoProfileType_160x90_15Fps;
    }else if([resolution isEqualToString:@"320x180"]){
        return ARTVCVideoProfileType_320x180_15Fps;
    }else if([resolution isEqualToString:@"640x480"]){
        return self.use30Fps?ARTVCVideoProfileType_640x480_30Fps: ARTVCVideoProfileType_640x480_15Fps;
    }else if([resolution isEqualToString:@"640x360"]){
        return self.use30Fps?ARTVCVideoProfileType_640x360_30Fps: ARTVCVideoProfileType_640x360_15Fps;
    }else if([resolution isEqualToString:@"960x540"]){
        return self.use30Fps?ARTVCVideoProfileType_960x540_30Fps:ARTVCVideoProfileType_960x540_15Fps;
    }else if([resolution isEqualToString:@"1280x720"]){
        return self.use30Fps?ARTVCVideoProfileType_1280x720_30Fps:ARTVCVideoProfileType_1280x720_15Fps;
    }else{
        return self.use30Fps?ARTVCVideoProfileType_640x360_30Fps:ARTVCVideoProfileType_640x360_15Fps;
    }
}
-(BOOL)enableBloxWayFromSetting{
    return [self.settingModel enableUseBloxWay];
}
-(NSString *)beautyLevelFromSetting{
    return [self.settingModel beautyLevel];
}
-(BOOL)enableVirtualBGFromSetting{
    return [self.settingModel enableVirtualBG];
}
-(NSString *)mockedConfigsFromSetting{
    return [self.settingModel mockedConfigs];
}
#ifndef ARTVC_BUILD_FOR_MPAAS
-(ARTVCRoomServerType)roomserverTypeFromSetting{
    if([self.settingModel isOnlineServer]){
        if(self.testAliyunSDK) return ARTVCRoomServerType_PreOnline;
        return ARTVCRoomServerType_Online;
    }
    return ARTVCRoomServerType_Test;
}
#endif
-(BOOL)canResolutionScaleUp{
    return  _artvcEgnine.videoProfileType < ARTVCVideoProfileType_1280x720_15Fps || _artvcEgnine.videoProfileType == ARTVCVideoProfileType_160x90_15Fps;
}
-(void)scaleUpOrDownResolution{
    ARTVCVideoProfileType profile = _artvcEgnine.videoProfileType;
    if(_shouldUp && [self canResolutionScaleUp]){
        switch (profile) {
            case ARTVCVideoProfileType_160x90_15Fps:
            case ARTVCVideoProfileType_320x180_15Fps:
                profile = ARTVCVideoProfileType_640x360_15Fps;
                break;
            case ARTVCVideoProfileType_640x360_15Fps:
            case ARTVCVideoProfileType_640x360_30Fps:
            case ARTVCVideoProfileType_640x480_15Fps:
            case ARTVCVideoProfileType_640x480_30Fps:
            case ARTVCVideoProfileType_960x540_15Fps:
            case ARTVCVideoProfileType_960x540_30Fps:
                profile = ARTVCVideoProfileType_1280x720_15Fps;
                break;
            default:
                break;
        }
        [_artvcEgnine changeVideoProfileTo:profile forVideoSource:ARTVCVideoSourceType_Camera];
        [_artvcEgnine changeVideoProfileTo:profile forVideoSource:ARTVCVideoSourceType_Custom];
        [_artvcEgnine changeVideoProfileTo:profile forVideoSource:ARTVCVideoSourceType_Screen];
        [_controlView canResolutionScaleUp:[self canResolutionScaleUp]];
    }else{
        _shouldUp = NO;
        switch (profile) {
            case ARTVCVideoProfileType_640x360_15Fps:
            case ARTVCVideoProfileType_640x360_30Fps:
            case ARTVCVideoProfileType_320x180_15Fps:
                profile = ARTVCVideoProfileType_160x90_15Fps;
                break;
            case ARTVCVideoProfileType_1280x720_15Fps:
            case ARTVCVideoProfileType_1280x720_30Fps:
            case ARTVCVideoProfileType_960x540_15Fps:
            case ARTVCVideoProfileType_960x540_30Fps:
            case ARTVCVideoProfileType_640x480_15Fps:
            case ARTVCVideoProfileType_640x480_30Fps:
                profile = ARTVCVideoProfileType_640x360_15Fps;
                break;
            default:
                break;
        }
        [_artvcEgnine changeVideoProfileTo:profile forVideoSource:ARTVCVideoSourceType_Camera];
        [_artvcEgnine changeVideoProfileTo:profile forVideoSource:ARTVCVideoSourceType_Custom];
        [_artvcEgnine changeVideoProfileTo:profile forVideoSource:ARTVCVideoSourceType_Screen];
        if(profile == ARTVCVideoProfileType_160x90_15Fps){
            _shouldUp = YES;
            [_controlView canResolutionScaleUp:[self canResolutionScaleUp]];
        }
        
    }
    [self showToastWith:[self stringWithProfile:_artvcEgnine.videoProfileType] duration:1.0];
}
-(NSString*)stringWithProfile:(ARTVCVideoProfileType)profile{
    NSString* str;
    switch(profile){
        case ARTVCVideoProfileType_160x90_15Fps:
            str = @"160x90 15FPS";
            break;
        case ARTVCVideoProfileType_640x480_15Fps:
            str = @"640x480 15FPS";
            break;
        case ARTVCVideoProfileType_640x480_30Fps:
            str = @"640x480 30FPS";
            break;
        case ARTVCVideoProfileType_640x360_15Fps:
            str = @"360P 15FPS";
            break;
        case ARTVCVideoProfileType_640x360_30Fps:
            str = @"360P 30FPS";
            break;
        case ARTVCVideoProfileType_960x540_15Fps:
            str = @"540P 15FPS";
            break;
        case ARTVCVideoProfileType_960x540_30Fps:
            str = @"540P 30FPS";
            break;
        case ARTVCVideoProfileType_1280x720_15Fps:
            str = @"720P 15FPS";
            break;
        case ARTVCVideoProfileType_1280x720_30Fps:
            str = @"720P 30FPS";
            break;
        case ARTVCVideoProfileType_Custom:
            str = @"custom defined";
            break;
    }
    return str;
}
#pragma mark - camera capturer
-(ARTVCVideoCapturer*)createCameraCapturerWith:(ARTVCVideoProfileType)type{
    self.cameraCapturer = [[ARTVCVideoCapturer alloc] initWithDelete:self];
    self.cameraCapturer.fps  = 15;
    [self.cameraCapturer startCapture];
    return self.cameraCapturer;
}
#pragma mark - XRTCVideoCapturerDelegate
- (void)capturer:(XRTCVideoCapturer *)capturer didCaptureVideoFrame:(XRTCVideoFrame *)frame{
    //APM_INFO(@"capturer:%@ didCaptureVideoFrame:%@",capturer,frame);
    [self.customCapturer provideCustomVideoFramePeriodlyWith:((XRTCCVPixelBuffer_Unique*)(frame.buffer)).pixelBuffer];
}
#pragma mark - custom capturer
-(void)startCustomVideoCapture{
    ARTVCCreateCustomVideoCaputurerParams* params = [[ARTVCCreateCustomVideoCaputurerParams alloc] init];
    params.provideRenderView = YES;
    ARTVCPublishConfig* config = [[ARTVCPublishConfig alloc] init];
    config.videoSource = ARTVCVideoSourceType_Custom;
    config.videoProfile = ARTVCVideoProfileType_640x360_15Fps;
    self.customPublishConfig = config;
    
    self.customCapturer = [_artvcEgnine createCustomVideoCapturer:params];
    _artvcEgnine.autoPublish = NO;
    [self createCameraCapturerWith:ARTVCVideoProfileType_640x360_15Fps];
}
-(void)pubishCustomVideo{
    [_artvcEgnine publish:self.customPublishConfig];
}
-(void)unpubishCustomVideo{
    [_artvcEgnine stopScreenCapture];
    ARTVCUnpublishConfig* config = [[ARTVCUnpublishConfig alloc] init];
    config.feed = self.customLocalFeed;
    [_artvcEgnine unpublish:config];
}
#pragma mark - screen capturer
-(void)startScreenSharing{
    APM_INFO(@"start screen sharing");
    ARTVCCreateScreenCaputurerParams* screenParams = [[ARTVCCreateScreenCaputurerParams alloc] init];
    screenParams.provideRenderView = YES;
    [_artvcEgnine startScreenCaptureWithParams:screenParams complete:^(NSError* error){
        APM_INFO(@"start screen sharing finish,error:%@",error);
        if(error){
            [self showToastWith:[NSString stringWithFormat:@"Error:%@",error] duration:1.0];
        }else{
            ARTVCPublishConfig* config = [[ARTVCPublishConfig alloc] init];
            config.videoSource = ARTVCVideoSourceType_Screen;
            config.audioEnable = NO;
            config.videoProfile = ARTVCVideoProfileType_1280x720_30Fps;
            [_artvcEgnine publish:config];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                 [self stopScreenSharing];
            //            });
        }
    }];
}
-(void)stopScreenSharing{
    APM_INFO(@"stop screen sharing");
    [_artvcEgnine stopScreenCapture];
    ARTVCUnpublishConfig* config = [[ARTVCUnpublishConfig alloc] init];
    config.feed = self.screenLocalFeed;
    [_artvcEgnine unpublish:config complete:^(){
        NSLog(@"");
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //             [self startScreenSharing];
        //        });
    }];
}

- (void)didEnterBackGround {
    //保证进入后台后App依然能得到时间处理
    APM_INFO(@"didEnterBackGround");
    __weak typeof(self) weakSelf = self;
    self.backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[UIApplication sharedApplication] endBackgroundTask:strongSelf.backIden];
        strongSelf.backIden = UIBackgroundTaskInvalid;
    }];
}

- (BOOL)validateios12Action {
    if (@available(iOS 12.2, *)) {
        APM_INFO(@"validateios12Action");
        RPSystemBroadcastPickerView *picker = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        picker.center = self.view.center;
        self.broadcastPickerView = picker;
        picker.showsMicrophoneButton = NO;
        // 配置 自己的 id
        picker.preferredExtension = @"tiebijuren.com.paasDemoScy.broadcastUpload";
        [self.view addSubview:picker];
        return YES;
    }else {
        APM_INFO(@"NOValidateios12Action");
        return NO;
    }
}

- (UIImage *)imageConvert:(CMSampleBufferRef)sampleBuffer {
    if (!CMSampleBufferIsValid(sampleBuffer)) {
        return nil;
    }
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    return image;
}
#pragma mark - settings from setting
-(BOOL)eanblePublish{
    return [self.settingModel eanblePublish];
}
-(BOOL)eanbleSubscribe{
    return [self.settingModel eanbleSubscribe];
}
#pragma mark - invite
-(BOOL)enableInviteAfterCreateRoom{
    return [self.settingModel eanbleInviteAfterCreateRoom];
}
-(void)invite{
    NSString* inviteeUid = [self.settingModel inviteeUid];
    if(!inviteeUid){
        [self showToastWith:@"Invitee uid is not set in settings." duration:1.0];
        return;
    }
    ARTVCInviteParams* inviteParams = [[ARTVCInviteParams alloc] init];
    inviteParams.inviteType = ARTVCInviteTypeWebsocket;
    inviteParams.inviteeUid = inviteeUid;
    
    [_artvcEgnine inviteWith:inviteParams complete:^(NSError * _Nullable error) {
        if(!error) return;
        NSString* err = [NSString stringWithFormat:@"Invite failed,%@",error];;
        [self showToastWith:err duration:1.0];
    }];
        
}
#pragma mark - landscape

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        APM_INFO(@"viewWillTransitionToSize:withTransitionCoordinator: begin");
        CGFloat navigatorHeight = self.navigationController.navigationBar.frame.size.height;
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.cWidth = self.view.frame.size.width - (2 * margin10);
        self.cHeight = self.view.frame.size.height - (2 * margin10) - navigatorHeight - statusBarHeight;
        self.collectionView.frame = self.view.frame;
        self.roomInfoView.frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 20);
        self.controlView.frame = self.view.frame;
#ifdef ARTVC_ENABLE_STATS
        self.debugView.frame = self.view.frame;
#endif
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        APM_INFO(@"viewWillTransitionToSize:withTransitionCoordinator: end");
    }];
}

-(void)changeToLandScape{
    APM_INFO(@"attemptRotationToDeviceOrientation begin");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:@selector(setOrientation:)]];
    invocation.selector = NSSelectorFromString(@"setOrientation:");
    invocation.target = [UIDevice currentDevice];
    int initOrientation = UIDeviceOrientationLandscapeLeft; \
    // 这里我们需要传的值是设备方向值
    [invocation setArgument:&initOrientation atIndex:2];
    [invocation invoke];
    [[self class] attemptRotationToDeviceOrientation ];
    APM_INFO(@"attemptRotationToDeviceOrientation end");
}
#pragma mark - loopback test
-(ARTVCFeed*)feedForLoopbackTest{
    ARTVCFeed* feed = [[ARTVCFeed alloc] init];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Class cls = NSClassFromString(@"ARTVCLocalFeedHelper");
    NSString* __unsafe_unretained realFeedId;
    SEL sel_shareInstance = @selector(sharedInstance);
    SEL sel = @selector(realStreamIdWithLocalFeedId:);
    id sharedInstance;
    if(cls && sel_shareInstance && [cls  respondsToSelector:sel_shareInstance]){
        sharedInstance = [cls performSelector:sel_shareInstance];
    }
    if(sharedInstance && [sharedInstance respondsToSelector:sel]){
        NSMethodSignature *sig = [sharedInstance methodSignatureForSelector:sel];
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
        [invoke setTarget:sharedInstance];
        [invoke setSelector:sel];
        NSString* localFeedId = self.defaultLocalFeed.feedId;
        [invoke setArgument:&localFeedId atIndex:2];
        [invoke invoke];
#pragma clang diagnostic pop
        [invoke getReturnValue:&realFeedId];
        //to prevent crash
        NSString* realFeedIdStrong = realFeedId;
        feed.feedId = realFeedIdStrong;
        feed.uid = self.defaultLocalFeed.uid;
        feed.feedType = ARTVCFeedTypeRemoteFeed;
        feed.tag = self.defaultLocalFeed.tag;
    }
    APM_INFO(@"feedForLoopbackTest:%@",feed);
    return feed;
}
-(ARTVCSubscribeOptions*)subscribeOptionsForLoopbackTest{
    ARTVCSubscribeOptions* options = [[ARTVCSubscribeOptions alloc] init];
    return options;
}
-(void)startLoopbackTestIfAllowed{
    if(![self.settingModel isLoopbackTestEnabled]) return;
    
    ARTVCFeed* feedForLoopback = [self feedForLoopbackTest];
    [self initializeLoopbackTest:@[feedForLoopback]];
    ARTVCSubscribeConfig* config = [[ARTVCSubscribeConfig alloc] init];
    config.feed = feedForLoopback;
    config.options = [self subscribeOptionsForLoopbackTest];
    [NSThread sleepForTimeInterval:0.2f];
    [self.artvcEgnine subscribe:config];
}
-(void)initializeLoopbackTest:(NSArray<ARTVCFeed*>*)feeds{
    if(!feeds || feeds.count <= 0) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL sel_feedCenter = @selector(feedCenter);
    SEL sel_addRemoteFeeds = @selector(addRemoteFeeds:);
    id feedCenter;
    if([self.artvcEgnine  respondsToSelector:sel_feedCenter]){
        feedCenter = [self.artvcEgnine performSelector:sel_feedCenter];
    }
    if(feedCenter && [feedCenter respondsToSelector:sel_addRemoteFeeds]){
        NSMethodSignature *sig = [feedCenter methodSignatureForSelector:sel_addRemoteFeeds];
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
        [invoke setTarget:feedCenter];
        [invoke setSelector:sel_addRemoteFeeds];
        [invoke setArgument:&feeds atIndex:2];
        [invoke invoke];
#pragma clang diagnostic pop
    }
}
#ifdef ARTVC_BUILD_FOR_MPAAS
-(void)setMpaasServerUrlIfNeed{
    NSString* url = self.serverUrl;
    if(!url || url.length <= 0){
        return;
    }
    //NSString* url = @"wss://cn-hangzhou-mrtc.cloud.alipay.com/ws";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL sel = @selector(setRoomServerCustomUrl:);
    if([self.artvcEgnine  respondsToSelector:sel]){
        NSMethodSignature *sig = [self.artvcEgnine methodSignatureForSelector:sel];
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
        [invoke setTarget:self.artvcEgnine];
        [invoke setSelector:sel];
        [invoke setArgument:&url atIndex:2];
        [invoke invoke];
    }
#pragma clang diagnostic pop
}
#endif
@end

#endif
#endif
