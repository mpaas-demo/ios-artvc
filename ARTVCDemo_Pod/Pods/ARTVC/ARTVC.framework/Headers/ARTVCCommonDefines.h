//
//  ARTVCCommonDefines.h
//  sources
//
//  Created by klaus on 2019/9/23.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^ARTVCErrorCallback)(NSError*_Nullable error);

#ifndef ARTVC_BUILD_FOR_MPAAS
typedef NS_ENUM(int,ARTVCRoomServerType){
    ARTVCRoomServerType_Online    = 0,
    ARTVCRoomServerType_Dev       = 1,
    ARTVCRoomServerType_Test      = 2,
    ARTVCRoomServerType_PreOnline = 3,
    ARTVCRoomServerType_Sandbox   = 4,
    ARTVCRoomServerType_Custom    = 100,
};
#endif

typedef NS_ENUM(int,ARTVCRoomServiceType){
    /**
     for video-call
     */
    ARTVCRoomServiceType_RTC  = 2,
    /**
     for live-broadcast
     */
    ARTVCRoomServiceType_LIVE = 3,
};
typedef NS_ENUM(int,ARTVCEnvType){
    ARTVCEnvType_Alipay = 0,
    ARTVCEnvType_AliYun = 1,
};
typedef NS_ENUM(int,ARTVCVideoSourceType){
    //builtin camera
    ARTVCVideoSourceType_Camera          = 0,
    //screen sharing
    ARTVCVideoSourceType_Screen          = 1,
    //use custom video source
    ARTVCVideoSourceType_Custom          = 2,
    //means audio only
    ARTVCVideoSourceType_Null            = 99,
    //undefined video source type,it's an error type.used in SDK only,API Caller cann't set value to this.
    ARTVCVideoSourceType_Undefined_Error_UsedInternally = 100
};
typedef NS_ENUM(int,ARTVCVideoProfileType){
    /**
     encoded video resolution is 640x360,fps is 15
     */
    ARTVCVideoProfileType_640x360_15Fps   = 2,
    /**
    encoded video resolution is 640x360,fps is 30
    */
    ARTVCVideoProfileType_640x360_30Fps   = 3,
    /**
    encoded video resolution is 960x540,fps is 15
    */
    ARTVCVideoProfileType_960x540_15Fps   = 4,
    /**
    encoded video resolution is 960x540,fps is 30
    */
    ARTVCVideoProfileType_960x540_30Fps   = 5,
    /**
    encoded video resolution is 1280x720,fps is 15
    */
    ARTVCVideoProfileType_1280x720_15Fps  = 6,
    /**
    encoded video resolution is 1280x720,fps is 15
    */
    ARTVCVideoProfileType_1280x720_30Fps  = 7,
//    ARTVCVideoProfileType_1920x1080_30Fps = 10,
    /**
    custom the resolution and fps yourself.
    */
    ARTVCVideoProfileType_Custom          = 100,
};
typedef NS_ENUM(int,ARTVCErrorCode){
    /**
    bad parameters passed to API
    */
    ARTVCErrorCodeBadParameters                  = - 103,
    /**
     camera permission is denied by user
     without this permission,video call cann't be continued,please advise user enable camera permission in settings.
     */
    ARTVCErrorCodeCameraPermissionNotAllowed     = -104,
    /**
    microphone permission is denied by user
    without this permission,video call cann't be continued,please advise user enable camera permission in settings.
    */
    ARTVCErrorCodeMicrophonePermissionNotAllowed = -105,
    /**
    timeout happened,publish/subscribe cann't be finishied successfully
    */
    ARTVCErrorCodeTimeout                        = -108,
    /**
     you has already published or subsrcibed a feed .
    you cann't publish or subsrcibe the same feed once again when it has not been unpublished or unsubscribed.
    */
    ARTVCErrorCodeAlreadyPublishedOrSubsrcibed   = -111,
    /**
     you has not published or subsrcibed the feed .so you cann't do unpublish or unsubscribe operation.
    */
    ARTVCErrorCodeFeedHasNotBeenPublishedOrSubsrcibed   = -119,
    /**
    internal  webrtc-relative error when doing publish/subscribe,for example,setting sdp failed,creating sdp failed,e.g.
    */
    ARTVCErrorCodeInternalError                  = -113,
    /**
     * current room has become invalid .most of all,it's because network's down,heartbeat abnormal.
     * if you wanna continue,you MUST call createRoom again to get a new valid room.
     */
    ARTVCErrorCodeCurrentRoomHasBecomeInvalid    = -114,
    /**
    server error hanppened.CreateRoom request failed,it's a server internal error.
    */
    ARTVCErrorCodeProtocolErrorCreateRoomFailed  = -115,
    /**
    server error hanppened.JoinRoom request failed,it's a server internal error.maybe the room you joined has been became invalid yet.
    */
    ARTVCErrorCodeProtocolErrorJoinRoomFailed    = -116,
    /**
    server error hanppened.Publish request failed,it's a server internal error.
    */
    ARTVCErrorCodeProtocolErrorPublishFailed     = -117,
    /**
    server error hanppened.Subscribe request failed,it's a server internal error.maybe the stream you subscribed has been unpunlished yet or some error else.
    */
    ARTVCErrorCodeProtocolErrorSubscribeFailed   = -118,
    /**
    signal network  is unavailable,cann't connect to our server.with this error,we cann't do create/join/publish/subscribe.e.g. operations.as signal cann't be transported to server.
    */
    ARTVCErrorCodeSignalNetworkUnavailable       = -1004,
    /**
    server address not set or it's empty,cann't handle signal transporting,it's a critical error.
    */
    ARTVCErrorCodeInvalidServerAddress           = -1005,
    /**
     screen capture only support iOS11 and above
     */
    ARTVCErrorCodeScreenCaptureNotSupported = -1010,
    /**
    screen capture alrady under running,you cann't start it again before you call stop
    */
    ARTVCErrorCodeScreenCapturerAlreadyUnderRunning              = -1011,
    /**
    starting screen capture failed
    */
    ARTVCErrorCodeStartScreenCaptureFailed              = -1012,
    /**
    start screen capture success,but may be encounter errors during the processing of the capure operation.
    */
    ARTVCErrorCodeScreenCaptureFailedInProcessing              = -1013,
};
//keep the same with  ARTVCWebrtcConnectionState 
typedef NS_ENUM(int,ARTVCConnectionStatus){
    /**
    when publish/subscribe operation is begin,this status will be callback firstly.
    */
    ARTVCConnectionStatusConnecting   = 200,
    /**
    WebRTC connection has been established,means publish/subscribe operation has been processed successfully,from now on,if you are a publisher,your stream can be subscribed by other subscribers.if you are a subscriber,now you can see the video data and hear voice from the stream you subscribed.
    */
    ARTVCConnectionStatusConnected    = 202,
    /**
    WebRTC connection has been disconnected for some reason.maybe the network is too bad.
     it's a temporary status,and the SDK will handle the re-connecting automatically.
    */
    ARTVCConnectionStatusDisConnected = 203,
    /**
    WebRTC connection has been disconnected and cann't be reconnected anymore.
     you cann't publish your stream anymore if you are a publisher.
     you cann't subscribe the stream anymore if you are a subscrbier.
    */
    ARTVCConnectionStatusFailed       = 204,
    /**
    WebRTC connection has been closed .
     it's the final status for publish/subscribe.
    */
    ARTVCConnectionStatusClosed       = 205
};
typedef NS_ENUM(int,ARTVCParticipantLeaveRoomReasonType){
    ARTVCParticipantLeaveRoomReasonTypeNormal   = 1,
    ARTVCParticipantLeaveRoomReasonTypeAbnormal = 2
};
typedef NS_ENUM(int,ARTVCFeedType){
    ARTVCFeedTypeRemoteFeed               = 0,
    //1.use builtin camera and microphone
    //2.use builtin camera and auido disabled.
    ARTVCFeedTypeLocalFeedDefault         = 1,
    //audio only call
    ARTVCFeedTypeLocalFeedAuidoOnly       = 2,
    //1.use custom camera and microphone
    //2.use custom camera and auido disabled.
    ARTVCFeedTypeLocalFeedCustomVideo     = 3,
    //1.use screen capture and microphone
    //2.use screen capture and auido disabled.
    ARTVCFeedTypeLocalFeedScreenCapture   = 4,
};
XRTC_OBJC_EXPORT
@protocol ARTVCParamsProtocol <NSObject>
/**
 return YES if all parameters is legal,otherwise ,return NO.
 */
