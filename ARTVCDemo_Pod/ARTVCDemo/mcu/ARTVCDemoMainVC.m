//
//  RootViewController.m
//  AntMedia
//
//  Created by aspling on 2017/3/9.
//  Copyright © 2017年 aspling. All rights reserved.
//
//#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
#import "ARTVCDemoMainVC.h"
#import <CoreGraphics/CGGeometry.h>
//#import "ARTVCDemoP2pVC.h"
#import "settings/ARTVCDemoSettingsVC.h"
#import "settings/ARTVCDemoSettingsModel.h"
#import "conference/ARTVCDemoConferenceVC.h"
#import <APMUtils/APMLog.h>
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "
@interface ARTVCDemoMainVC ()<UITextFieldDelegate>
@property (strong, nonatomic)  UITextField *roomEdittext;
@property (strong, nonatomic)  UITextField *tokenEdittext;
@property (strong, nonatomic)  UITextField *audioOnlyText;
@property (strong, nonatomic)  UITextField *p2pCallText;
@property (strong, nonatomic)  UITextField *broadcastText;
@property (strong, nonatomic)  UITextField *customVideoText;
@property (strong, nonatomic)  UITextField *onlyPubVideoText;
@property (strong, nonatomic)  UISwitch *audioSw;
@property (strong, nonatomic)  UISwitch *p2pSw;
@property (strong, nonatomic)  UISwitch *broadcastSw;
@property (strong, nonatomic)  UISwitch *customVideoSw;
@property (strong, nonatomic)  UISwitch *onlyPubVideoSw;
@property (strong, nonatomic)  UIButton *callButton;
@end

@implementation ARTVCDemoMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    self.title = @"视频通话";
    
    self.roomEdittext = [[UITextField alloc] initWithFrame:CGRectZero];
//    [self.roomEdittext becomeFirstResponder];
    [self.roomEdittext setBackgroundColor:[UIColor whiteColor]];
    self.roomEdittext.placeholder = @"enter roomID here";
    self.roomEdittext.borderStyle = UITextBorderStyleRoundedRect;
    self.roomEdittext.delegate = self;
    
    self.tokenEdittext = [[UITextField alloc] initWithFrame:CGRectZero];
//    [self.tokenEdittext becomeFirstResponder];
    [self.tokenEdittext setBackgroundColor:[UIColor whiteColor]];
    self.tokenEdittext.placeholder = @"enter token here";
    self.tokenEdittext.borderStyle = UITextBorderStyleRoundedRect;
    self.tokenEdittext.delegate = self;
    
    self.audioOnlyText = [[UITextField alloc] initWithFrame:CGRectZero];
    self.audioOnlyText.text = @"Audio-only Call";
    self.audioSw = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.audioSw setOn:NO];
    [self.audioSw setEnabled:YES];
    [self.audioSw addTarget:self action:@selector(audioOnlyChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    self.p2pCallText = [[UITextField alloc] initWithFrame:CGRectZero];
    self.p2pCallText.text = @"Test AliYun SDK";
    self.p2pSw = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.p2pSw setOn:NO];
    [self.p2pSw setEnabled:YES];
    
    self.broadcastText = [[UITextField alloc] initWithFrame:CGRectZero];
    self.broadcastText.text = @"Test Broadcast";
    self.broadcastSw = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.broadcastSw setOn:NO];
    [self.broadcastSw setEnabled:YES];
    
    self.customVideoText = [[UITextField alloc] initWithFrame:CGRectZero];
    self.customVideoText.text = @"Custom Video";
    self.customVideoSw = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.customVideoSw setOn:NO];
    [self.customVideoSw setEnabled:YES];
    
    self.onlyPubVideoText = [[UITextField alloc] initWithFrame:CGRectZero];
    self.onlyPubVideoText.text = @"Only Publish Video";
    self.onlyPubVideoSw = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.onlyPubVideoSw setOn:NO];
    [self.onlyPubVideoSw setEnabled:YES];
    [self.onlyPubVideoSw addTarget:self action:@selector(publishVideoOnlyChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    self.callButton = [[UIButton alloc] initWithFrame:CGRectZero];
    
//    UIImage *image = ARTVCImageResource(@"callvideo_answer");
    UIImage *image = ARTVCShowImageResource(@"callvideo_answer");
    NSString* url = [NSString stringWithFormat:@"MPARTVCDemo.bundle/image/%@", @"callvideo_answer"];
//    UIImage *image2 = [UIImage imageNamed:url];
    [self.callButton setBackgroundImage:image forState:UIControlStateNormal];
    self.callButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    UIImage* settingImage = ARTVCShowImageResource(@"tab_settings");
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:settingImage style:UIBarButtonItemStylePlain target:self action:@selector(presentSettingController)];
    [self.navigationItem setRightBarButtonItem:setting];
    [self.view addSubview:_roomEdittext];
    [self.view addSubview:_tokenEdittext];
    [self.view addSubview:_audioOnlyText];
    [self.view addSubview:_audioSw];
    [self.view addSubview:_p2pCallText];
    [self.view addSubview:_p2pSw];
    [self.view addSubview:_broadcastText];
    [self.view addSubview:_broadcastSw];
    [self.view addSubview:_customVideoText];
    [self.view addSubview:_customVideoSw];
    [self.view addSubview:_onlyPubVideoText];
    [self.view addSubview:_onlyPubVideoSw];
    [self.view addSubview:_callButton];
    [self layout];
}
-(void)dealloc{
    APM_INFO(@"ARTVCDemoMainViewController dealloc");
}
-(void)layout{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat startY = statusBarHeight+navigationBarHeight+10;
    CGFloat height4TxSw = 40;
    CGFloat margin = 5;
    CGFloat textWitdh = 200;
    CGFloat switchWitdh = 50;
    CGRect frame = CGRectMake(margin, startY, width-margin*2, height4TxSw);
    _roomEdittext.frame = frame;
    frame = CGRectMake(margin, startY+margin*1+height4TxSw*1, width-margin*2, height4TxSw);
    _tokenEdittext.frame = frame;
    frame = CGRectMake(margin, startY+margin*2+height4TxSw*2, textWitdh, height4TxSw);
    _audioOnlyText.frame = frame;
    frame = CGRectMake(width-switchWitdh-margin, _audioOnlyText.frame.origin.y, switchWitdh, height4TxSw);
    _audioSw.frame = frame;
    
    frame = CGRectMake(margin, _audioSw.frame.origin.y+height4TxSw+margin, textWitdh, height4TxSw);
    _p2pCallText.frame = frame;
    frame = CGRectMake(width-switchWitdh-margin, _p2pCallText.frame.origin.y, switchWitdh, height4TxSw);
    _p2pSw.frame = frame;
    
    frame = CGRectMake(margin, _p2pSw.frame.origin.y+height4TxSw+margin, textWitdh, height4TxSw);
    _broadcastText.frame = frame;
    frame = CGRectMake(width-switchWitdh-margin, _broadcastText.frame.origin.y, switchWitdh, height4TxSw);
    _broadcastSw.frame = frame;
    
    frame = CGRectMake(margin, _broadcastSw.frame.origin.y+height4TxSw+margin, textWitdh, height4TxSw);
    _customVideoText.frame = frame;
    frame = CGRectMake(width-switchWitdh-margin, _customVideoText.frame.origin.y, switchWitdh, height4TxSw);
    _customVideoSw.frame = frame;
    
    frame = CGRectMake(margin, _customVideoSw.frame.origin.y+height4TxSw+margin, textWitdh, height4TxSw);
    _onlyPubVideoText.frame = frame;
    frame = CGRectMake(width-switchWitdh-margin, _onlyPubVideoText.frame.origin.y, switchWitdh, height4TxSw);
    _onlyPubVideoSw.frame = frame;
    
    frame = CGRectMake((width-60)/2, height-90-statusBarHeight-navigationBarHeight, 60, 60);
    _callButton.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"视频通话";
    //ARTVC_ENABLE_DEMO_CONTINUS_IN_OUT
#if 0
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self makecall];
    });
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.roomEdittext resignFirstResponder];
    [self.tokenEdittext resignFirstResponder];
    return YES;
}

