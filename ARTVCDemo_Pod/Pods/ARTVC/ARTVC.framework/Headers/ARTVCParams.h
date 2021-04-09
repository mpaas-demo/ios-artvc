//
//  ARTVCParams.h
//  sources
//
//  Created by klaus on 2019/9/23.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"
#import "ARTVCCommonDefines.h"
NS_ASSUME_NONNULL_BEGIN

#define ARTVCParamsKey_LiveUrl @"liveUrl"
#define ARTVCParamsKey_DefaultRecord @"defaultRecord"
#define ARTVCParamsKey_AliYunSDK @"aliyun"
#pragma mark - room relative
XRTC_OBJC_EXPORT
@interface ARTVCCreateRoomParams : NSObject<ARTVCParamsProtocol>
@property(nonatomic,copy) NSString* uid;
@property(nonatomic,copy) NSString* bizName;
#ifndef ARTVC_BUILD_FOR_MPAAS
@property(nonatomic,copy) NSString* subBiz;
#endif
@property(nonatomic,copy) NSString* signature;
//default is ARTVCRoomServiceType_RTC
//if type is ARTVCRoomServiceType_LIVE,you MUST set liveUrl in extraInfo.
@property(nonatomic,assign) ARTVCRoomServiceType type;
/**
 @{
 //only need and MUST setted when type is ARTVCRoomServiceType_LIVE
 ARTVCParamsKey_LiveUrl:"rtpmp:xxx",
 //setted to @(YES) to enable server record in back server.
 ARTVCParamsKey_DefaultRecord:@(YES)
 }
 */
@property(nonatomic,strong) NSDictionary* extraInfo;
#ifdef ARTVC_BUILD_FOR_MPAAS
-(void)setWorkspaceIdManually:(NSString*)wokspaceId DEPRECATED_MSG_ATTRIBUTE("normally workspaceId is read from mPaaS framework automatically,don't need set here.");
-(void)setAppIdManually:(NSString*)appId DEPRECATED_MSG_ATTRIBUTE("normally appId is read from mPaaS framework automatically,don't need set here.");
#endif
@end

XRTC_OBJC_EXPORT
@interface ARTVCJoinRoomParams : NSObject<ARTVCParamsProtocol>
@property(nonatomic,copy) NSString* uid;
@property(nonatomic,copy) NSString* bizName;
#ifndef ARTVC_BUILD_FOR_MPAAS
@property(nonatomic,copy) NSString* subBiz;
#endif
@property(nonatomic,copy) NSString* roomId;
@property(nonatomic,copy) NSString* signature;//not requiered when envType is ARTVCEnvType_AliYun
@property(nonatomic,copy) NSString* rtoken;//not requiered when envType is ARTVCEnvType_AliYun
//default is ARTVCEnvType_Alipay
@property(nonatomic,assign) ARTVCEnvType envType;
/**
@{
//setted to @(YES) to enable server record in back server.
ARTVCParamsKey_DefaultRecord:@(YES),
 //communicate with AliYun SDK,MUST set the info below,the value is a NSDictionary
 // see https://help.aliyun.com/document_detail/111166.html?spm=a2c4g.11186623.4.5.794e37f05jAhHd
 ARTVCParamsKey_AliYunSDK:jsonDictionary
}
*/
@property(nonatomic,strong) NSDictionary* extraInfo;
#ifdef ARTVC_BUILD_FOR_MPAAS
-(void)setWorkspaceIdManually:(NSString*)wokspaceId DEPRECATED_MSG_ATTRIBUTE("normally workspaceId is read from mPaaS framework automatically,don't need set here.");
-(void)setAppIdManually:(NSString*)appId DEPRECATED_MSG_ATTRIBUTE("normally appId is read from mPaaS framework automatically,don't need set here.");
#endif
@end

typedef NS_ENUM(int,ARTVCReplyType){
    ARTVCReplyTypeAnswer  = 0,
    ARTVCReplyTypeOffline = 1,
    ARTVCReplyTypeReject  = 2,
    //reserve 3 for busy
    ARTVCReplyTypeTimeout = 4,
};

typedef NS_ENUM(int,ARTVCInviteError){
    ARTVCInviteErrorBabParameters                  = 1,
    ARTVCInviteErrorNotHaveValidRoom               = 2,
    ARTVCInviteErrorPreviousInviteUnderProcessing  = 3,
    ARTVCInviteErrorRequestFailed                  = 4,
    ARTVCInviteErrorTimeout                        = 5,
    ARTVCInviteErrorCanceledWhenLeaveRoom          = 6,
};
typedef NS_ENUM(int,ARTVCReplyError){
    ARTVCReplyErrorBabParameters                   = 1,
    ARTVCReplyErrorPreviousReplyUnderProcessing    = 3,
    ARTVCReplyErrorRequestFailed                   = 4,
    ARTVCReplyErrorTimeout                         = 5,
    ARTVCReplyErrorCanceledWhenLeaveRoom           = 6,
};
//error is nil means success,code see ARTVCInviteError
typedef void (^ARTVCInviteCallback)(NSError*_Nullable error);
//error is nil means success,code see ARTVCReplyError
typedef void (^ARTVCReplyCallback)(NSError*_Nullable error);
typedef NS_ENUM(int,ARTVCInviteType){
    ARTVCInviteTypeWebsocket = 0,
    ARTVCReplyTypeAlipayPush = 1,
};

