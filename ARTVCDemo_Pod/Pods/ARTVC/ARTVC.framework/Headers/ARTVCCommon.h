//
//  ARTVCCommon.h
//  ARTVC
//
//  Created by aspling on 2016/11/24.
//  Copyright © 2016年 Alipay. All rights reserved.
#import <UIKit/UIKit.h>
#import "ARTVCCommon2.h"
#import "APMNetworkStatusManager.h"
////#import "MacroConfig.h"
#import "RTCMacros.h"
@class ARTVCStatisticsData;

/** 错误domain */
#define kARTVCErrorDomain   @"ARTVCClient"
/** 实际总的收码率 单位bps*/
#define kARTVCCallStatisticTotalRecvBitrate   @"totalRecvBitrate"
/** 实际总发码率 单位bp*/
#define kARTVCCallStatisticTotalSendBitrate   @"totalSendBitrate"
/** 声音码率发 单位bps*/
#define kARTVCCallStatisticAuidoSendBitrate   @"audioSendBitrate"
/** 声音码率收 单位bps*/
#define kARTVCCallStatisticAudioRecvBitrate   @"audioRecvBitrate"
/** 视频码率发 单位bps*/
#define kARTVCCallStatisticVideoSendBitrate   @"videoSendBitrate"
/** 视频码率收 单位bps*/
#define kARTVCCallStatisticVideoRecvBitrate   @"videoRecvBitrate"
/** 实际编码码率 单位bps*/
#define kARTVCCallStatisticActualEncodeBitrate   @"actualEncBitrate"
/** 实际视频收帧率 */
#define kARTVCCallStatisticFpsOfRecvedVideo   @"videoRecvFps"
/** 实际视频发帧率 */
#define kARTVCCallStatisticFpsOfSentVideo   @"videoSendFps"
/** 输入编码器帧率 */
#define kARTVCCallStatisticEncodeInputFps   @"encodeInputFps"
/** 实际视频收分辨率 */
#define kARTVCCallStatisticResolutionOfRecvedVideo   @"videoRecvResolution"
/** 实际视频发分辨率 */
#define kARTVCCallStatisticResolutionOfSentVideo   @"videoSendResolution"
/** 网络延迟（毫秒）*/
#define kARTVCCallStatisticRTT   @"RTT"
/** 编码类型（1，h264，0，vp8）*/
#define kARTVCCallStatisticVideoEncodeType   @"videoEncodeType"
/** 编码实现name，硬编，软编*/
#define kARTVCCallStatisticCodecImplementationName   @"codecImplementationName"
/** 音频发送丢包率*/
#define kARTVCCallStatisticAudioLossRateType   @"audioLossRate"
/** 视频发送丢包率*/
#define kARTVCCallStatisticVideoLossRateType   @"videoLossRate"
/** 发送端的带宽评估（kbps））*/
#define kARTVCCallStatisticAvailableSendBweType   @"availableSendBwe"
/** p2p:1 服务端中转：0*/
#define kARTVCCallStatisticIsP2PType   @"isP2P"
#ifndef USE_BUILTIN_RPC_SYNC_CHANNEL
/** 配合安全需求，coturn录制时需要用到的信息*/
#define kARTVCCallStatisticCoturnRecordInfoType   @"coturnRecordInfos"
#endif
/** CPU*/
#define kARTVCCallStatisticCpu   @"CPU"
/** 平均QP*/
#define kARTVCCallStatisticAverageQP   @"avgQP"
/** 当前音频接收时延，单位ms*/
#define kARTVCCallStatisticAudioCurrentDelay   @"audioCurrentDelayMs"
/**
 * 呼叫模式，视频呼叫，音频呼叫
 */
