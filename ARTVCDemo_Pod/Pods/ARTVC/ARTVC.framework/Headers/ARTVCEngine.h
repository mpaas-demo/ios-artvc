//
//  ARTVCEngine.h
//  sources
//
//  Created by klaus on 2019/9/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RTCMacros.h"
#import "ARTVCCommonDefines.h"
#import "ARTVCParams.h"
#import "ARTVCCommon2.h"
#import "APMNetworkStatusManager.h"
#import "ARTVCRealtimeStatisticSummary.h"
#import "ARTVCCustomVideoCapturer.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * callcak at main-thread.
 *
 * about ARTVCFeed,always using [feed1 isEqual:feed2]  to make sure whether two ARTVCFeed objects are equal.don't use format of that if( feed1 == feed2).
 *
 * about ARTVCPublishConfig,always using [config1 isEqual:config2]  to make sure whether two ARTVCPublishConfig objects are equal.don't use format of that if( config1 == config2).
 */
XRTC_OBJC_EXPORT
@protocol ARTVCEngineDelegate <NSObject>
@required
//create/join/leave room relative
/**
 *  callback when createRoom successfully,cointains roomId and rtoken with that others  can join the room.
 */
-(void)didReceiveRoomInfo:(ARTVCRoomInfomation*)roomInfo;
/**
 local feed is generated.diffrent feed with diffrent feedType.
 for example,
 if feed is relative to builtin camera or audio only,feedType is ARTVCFeedTypeLocalFeedDefault
 if feed is relative to custom video capture,feedType is ARTVCFeedTypeLocalFeedCustomVideo
 if feed is relative to screen video capture,feedType is ARTVCFeedTypeLocalFeedScreenCapture
 
 with  this feed,you can handle events for diffrent streams
 1) view render events
 2) publish status events,e.g.
 */
-(void)didReceiveLocalFeed:(ARTVCFeed*)localFeed;
/**
 * connection status has changed.
 * if feed is nil .means the error is not about any specific feed.,it's a global error.
 * error code see ARTVCErrorCode
 */
@required
- (void)didEncounterError:(NSError *)error forFeed:(ARTVCFeed*)feed;
/**
 * connection status has changed.
 *  under ARTVCConnectionStatusDisConnected status,it may be changed to ARTVCConnectionStatusConnected later,retrying is done automatically.
 *  ARTVCConnectionStatusFailed/ARTVCConnectionStatusClosed means  a final status.without retrying anymore.
*/
- (void)didConnectionStatusChangedTo:(ARTVCConnectionStatus)status forFeed:(ARTVCFeed*)feed;
/**
 * video render view has been created for the given feed.,but the first video frame has not been rendered yet
 * you can put |renderView| to your layout.
 * if feed.uid is the uid yourself. renderView is the local preview of camara.
 */
- (void)didVideoRenderViewInitialized:(UIView*)renderView forFeed:(ARTVCFeed*)feed;
/**
 * fist video frame has been rendered for the given feed.
*/
- (void)didFirstVideoFrameRendered:(UIView*)renderView forFeed:(ARTVCFeed*)feed;
/**
 * video rendering has been stopped for the given feed.
*/
- (void)didVideoViewRenderStopped:(UIView*)renderView forFeed:(ARTVCFeed*)feed;
@optional
/**
 * video size  changed for the given feed and relative rendering view.
*/
- (void)didVideoSizeChangedTo:(CGSize)size renderView:(UIView*)renderView forFeed:(ARTVCFeed*)feed;
//notify from server about participant activity
/**
   somebody(not yourself) has entered the room
 */
@required
-(void)didParticepantsEntered:(NSArray<ARTVCParticipantInfo*>*)participants;
@optional
/**
   somebody(not yourself) has left the room
 */
-(void)didParticepantsLeft:(NSArray<ARTVCParticipantInfo*>*)participants DEPRECATED_MSG_ATTRIBUTE("replace by didParticepant:leaveRoomWithReason:");
@required
/**
   somebody(not yourself) has left the room
 */
