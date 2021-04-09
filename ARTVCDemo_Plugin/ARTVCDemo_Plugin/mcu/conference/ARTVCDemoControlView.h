//
//  AMControlView.h
//  AntMedia
//
//  Created by aspling on 2017/8/3.
//  Copyright © 2017年 aspling. All rights reserved.
//
#import <UIKit/UIKit.h>
@class ARTVCDemoControlView;
@protocol ARTVCDemoControlViewDelegate <NSObject>
@optional
-(void)didSnapshotTriggled:(ARTVCDemoControlView*)view;
-(void)didSwitchCameraTriggled:(ARTVCDemoControlView*)view;
-(void)didDisconnectTriggled:(ARTVCDemoControlView*)view;
-(void)didEnableCameraTriggled:(ARTVCDemoControlView*)view stop:(BOOL)stop;
-(void)didMuteMicophoneTriggled:(ARTVCDemoControlView*)view mute:(BOOL)mute;
-(void)didSwithAudioPlaymodeTriggled:(ARTVCDemoControlView*)view;
-(void)didSwithEncodeResolutionTriggled:(ARTVCDemoControlView*)view;
-(void)didScreenshareTriggled:(ARTVCDemoControlView*)view;
-(void)didDegradationPreferenceTriggled:(ARTVCDemoControlView*)view;
-(void)didBroadCastTriggled:(ARTVCDemoControlView*)view;
@end
@interface ARTVCDemoControlView : UIView
@property(nonatomic,weak) id<ARTVCDemoControlViewDelegate> delegate;
@property(nonatomic,copy)NSString* roomId;
@property(nonatomic,copy)NSString* rtoken;
@property(nonatomic,copy)NSString* uid;
-(void)canResolutionScaleUp:(BOOL)can;
@end