typedef NS_ENUM(NSInteger,ARTVCCallMode){
    //视频呼叫
    ARTVCCallModeVideoCall                  = 1,
    //音频呼叫
    ARTVCCallModeAudioCall                  = 2,
    //视频呼叫，只收对端视频画面（不接受对端音频流），本地不发送音视频
    ARTVCCallModeAudioInactiveVideoRecvonly = 3,
    //视频呼叫，只发视频画面，本地不发送音视频
    ARTVCCallModeAudioInactiveVideoSendonly = 4,
    //视频收发，音频inactive
    ARTVCCallModeAudioInactiveVideoSendrecv = 5,
    //音频收发，视频recvonly
    ARTVCCallModeAudioSendrecvVideoRecvonly = 6,
    //音频收发，视频sendonly
    ARTVCCallModeAudioSendrecvVideoSendonly = 7,
};

/** 连接状态 */
typedef NS_ENUM(NSInteger, ARTVCState) {
    /**
     *连接中
     */
    ARTVCStateConnecting           = 200,
    /**
     *被叫加入
     */
    ARTVCStateCalleeIsNowAnswering = 201,
    /**
     *连接成功
     */
    ARTVCStateConnected            = 202,
    /**
     *连接断开，底层会自动重试重连。可以理解为一个中间态
     */
    ARTVCStateDisconnected         = 203,
    //连接失败,该状态目前不会透传给到业务（SDK内部使用）。
    ARTVCStateConnectFailed        = 204,
    /**
     *连接关闭了，底层不再重连
     */
    ARTVCStateClosed               = 205
    
};

/** 错误类型 */
typedef NS_ENUM(NSInteger, ARTVCErrorType) {
    /**
     *未知错误
     */
    ARTVCErrorTypeUnknownError                 = -101,
    /**
     * call通话取消
     */
    ARTVCErrorTypeCancel                       = -102,
    /**
     * 参数错误
     */
    ARTVCErrorTypeParamsError                  = -103,
    /**
     * 视频权限错误
     */
    ARTVCErrorTypeCameraPermissionNotAllowed   = -104,
    /**
     * 音频权限错误
     */
    ARTVCErrorTypeMicPermissionNotAllowed      = -105,
    /**
     * 打开摄像头错误
     */
    ARTVCErrorTypeOpenCameraError              = -106,
    /**
     * 打开麦克风错误
     */
    ARTVCErrorTypeOpenMicError                 = -107,
    /**
     * 通话超时无响应
     */
    ARTVCErrorTypeTimeout                      = -108,
    /**
     * 通话网络协议错误
     */
    ARTVCErrorTypeProtocolError                = -109,
    /**
     * 加载webRTC动态库错误
     */
    ARTVCLoadWebRTCError                       = -110,
    /**
     * 状态错误，已经处于通话中再发起通话
     */
    ARTVCAlreadyUnderCallError                 = -111,
    /**
     * 停止创建本地视频，属于一个正常的错误码。可能的触发场景是纯音频通话，业务可能调用了localView，导致
     * 本地视频已经创建，或者在创建中，此时需要正常的干掉本地视频。
     */
    ARTVCStopCreatingLocalVideoTrackError      = -112,
    /**
     * WebRTC内部错误
     */
    ARTVCInternalError                         = -113,
    /**
     * current room has become invalid .most of all,it's because network's down,heartbeat abnormal.
     * if you wanna continue,you MUST call createRoom again to get a new valid room.
     */
    ARTVCCurrentRoomHasBecomeInvalidError      = -114,
};

/**
 * 挂断原因Key
 */
#define kARTVCHangupReasonKey @"hangupReason"
/**
 * 挂断原因
 */