-(void)didParticepant:(ARTVCParticipantInfo*)participant leaveRoomWithReason:(ARTVCParticipantLeaveRoomReasonType)reason;
/**
 * some participant has published a new feed
 * if you are interested about this feed,you can subscribe it .
 * with autoPublish/autoSubscribe setting to YES,opetations above happens automatically.
*/
-(void)didNewFeedAdded:(ARTVCFeed*)feed;
/**
 * some participant has unpublished a existing feed
 * if you have subscribed this feed, you may unsubscribe it .
 * with autoPublish/autoSubscribe setting to YES,opetations above happens automatically.
*/
-(void)didFeedRemoved:(ARTVCFeed*)feed;

@optional
/**
 joinroom success
 */
-(void)didJoinroomSuccess;
/**
it's a notification about participant's activity.
normally,it's useless. though,you can handle it if it's interest to you .
*/
-(void)didSubscriber:(NSString*)subscriber subscribedAFeed:(ARTVCFeed*)feed;
/**
it's a notification about participant's activity.
normally,it's useless. though,you can handle it if it's interest to you .
*/
-(void)didSubscriber:(NSString*)subscriber unsubscribedAFeed:(ARTVCFeed*)feed ;
/**
 * audio playmode has been changed
 */
- (void)didAudioPlayModeChangedTo:(ARTVCAudioPlayMode)audioPlayMode;
/**
 * 网络发生了变更（譬如wifi切换到cellular）
 * 首次启动时通常会回调一次，
 * 1.返回的网络类型为APMNetReachabilityStatusReachableViaWiFi时业务可考虑不做处理；
 * 2.返回的网络类型为cellular（APMNetReachabilityStatusReachableViaWWAN/APMNetReachabilityStatusReachableViaWWAN2G/3G/4G）时业务可考虑提示用户当前网络为移动网络，会使用移动网络数据进行视频通话；
 */
- (void)didNetworkChangedTo:(APMNetworkReachabilityStatus)netStatus;
/**
 * 呼叫当前可发送网络带宽变化，isLow为YES表示带宽不够（业务可做通话质量不佳的提示），isLow为NO表示带宽足够（业务可取消通话质量不佳的提示）,bw为当前可用发送带宽,单位bps
 * 呼叫过程中，视网络质量而定，可能会回调多次。
 */
- (void)didAvailabeSendBandwidthBecomeLow:(BOOL)isLow currentBandwidth:(double)bw forFeed:(ARTVCFeed*)feed;
/**
 realtime statistic summary is generated,you can send this summary to statistic server.
 */
- (void)didRealtimeStatisticGenerated:(ARTVCRealtimeStatisticSummary*)summary forFeed:(ARTVCFeed*)feed;
/**
 brief debug information is generated(including bitrate/cpu/codec,e.g.),you can show this on your debug information view.
 */
- (void)didBriefDebugInformationGenerated:(NSString*)summary forFeed:(ARTVCFeed*)feed;
/**
 *  callback when recordId is returned.with recordId ,you can locate the recorded file in remote server.
 */
-(void)didReceiveRecordId:(NSString*)recordId;
/**
 receive a message from a participant in the room
 */
- (void)didReceiveIMMessage:(ARTVCIMMessage*)message fromParticipant:(NSString*)participant;
/**
 when peer reply the invite message,reply's status is callbacked with this .
 */
- (void)didParticipant:(NSString*)participant replyWith:(ARTVCReplyType)replyType roomId:(NSString*)roomId;
/**
 export camera sample buffer
 callback at capture session's queue,not main-thread.
 */
- (void)didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
/**
 receive this callback under these scenarios:
 1. cellular call connected
 2. dialing a cellular call
 3. other audio session interruption happened(like alarm clock),and not receiving interruption end event after some time,for now ,it's configed to 8 seconds.
 */
- (void)callWillBeClosedAsInterruptionHappened;
@end