#pragma mark - private
- (void)call {
//    if (self.roomEdittext.text.length > 0) {
//        if (!self.tokenEdittext.text || self.tokenEdittext.text.length <= 0) {
//
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Parameters Error"
//                                                                           message:@"please input token"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
//            return;
//        }
//    }
//    if ( self.roomEdittext.text.length > 0 && self.tokenEdittext.text.length > 0) {
//    self.roomEdittext.text = @"222222";
//    self.tokenEdittext.text = @"123";
    if ( self.roomEdittext.text.length > 0 ) {
        [self joincall];
    } else {
        [self makecall];
    }
}

- (void)makecall {
#if defined(__arm64__)
    ARTVCDemoConferenceVC *vc = [[ARTVCDemoConferenceVC alloc] init];
    vc.audioOnly = [self.audioSw isOn];
    vc.publishVideoOnly = [self.onlyPubVideoSw isOn];
    vc.testBroadcast = [self.broadcastSw isOn];
    vc.testCustomVideoCapture = [self.customVideoSw isOn];
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

- (void)joincall {
#if defined(__arm64__)
    ARTVCDemoConferenceVC *vc = [[ARTVCDemoConferenceVC alloc] init];
    vc.roomId = self.roomEdittext.text;
    vc.rtoken = self.tokenEdittext.text;
//    vc.roomId = @"1031876";
//    vc.rtoken = @"123";
    vc.audioOnly = [self.audioSw isOn];
    vc.publishVideoOnly = [self.onlyPubVideoSw isOn];
    vc.testAliyunSDK = [self.p2pSw isOn];
    vc.testCustomVideoCapture = [self.customVideoSw isOn];
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

- (void)presentSettingController {
#if defined(__arm64__)
    ARTVCDemoSettingsVC *settingVc =
        [[ARTVCDemoSettingsVC alloc] initWithStyle:UITableViewStyleGrouped
                                           settingsModel:[[ARTVCDemoSettingsModel alloc] init]];
    [self.navigationController pushViewController:settingVc animated:YES];
#endif
}
-(void)audioOnlyChanged:(UIButton*)bt{
    if([self.audioSw isOn]){
        [self.onlyPubVideoSw setOn:NO];
    }
}
-(void)publishVideoOnlyChanged:(UIButton*)bt{
    if([self.onlyPubVideoSw isOn]){
        [self.audioSw setOn:NO];
    }
}

@end

#endif
//#endif