typedef NS_ENUM(NSUInteger,ARTVCHangupReason){
    /**
     * 对端挂断
     */
    ARTVCHangupReasonRemoteHangup                  = 1,
    /**
     * 被别的应用中断，譬如来电，闹钟，日历事件
     */
    ARTVCHangupReasonInterruptionByOtherApp        = 2,
    /**
     * 异常中断，可能本端问题（本端无网络==），可能对端问题(譬如对端无网络==)
     * 具体当webrtc抛出failed事件时才回调
     */
    ARTVCHangupReasonExceptionHanppened            = 3,
    //-------以下原因，暂时不会回调给业务----------
    //正常主动挂断
    ARTVCHangupReasonNormal                        = 4,
    //连接超时
    ARTVCHangupReasonTimeout                       = 5,
    //被叫未应答前主叫主动挂断了
    ARTVCHangupReasonCancelBeforeCalleeIsAnswering = 6,
    //被叫拒绝
    ARTVCHangupReasonRejectedByCallee              = 7,
    //被叫忙
    ARTVCHangupReasonCalleeIsBusy                  = 8,
    //通话未接通前连接异常
    ARTVCHangupReasonExceptionWhenConnecting       = 9,
    ARTVCHangupReasonRoomInvalid = 10,
    ARTVCHangupReasonStartAudioDeviceFailed        = 101,
};

typedef NS_ENUM(NSInteger,ARTVCUserLeaveReason){
    ARTVCUserLeaveReasonMyself                              = 0,
    ARTVCUserLeaveReasonRemoteQuit                          = 1,
    ARTVCUserLeaveReasonAudioSesseionInterruptedByOtherApps = 2,
    ARTVCUserLeaveReasonExceptionHanppened                  = 3,
    ARTVCUserLeaveReasonRemoteQuitAbnoral                   = 4
};
typedef NS_ENUM(NSInteger,ARTVCPeerLeaveRoomReason){
    ARTVCPeerLeaveRoomReasonNormal   = 0,
    ARTVCPeerLeaveRoomReasonAbnormal = 1
};
@class ARTVCRoomInfo,ARTVCIncomingCallInfo,ARTVCForwardMsgInfo;
typedef void (^ARTVCRoomInfoCompletion)(ARTVCRoomInfo* roomInfo);
/**
 * room相关信息，包括roomID，room token
 */
XRTC_OBJC_EXPORT
@interface ARTVCRoomInfo :NSObject
/**
 * roomID
 */
@property(nonatomic,copy) NSString* roomID;
/**
 * token,用于坐席加入时鉴权用
 */
@property(nonatomic,copy) NSString* token;
@end
#ifndef ARTVC_AUDIO_ONLY
//TODO:REMOVE IT LATER WHEN OLD SDK IS REMOVED.
/**
 * 视频分辨率档位枚举
 */
typedef NS_ENUM(NSUInteger,ARTVCVideoProfile){
    /**
     * 输出画面分辨率480x360(4:3)
     */
    ARTVCVideoProfile360P_0          = 0,
    /**
     * 输出画面分辨率640x480(4:3)
     */
    ARTVCVideoProfile640x480         = 1,
    /**
     * 输出画面分辨率640x360(16:9)
     * TODO：兼容性的缘故，最终输出的分辨率其实是640*368（16的倍数）
     */
    ARTVCVideoProfile360P            = 2,
    /**
     * 输出画面分辨率960x540(16:9)
     */
    ARTVCVideoProfile540P            = 4,
    /**
     * 输出画面分辨率1280x720(16:9)
     */
    ARTVCVideoProfile720P            = 6,
    /**
     * 输出画面分辨率320x360
     */
    ARTVCVideoProfileIdleFish320x360 = 8,
    ARTVCVideoProfile640x360 = ARTVCVideoProfile360P,
    ARTVCVideoProfile960x540 = ARTVCVideoProfile540P,
    ARTVCVideoProfile1280x720 = ARTVCVideoProfile720P,
    /**
     * 输出画面分辨率320x180(16:9)
     */
    ARTVCVideoProfile320x180        = 12,
    /**
     * 输出画面分辨率160x90(16:9)
     */
    ARTVCVideoProfile160x90        = 13,
};
#endif
// WebRTC 日志级别.
typedef NS_ENUM(NSInteger, WebRTCLogLevel) {
    WebRTCLogLevelVerbose,
    WebRTCLogLevelInfo,
    WebRTCLogLevelWarning,
    WebRTCLogLevelError,
};