XRTC_OBJC_EXPORT
@interface ARTVCEngine : NSObject
@property(nonatomic,weak) id<ARTVCEngineDelegate> delegate;
@property(nonatomic,weak) id<ARTVCDynamicConfigProtocol> dynamicConfigProxy;
//MUST be set beforel calling any instance method of ARTVCEngine.
@property(nonatomic,copy) NSString* uid;
#ifndef ARTVC_BUILD_FOR_MPAAS
//default is online. if set to ARTVCRoomServerType_Custom,then roomServerCustomUrl MUST be setted.
@property(nonatomic,assign) ARTVCRoomServerType roomServerType;
//if roomServerType is ARTVCRoomServerType_Custom,MUST set roomServerCustomUrl here.
@property(nonatomic,copy) NSString* roomServerCustomUrl;
#endif

/**
 set it before startCameraPreviewUsingBackCamera
 default is ARTVCVideoProfileType_640x360_15Fps.
 
 during life time of the call,you call set this param multi times on demand of controlling the encoded resolution and camera's output fps.
 
 Attention!!!! it only takes effect on videoSource of ARTVCVideoSourceType_Camera
 */
@property(nonatomic,assign) ARTVCVideoProfileType videoProfileType;
//!!! can only set to ARTVCAudioPlayModeSpeaker or  ARTVCAudioPlayModeReceiver,default is ARTVCAudioPlayModeInit.
// if not setting this param,for video-call,default audio port is speaker
// if not setting this param,for audio-call,default audio port is receiver
// set it befor calling create/join call
@property (nonatomic,assign) ARTVCAudioPlayMode expectedAudioPlayMode;
//default is YES
//Attention!!!! it only takes effect on videoSource of ARTVCVideoSourceType_Camera
//if videosouce is not ARTVCVideoSourceType_Camera,auto publish is not supported for now.
@property(nonatomic,assign,getter=isAutoPublish) BOOL autoPublish;
//default is YES
@property(nonatomic,assign,getter=isAutoSubscribe) BOOL autoSubscribe;
/**
 config for auto publish
 if you ignore setting this,it will use the default valuve when under autopublish mode.
 
 Attention!!!! it only takes effect on videoSource of ARTVCVideoSourceType_Camera
 if videosouce is not ARTVCVideoSourceType_Camera,auto publish is not supported for now.
 */
@property(nonatomic,strong) ARTVCPublishConfig* autoPublishConfig;
/**
 options for auto subscribe
 if you ignore setting this,it will use the default valuve when under autosubscribe mode.
 */
@property(nonatomic,strong) ARTVCSubscribeOptions* autoSubscribeOptions;
/**
 current config for publish
 default value isEqual with autoPubishConfig.
 if you call publish: API ,the currentPublishConfig will be set to the config passed to publish: API.
 
 Attention!!!! it only takes effect on videoSource of ARTVCVideoSourceType_Camera
 if videosouce is not ARTVCVideoSourceType_Camera,auto publish is not supported for now.
 */
@property(nonatomic,copy,readonly) ARTVCPublishConfig* currentPublishConfig;
/**
 current env type
 updated when joinRoom called.
 */
@property(nonatomic,assign,readonly) ARTVCEnvType currentEnvType;
//it's thread-safe .set on-demand.
//support setting after camera has started.
//if this swtich is ON,CMSampleBufferRef is callbacked through didOutputSampleBuffer:.
//format is NV12,kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
//defualt is NO;
@property(nonatomic,assign) BOOL enableCameraRawSampleOutput;
#pragma mark - view relative
#ifdef ARTVC_ENABLE_STATS
- (UIView*)debugView;
#endif
#pragma mark - room relative
/**
 create a room for video-call or video-broadcast.
 */
-(void)createRoom:(ARTVCCreateRoomParams*) params;
/**
join a room for video-call or video-broadcast.
*/
-(void)joinRoom:(ARTVCJoinRoomParams*) params;
/**
leave the room you created or joined.
 if there is publish/subscribe operation,it will firstly unpublish/unsubscribe it ,then leave the room finally.
*/
-(void)leaveRoom;

#pragma mark - invite/reply
/**
 you can call this API after room created successfully.
  if timeout,callback ARTVCReplyTypeTimeout through didParticipant: replyWith: roomId:
 if server error happens,callback ARTVCErrorCodeProtocolErrorInviteFailed through didEncounterError:forFeed:,with feed equals to nil.
 callback at arbitrary thread.
 */