XRTC_OBJC_EXPORT
@interface ARTVCInviteParams : NSObject<ARTVCParamsProtocol>
//set by sdk default.
@property(nonatomic,copy) NSString* inviteId;
@property(nonatomic,copy) NSString* inviteeUid;
//if it's type of websocket,invitee MUST be online,otherwise,invite request will be failed.
@property(nonatomic,assign) ARTVCInviteType inviteType;
//invite peer to enable audio,default YES
@property(nonatomic,assign) BOOL audioEnable;
//invite peer to enable video,default YES
@property(nonatomic,assign) BOOL videoEnable;
@property(nonatomic,assign) int timeout;//s,default is 60s
@property(nonatomic,strong) NSDictionary* extraInfo;
@end


#define ARTVCInviteParamsInviteIdEnableKey @"inviteId"
XRTC_OBJC_EXPORT
@interface ARTVCReplyParams : NSObject<ARTVCParamsProtocol>
@property(nonatomic,copy) NSString* uid;
@property(nonatomic,copy) NSString* inviterUid;
@property(nonatomic,copy) NSString* bizName;
#ifndef ARTVC_BUILD_FOR_MPAAS
@property(nonatomic,copy) NSString* subBiz;
#endif
@property(nonatomic,copy) NSString* roomId;
@property(nonatomic,assign) ARTVCReplyType replyType;
//means we are replying to which invitaion. inviteId is generated by invite operation.
@property(nonatomic,copy) NSString* inviteId;
//tell peer that  audio enable is accepted,default YES
@property(nonatomic,assign) BOOL audioEnable;
//tell peer that  video enable is accepted,default YES
@property(nonatomic,assign) BOOL videoEnable;
@property(nonatomic,assign) int timeout;//s,default is 10s
@property(nonatomic,strong) NSDictionary* extraInfo;
#ifdef ARTVC_BUILD_FOR_MPAAS
-(void)setWorkspaceIdManually:(NSString*)wokspaceId DEPRECATED_MSG_ATTRIBUTE("normally workspaceId is read from mPaaS framework automatically,don't need set here.");
-(void)setAppIdManually:(NSString*)appId DEPRECATED_MSG_ATTRIBUTE("normally appId is read from mPaaS framework automatically,don't need set here.");
#endif
@end

XRTC_OBJC_EXPORT
@interface ARTVCRoomInfomation : NSObject<ARTVCParamsProtocol>
@property(nonatomic,copy) NSString* roomId;
@property(nonatomic,copy) NSString* rtoken;
@end

#pragma mark - publish subscribe
XRTC_OBJC_EXPORT
@interface ARTVCPublishConfig : NSObject<NSCopying,ARTVCParamsProtocol>
//default is YES
@property(nonatomic,assign) BOOL videoEnable;
//default is YES
@property(nonatomic,assign) BOOL audioEnable;
//default is ARTVCVideoSourceType_Camera
@property(nonatomic,assign) ARTVCVideoSourceType videoSource;
//default is ARTVCVideoProfileType_640x360_15Fps
@property(nonatomic,assign) ARTVCVideoProfileType videoProfile;
@property(nonatomic,assign) int videoCustomWidth  DEPRECATED_MSG_ATTRIBUTE("it's not recommented to use custom define,please use videoProfile instead");
@property(nonatomic,assign) int videoCustomHeight DEPRECATED_MSG_ATTRIBUTE("it's not recommented to use custom define,please use videoProfile instead");
@property(nonatomic,assign) int videoCustomFps DEPRECATED_MSG_ATTRIBUTE("it's not recommented to use custom define,please use videoProfile instead");
@property(nonatomic,assign) int videoCustomBitrate DEPRECATED_MSG_ATTRIBUTE("it's not recommented to use custom define,please use videoProfile instead");//kpbs
//default is 60s
@property(nonatomic,assign) int timeout;
@end

XRTC_OBJC_EXPORT
@interface ARTVCUnpublishConfig : NSObject<ARTVCParamsProtocol>
@property(nonatomic,strong) ARTVCFeed* feed;
@end

XRTC_OBJC_EXPORT
@interface ARTVCSubscribeOptions : NSObject<ARTVCParamsProtocol>
//default is YES
@property(nonatomic,assign) BOOL receiveAudio;
//default is YES
@property(nonatomic,assign) BOOL receiveVideo;
//default is 60s
@property(nonatomic,assign) int timeout;
@end

XRTC_OBJC_EXPORT
@interface ARTVCSubscribeConfig : NSObject<ARTVCParamsProtocol>
@property(nonatomic,strong) ARTVCFeed* feed;
//nil means recevie both audio and video.
@property(nonatomic,strong) ARTVCSubscribeOptions* options;
@end

XRTC_OBJC_EXPORT
@interface ARTVCUnsubscribeConfig : NSObject<ARTVCParamsProtocol>
@property(nonatomic,strong) ARTVCFeed* feed;
@end
#pragma mark - IM
//error is nil means success
typedef void (^ARTVCIMCallback)(NSError* error);
XRTC_OBJC_EXPORT
@interface ARTVCIMMessage : NSObject<ARTVCParamsProtocol>
@property(nonatomic,copy) NSString* msg;
//it's set by defualt
@property(nonatomic,assign) NSUInteger msgId;
//it's set by defualt
//ms
@property(nonatomic,assign) NSTimeInterval timestamp;
@end
#pragma mark - custom video capurer
XRTC_OBJC_EXPORT
@interface ARTVCCreateCustomVideoCaputurerParams:NSObject
@property(nonatomic,assign) BOOL provideRenderView;//default NO;
@end
#pragma mark - screen  capurer
XRTC_OBJC_EXPORT
@interface ARTVCCreateScreenCaputurerParams:NSObject
@property(nonatomic,assign) BOOL provideRenderView;//default NO;
@end
NS_ASSUME_NONNULL_END