typedef NS_ENUM(int,ARTVCReplyState){
    /*accept the coming call*/
    ARTVCReplyStateAccept  = 0,
    /*it's offline when the call is coming ??*/
    ARTVCReplyStateOffline = 1,
    /*reject the coming call*/
    ARTVCReplyStateReject  = 2,
    /*it's ruuning a call in process when  the other call is coming */
    ARTVCReplyStateBusy    = 3,
    /*peer does not reply after it's timeout. */
    ARTVCReplyStatePeerTimeout    = 4
};
typedef NS_ENUM(int,ARTVForwardMsgType){
    /*event msg*/
    ARTVForwardMsgTypeEvent  = 1,
    /*text msg*/
    ARTVForwardMsgTypeText   = 2
};
@class ARTVCInviteInfo,ARTVCReplyToInviteInfo;
/**
 * 都在主线程回调
 */
XRTC_OBJC_EXPORT
@protocol ARTVCCallDelegate <NSObject>
- (void)didMicrophonePermissionNotAllowed;
#ifndef ARTVC_AUDIO_ONLY
- (void)didCameraPermissionNotAllowed;
//video render view has been created,but the first video frame has not been rendered yet
- (void)didVideoRenderViewInitialized:(UIView*)renderView participantId:(NSString*)participantId;
//fist video frame has been rendered
- (void)didFirstVideoFrameRendered:(UIView*)renderView participantId:(NSString*)participantId;
- (void)didVideoViewRenderStopped:(UIView*)renderView participantId:(NSString*)participantId;
#endif



/**
 * 视频通话出错
 * 主线程回调
 */
- (void)participant:(NSString*)participantId didEncounterError:(NSError *)error;
/**
 * 音频播放模式切换回调
 * 主线程回调
 */
- (void)didAudioPlayModeChangedTo:(ARTVCAudioPlayMode)audioPlayMode;
/**
 * 网络发生了变更（譬如wifi切换到cellular）
 * 首次启动时通常会回调一次，
 * 1.返回的网络类型为APMNetReachabilityStatusReachableViaWiFi时业务可考虑不做处理；
 * 2.返回的网络类型为cellular（APMNetReachabilityStatusReachableViaWWAN/APMNetReachabilityStatusReachableViaWWAN2G/3G/4G）时业务可考虑提示用户当前网络为移动网络，会使用移动网络数据进行视频通话；
 * 主线程回调
 */
- (void)didNetworkChangedTo:(APMNetworkReachabilityStatus)netStatus;

@optional
#ifndef ARTVC_AUDIO_ONLY
/**
 * 对端切换到了音频通话/视频通话
 * 在视频通话建立后，对端切换到音频通话，会回调ARTVCCallAudioVideoModeAudioCall，然后对端从音频通话再切回视频通话时会回调ARTVCCallAudioVideoModeVideoCall
 * 对端在video--audio--video过程中，该回调才会触发。
 * 主线程回调
 * P2P call only
 */
- (void)participant:(NSString*)participantId didRemoteCallModeChangedTo:(ARTVCCallMode)callMode;

/**
 * 收到房间相关信息（房间ID和token）
 * 支付宝蚂蚁财富接入时考虑实现该方法。
 * 主线程回调
 */
//- (void)participant:(NSString*)participantId didRecvRoomInfo:(ARTVCRoomInfo*)roomInfo;
#ifdef ARTVC_ENABLE_EXPROT_SAMPLEBUFFER
/**
 * 收到摄像头原始数据（NV12格式,kCVPixelFormatType_420YpCbCr8BiPlanarFullRange），处理后返回CVImageBufferRef对象（返回的数据格式一定要是NV12格式,kCVPixelFormatType_420YpCbCr8BiPlanarFullRange）赋值给processedBuffer
 * 任意线程回调，业务不需要切线程，直接处理接收到的数据并做返回数据设置。
 */