-(void)inviteWith:(ARTVCInviteParams*)params complete:(ARTVCInviteCallback)complete;
/**
 when incoming call notification receivced,you MUST call this API to reply the invitation.
 if server error happens,callback ARTVCErrorCodeProtocolErrorReplyFailed through didEncounterError:forFeed:,with feed equals to nil.
 callback at arbitrary thread.
 */
-(void)replyWith:(ARTVCReplyParams*)params complete:(ARTVCReplyCallback)complete;

#pragma mark - publish subscribe
/**
 publish  to feed server ,with the specified config.
 if you have set autoPublish to YES,there is no need for calling this.SDK will publish automatically when you create/join a room successfully.
 
 Attention!!!! it only takes effect on videoSource of ARTVCVideoSourceType_Camera
 if videosouce is not ARTVCVideoSourceType_Camera,auto publish is not supported for now.
 
 the feed generated by this call will callback through -didReceiveLocalFeed:forPublishConfig: with the return feed,you can use it for unpublish.
 */
-(void)publish:(ARTVCPublishConfig*)config;
/**
 unpublish  from feed server ,with the specified config.
*/
-(void)unpublish:(ARTVCUnpublishConfig*)config;
/**
 subscribe feed from feed server ,with the specified config.
 if you have set autoSubscribe to YES,there is no need for calling this.SDK will subscribe automatically when there is new feed generated..
 with the return value,you can use it for unpublish.
*/
-(void)subscribe:(ARTVCSubscribeConfig*)config;
/**
 unsubscribe  from feed server ,with the specified config.
*/
-(void)unsubscribe:(ARTVCUnsubscribeConfig*)config;

#pragma mark - camera capture
/**
  start camera capture.
  set usingBackCamera to YES,means using the back camera for capturing.e.g.
 
  the feed generated by this call will callback through -didReceiveLocalFeed:forPublishConfig:
 
  the feed callbacked ,can be used in callback of - (void)didVideoRenderViewInitialized:(UIView*)renderView forFeed:(ARTVCFeed*)feed;
  
 Attention !!!!
   Before calling this,you MUST has set autoPublishConfig correctly.
 1.localFeed for camera callbacked through -didReceiveLocalFeed:forPublishConfig: whose config is actually the autoPublishConfig
 2.if autoPublish is disabled.Please make sure autoPublishConfig is equal with the config passed to publish: method. it's a ugly design here.May change the design later,but for now ,please do as above. otherwise,you will recevice localFeed twice with different publishConfig.
*/
-(void)startCameraPreviewUsingBackCamera:(BOOL)usingBackCamera;
/**
  stop camera capture ,
  scenario 1:
  there is local camera feed published,  camera capture stopped ,meantime,it  will not remove the render view for preview.so when you call startCameraPreviewUsingBackCamera: again,you WON'T receive callback didVideoRenderViewInitialized: forFeed:
 
  scenario 2:
  there is NO local camera feed published,  camera capture stopped ,meantime,it  will  remove the render view for preview.so when you call startCameraPreviewUsingBackCamera: again,you will receive callback didVideoRenderViewInitialized: forFeed:
*/
-(void)stopCameraPreview;
/**
  switch camera.
*/
-(void)switchCamera;
/**
 check current camera position is  back  or not,if true,return YES.
 */
-(BOOL)currentCameraPositionIsBack;

#pragma mark - Screen capture
/**
 check if screen capure supported.only supported iOS 11 and above.
 */
-(BOOL)isScreenCaptureSupported;
/**
 check if screen capture already started.if started ,you cann't call startScreenCaptureWithParams:complete API again before you call stopScreenCapture.
 */
-(BOOL)isScreenCaptureStarted;
/**
 start screen capture,only support iOS 11 and above.
 
 if set params.provideRenderView to YES,SDK will provide a render view for you .
 */
-(void)startScreenCaptureWithParams:(ARTVCCreateScreenCaputurerParams*)params complete:(ARTVCErrorCallback)callback;
/**
 stop screen capture
 */
-(void)stopScreenCapture;