-(BOOL)isValid;
@end

typedef NS_ENUM(int,ARTVCParticipantType){
    //real participant
    ARTVCParticipantTypeNormal     = 0,//普通用户
    //virtual participant
    ARTVCParticipantTypeVirtualVod = 101 //rtcvod点播服务器
};

/**
 always use isEqual method rather tha == to make sure two objects are equal.
 */
XRTC_OBJC_EXPORT
@interface ARTVCFeed : NSObject<NSCopying,ARTVCParamsProtocol>
/**
 this feed belongs to who,it's required.
 */
@property(nonatomic,copy) NSString* uid;
/**
 participant's type
 */
@property(nonatomic,assign) ARTVCParticipantType userType;
/**
 feed identity,it's required.
 */
@property(nonatomic,copy) NSString* feedId;
/**
 additional information of the feed,it's optional.
 */
@property(nonatomic,copy) NSString* tag;
@property(nonatomic,assign) ARTVCFeedType feedType;
-(instancetype)initWithJsonDictionary:(NSDictionary*)dictionary;
@end

#pragma mark - participant info

//thead-safe class
XRTC_OBJC_EXPORT
@interface ARTVCParticipantInfo : NSObject<ARTVCParamsProtocol>
/**
 participant's uid
 */
@property(nonatomic,copy) NSString* uid;
/**
 participant's type
 */
@property(nonatomic,assign) ARTVCParticipantType userType;
/**
 this participant has published these feeds
 */
@property(nonatomic,strong,readonly) NSArray<ARTVCFeed*>* publishFeeds;
/**
this participant has subscribed these feeds
*/
@property(nonatomic,strong,readonly) NSArray<ARTVCFeed*>* subscribeFeeds;
/**
 add a given feed he published
 */
-(void)addPublishFeed:(ARTVCFeed*)feed;
/**
remove a  given feed he published
*/
-(void)removePublishFeed:(ARTVCFeed*)feed;
/**
add a given feed he subscribed
*/
-(void)addSubscribeFeed:(ARTVCFeed*)subscriber;
/**
remove a given feed he subscribed
*/
-(void)removeSubscribeFeed:(ARTVCFeed*)subscriber;
@end
NS_ASSUME_NONNULL_END
