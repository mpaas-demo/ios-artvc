//
//  AMControlView.m
//  AntMedia
//
//  Created by aspling on 2017/8/3.
//  Copyright © 2017年 aspling. All rights reserved.
//
#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
#import "ARTVCDemoControlView.h"
#import <APMUtils/APMLog.h>
#define HangupButtonWidth 58
#define HangupButtonHeight 58
#define ButtonWidth 36
#define ButtonHeight 36
#define ButtonsMargin 8
#define BottomMargin 168
@interface ARTVCDemoControlView()
@property(nonatomic, strong)UIButton *switchCameraBtn;
@property(nonatomic, strong)UIButton *hangupBtn;
@property(nonatomic, strong)UIButton *muteMicrophoneBtn;
@property(nonatomic, strong)UIButton *enableCameraBtn;
@property(nonatomic, strong)UIButton *audioPlaymodeBtn;
@property(nonatomic, strong)UIButton *snapshotBtn;
@property(nonatomic, strong)UIButton *switchEncodeResoBtn;
@property(nonatomic, strong)UIButton *screenshareBtn;
@property(nonatomic, strong)UILabel *info;
@property(nonatomic, assign)BOOL cameraStopped;
@property(nonatomic, assign)BOOL muted;
@end
@implementation ARTVCDemoControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor blackColor]];
        self.alpha = 0.3;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        self.info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        //self.info.text = @"xx";
        self.info.textColor = [UIColor greenColor];
        self.info.lineBreakMode = NSLineBreakByWordWrapping;
        self.info.numberOfLines = 0;
        self.info.center = self.center;
        
        self.switchCameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.switchCameraBtn.frame = frame;
        UIImage *image = ARTVCShowImageResource(@"switchcamera.png");
        [self.switchCameraBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.switchCameraBtn addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
        
        self.hangupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(width/2-HangupButtonWidth/2, height-BottomMargin, HangupButtonWidth, HangupButtonHeight);
        self.hangupBtn.frame = frame;
        image = ARTVCShowImageResource(@"callvideo_hangup.png");
        [self.hangupBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.hangupBtn addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
        
        self.muteMicrophoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.muteMicrophoneBtn.frame = frame;
        image = ARTVCShowImageResource(@"mute.png");
        [self.muteMicrophoneBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.muteMicrophoneBtn addTarget:self action:@selector(muteMicrophone:) forControlEvents:UIControlEventTouchUpInside];
        _muted = NO;
        
        self.enableCameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.enableCameraBtn.frame = frame;
        image = ARTVCShowImageResource(@"camera.png");
        [self.enableCameraBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.enableCameraBtn addTarget:self action:@selector(enableCamera:) forControlEvents:UIControlEventTouchUpInside];
        _cameraStopped = NO;
        
        self.snapshotBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.snapshotBtn.frame = frame;
        image = ARTVCShowImageResource(@"snapshot.png");
        [self.snapshotBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.snapshotBtn addTarget:self action:@selector(snapshot:) forControlEvents:UIControlEventTouchUpInside];
        
        self.audioPlaymodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.audioPlaymodeBtn.frame = frame;
        image = ARTVCShowImageResource(@"speaker.png");
        [self.audioPlaymodeBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.audioPlaymodeBtn addTarget:self action:@selector(switchAudioPlaymode:) forControlEvents:UIControlEventTouchUpInside];
        
        self.switchEncodeResoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.switchEncodeResoBtn.frame = frame;
        image = ARTVCShowImageResource(@"up.png");
        [self.switchEncodeResoBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.switchEncodeResoBtn addTarget:self action:@selector(switchEncodeResolution:) forControlEvents:UIControlEventTouchUpInside];
        
        self.screenshareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        self.screenshareBtn.frame = frame;
        image = ARTVCShowImageResource(@"screenshare.png");
        [self.screenshareBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.screenshareBtn addTarget:self action:@selector(screenshare:) forControlEvents:UIControlEventTouchUpInside];
        
        _cameraStopped = NO;
        
        _switchCameraBtn.center = CGPointMake(_hangupBtn.center.x-HangupButtonWidth/2-ButtonWidth/2-ButtonsMargin/2, _hangupBtn.center.y);
        _enableCameraBtn.center = CGPointMake(_switchCameraBtn.center.x-ButtonWidth-ButtonsMargin, _switchCameraBtn.center.y);
        _snapshotBtn.center = CGPointMake(_enableCameraBtn.center.x-ButtonWidth-ButtonsMargin, _enableCameraBtn.center.y);
        _muteMicrophoneBtn.center = CGPointMake(_hangupBtn.center.x+HangupButtonWidth/2+ButtonWidth/2+ButtonsMargin, _hangupBtn.center.y);
        _audioPlaymodeBtn.center = CGPointMake(_muteMicrophoneBtn.center.x+ButtonWidth+ButtonsMargin, _muteMicrophoneBtn.center.y);
        _switchEncodeResoBtn.center = CGPointMake(_audioPlaymodeBtn.center.x+ButtonWidth+ButtonsMargin, _audioPlaymodeBtn.center.y);
        _screenshareBtn.center = CGPointMake(_switchEncodeResoBtn.center.x+ButtonWidth+ButtonsMargin, _switchEncodeResoBtn.center.y);
        
        [self addSubview:_info];
        [self addSubview:_switchCameraBtn];
        [self addSubview:_hangupBtn];
        [self addSubview:_muteMicrophoneBtn];
        [self addSubview:_audioPlaymodeBtn];
        [self addSubview:_enableCameraBtn];
        [self addSubview:_snapshotBtn];
        [self addSubview:_switchEncodeResoBtn];
        [self addSubview:_screenshareBtn];
        
    }
    return self;
}
-(void)dealloc{
    APM_INFO(@"ARTVCDemoControlView dealloc");
}
-(void)setRoomId:(NSString *)roomId{
    @synchronized (self) {
        _roomId = roomId;
        [self updateInfo];
    }
}
-(void)setUid:(NSString *)uid{
    @synchronized (self) {
        _uid = uid;
        [self updateInfo];
    }
}
-(void)setRtoken:(NSString *)rtoken{
    @synchronized (self) {
        _rtoken = rtoken;
        [self updateInfo];
    }
}
-(void)updateInfo{
    __weak ARTVCDemoControlView* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong ARTVCDemoControlView *strongself = weakSelf;
        strongself.info.text = [NSString stringWithFormat:@"roomId:%@ \rrtoken:%@\ruid:%@",_roomId,_rtoken,_uid];
        //[strongself.info sizeToFit];
    });
}
-(void)canResolutionScaleUp:(BOOL)can{
    UIImage* image;
    if(can){
        image = ARTVCShowImageResource(@"up.png");
        [self.switchEncodeResoBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        image = ARTVCShowImageResource(@"down.png");
        [self.switchEncodeResoBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
}
#pragma mark - UI Event handlers
-(void)switchCamera:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _switchCameraBtn){
        return;
    }
    [self.delegate didSwitchCameraTriggled:self];
}

-(void)enableCamera:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _enableCameraBtn){
        return;
    }
    [self.delegate didEnableCameraTriggled:self stop:!_cameraStopped];
    _cameraStopped = !_cameraStopped;
    UIImage *image;
    if(_cameraStopped){
        image = ARTVCShowImageResource(@"camera.png");
    }else{
        image = ARTVCShowImageResource(@"camera.png");
    }
    [_enableCameraBtn setBackgroundImage:image forState:UIControlStateNormal];
}
-(void)snapshot:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _snapshotBtn){
        return;
    }
    [self.delegate didSnapshotTriggled:self];
}
-(void)disconnect:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _hangupBtn){
        return;
    }
    [self.delegate didDisconnectTriggled:self];
}

-(void)muteMicrophone:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _muteMicrophoneBtn){
        return;
    }
    [self.delegate didMuteMicophoneTriggled:self mute:!_muted];
    _muted = !_muted;
    UIImage *image;
    if(_muted){
        image = ARTVCShowImageResource(@"notmute.png");
    }else{
        image = ARTVCShowImageResource(@"mute.png");
    }
    [_muteMicrophoneBtn setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)switchAudioPlaymode:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _audioPlaymodeBtn){
        return;
    }
    [self.delegate didSwithAudioPlaymodeTriggled:self];
}
-(void)switchEncodeResolution:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _switchEncodeResoBtn){
        return;
    }
    [self.delegate didSwithEncodeResolutionTriggled:self];
}
-(void)screenshare:(id)sender{
    UIButton *bt = (UIButton*)sender;
    if(bt != _screenshareBtn){
        return;
    }
    [self.delegate didScreenshareTriggled:self];
}
@end
#endif
#endif