#pragma mark - custom capture
/**
 you MUST set autoPublish to NO when using custom video capturer only,which means you won't be willing to use builtin camera for publishing another new local stream.
 
 1.create a logic custom video capturer
 2.you can call capturer's method to provide video frame to SDK
 3.before calling this,you MUST set uid first
 4.if params.provideRenderView is YES,you will receive :
 1) a local feed callback through (void)didReceiveLocalFeed:(ARTVCFeed*)localFeed
 2) a render view callback through - (void)didVideoRenderViewInitialized:(UIView*)renderView forFeed:(ARTVCFeed*)feed,whose feed is equalt with the local feed you received from the callback above.
 */
-(ARTVCCustomVideoCapturer*)createCustomVideoCapturer:(ARTVCCreateCustomVideoCaputurerParams*)params;
/*
 1.destroy custom video capturer
 2.delete the view associated with capturer
 */
-(void)destroyCustomVideoCapturer;
#pragma mark - mute operation
/**
  mute the  video of feed
  black frames will be rendered.you won't see the real image of that feed.
*/
-(void)muteRemoteVideo:(BOOL)muted forFeed:(ARTVCFeed*)feed;
/**
  mute all the  videos of remote feeds
  black frames will be rendered.you won't see the real image of that feed.
*/
-(void)muteAllRemoteVideos:(BOOL)muted;
/**
  mute the  microphone
*/
-(void)muteMicrophone:(BOOL)muted;
/**
  mute the  audio of feed
  the audio from remote feed will be silenced. you won't hear any voice from that feed.
*/
-(void)muteRemoteAudio:(BOOL)muted forFeed:(ARTVCFeed*)feed;
/**
  mute all the  audios of remote feeds
  the audio from remote feed will be silenced.you won't hear any voice from that feed.
*/
-(void)muteAllRemoteAudios:(BOOL)muted;

#pragma mark - snapshot
/**
  snapshot for given feed,getting the image from the rendering view.
  if the given feed isEqual to the feed returned by startCameraPreviewUsingBackCamera:,it means getting the snapshot from the  camera locally.
  callback at arbitrary thread.
 */
-(void)snapshotForFeed:(ARTVCFeed*)feed complete:(void(^)(UIImage* image))complete;
#pragma mark - audio play mode
/**
 * 当前声音播放模式
 */
- (ARTVCAudioPlayMode)currentAuidoPlayMode;
/**
 * 切换听筒扬声器模式,耳机模式下不处理
 * ARTVCAudioPlayModeReceiver模式下可以切换到ARTVCAudioPlayModeSpeaker
 * ARTVCAudioPlayModeSpeaker模式下可以切换到ARTVCAudioPlayModeReceiver
 * 入参为ARTVCAudioPlayModeInit和ARTVCAudioPlayModeHeadphone不处理。回调错误。
 */
- (void)switchAudioPlayModeTo:(ARTVCAudioPlayMode)audioPlayMode complete:(void (^_Nullable)(NSError*_Nullable error))callback;
#pragma mark - IM
/**
 send text message to a specified pariticipant
 */
- (void)sendMessage:(ARTVCIMMessage*)message toPariticipant:(NSString*)pariticipant complete:(ARTVCIMCallback)complete;
/**
 send text message to many pariticipants in the room.nil means to all pariticipants in the room.
 */
-(void)sendMessage:(ARTVCIMMessage*)message toPariticipants:(NSArray<NSString*>*)pariticipants complete:(ARTVCIMCallback)complete;

#pragma mark - dynamic change encode resolution and fps
/**
 dynamic change encode resolution and fps,which is decided by newType
 for exmaple:
 1.change camera encode resolution to a new one,you can set targetVideoSrouce to ARTVCVideoSourceType_Camera
 2.change custom encode resolution to a new one,you can set targetVideoSrouce to ARTVCVideoSourceType_Custom
 3.e.g.
 */
-(void)changeVideoProfileTo:(ARTVCVideoProfileType)newType forVideoSource:(ARTVCVideoSourceType)targetVideoSrouce;

@end
NS_ASSUME_NONNULL_END