- (void)didOutputSampleBuffer:(CVImageBufferRef)sampleBuffer processedBuffer:(CVImageBufferRef*)processedBuffer;
#endif
#endif
/**
 * 呼叫统计数据上报,在挂断后回调
 * 任意线程回调
 */
- (void)participant:(NSString*)participantId didGenerateCallStatisticsData:(ARTVCStatisticsData*)statsData;
#ifndef ARTVC_AUDIO_ONLY
/**
 * 呼叫当前可发送网络带宽变化，isLow为YES表示带宽不够（业务可做通话质量不佳的提示），isLow为NO表示带宽足够（业务可取消通话质量不佳的提示）,bw为当前可用发送带宽,单位bps
 * 呼叫过程中，视网络质量而定，可能会回调多次。
 * 主线程回调
 */
- (void)participant:(NSString*)participantId didAvailabeSendBandwidthBecomeLow:(BOOL)isLow currentBandwidth:(double)bw;
#endif
- (void)participant:(NSString *)participantId didReceiveRoomInfo:(ARTVCRoomInfo*)info;
- (void)participant:(NSString *)participantId didReceiveIncomingCall:(ARTVCIncomingCallInfo*)info;
/**
 * 视频通话状态变更。该回调覆盖呼叫的整个生命周期，不管何种原因导致通话结束时，ARTVCStateClosed一定会回调。
 * 主线程回调
 */
- (void)participant:(NSString*)participantId didStateChangedTo:(ARTVCState)state DEPRECATED_MSG_ATTRIBUTE("please use participant:didStateChangedTo:callId:");
/**
 * 视频通话状态变更。该回调覆盖呼叫的整个生命周期，不管何种原因导致通话结束时，ARTVCStateClosed一定会回调。
 * 比participant:didStateChangedTo:新增了callId字段，用于区别不同的呼叫。
 * 主线程回调
 */
- (void)participant:(NSString*)participantId didStateChangedTo:(ARTVCState)state callId:(NSString*)callId;
/**
 * 收到对端的reply信息
 * 主线程回调
 */

- (void)participant:(NSString*)participantId didPeerReply:(ARTVCReplyState)state callId:(NSString*)callId;
/**
 * 收到对端的UID信息
 * 主线程回调
 */

- (void)participant:(NSString*)participantId didGetPeerUid:(NSString*)peerUid;
/**
 * 收到对端的事件或者文本信息
 * 主线程回调
 */

- (void)participant:(NSString*)participantId didReceiveForwardMsg:(ARTVCForwardMsgInfo*)msg;
/**
 * 收到对端invite消息
 * 主线程回调
 */

- (void)participant:(NSString*)participantId didReceiveInvite:(ARTVCInviteInfo*)info;
/**
 * 收到对端对invite消息的回复
 * 主线程回调
 */

- (void)participant:(NSString*)participantId didPeerReplyToInvite:(ARTVCReplyToInviteInfo*)info;
/**
 * 收到对端leaveroom的通知
 * 主线程回调
 */

- (void)participant:(NSString*)participantId didPeerLeaveRoom:(NSString*)peerUid leaveReason:(ARTVCPeerLeaveRoomReason)reason;

@end


typedef NS_ENUM(NSInteger,ARTVCWebsocketServerType){
    ARTVCWebsocketServerTypeOnline = 0,
    ARTVCWebsocketServerTypeTest,
    ARTVCWebsocketServerTypeSandbox
};
typedef NS_ENUM(NSInteger,ARTVCRoomType){
    /*room for p2p call*/
    ARTVCRoomTypeP2p           = 1,
    /*room for conference call*/
    ARTVCRoomTypeConference    = 2,
    /*room for live broadcast*/
    ARTVCRoomTypeLiveBroadcast = 3
};
typedef NS_ENUM(NSInteger,ARTVExitRoomReasonType){
    /*exit room normally*/
    ARTVExitRoomReasonTypeNormal   = 0,
    /*exit room abnormally*/
    ARTVExitRoomReasonTypeAbnormal = 1
};







