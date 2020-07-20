//
//  ARTVCCommon.h
//  ARTVC
//
//  Created by aspling on 2016/11/24.
//  Copyright © 2016年 Alipay. All rights reserved.
#import <UIKit/UIKit.h>
#import "RTCMacros.h"

typedef NS_ENUM(NSInteger,ARTVCWebrtcClientType){
    /** P2P */
    ARTVCWebrtcClientTypeP2P        = 0,
    /** Conference */
    ARTVCWebrtcClientTypeConference = 1
    
};

/**
 * 声音播放模式
 */
typedef NS_ENUM(NSUInteger,ARTVCAudioPlayMode) {
    ARTVCAudioPlayModeInit = 0,//初始化状态
    ARTVCAudioPlayModeReceiver,//听筒
    ARTVCAudioPlayModeSpeaker,//扬声器
    ARTVCAudioPlayModeHeadphone,//耳机
    ARTVCAudioPlayModeBluetooth//蓝牙设备
};


/**
 * ICE打洞策略
 */
typedef NS_ENUM(NSInteger, ARTVCIceTransportPolicy) {
    //全部不支持，不应该设置该值
    ARTVCIceTransportPolicyNone,
    //强制走中转
    ARTVCIceTransportPolicyRelay,
    //中转或者srflx
    ARTVCIceTransportPolicyNoHost,
    //全部支持，本地IP，srflx，relay
    ARTVCIceTransportPolicyAll
};

//Deprecated.it's not used now.always use H.264
#define ARTVCDynamicConfigPreferVideoEncodeTypeKey @"preferVideoEncodeType"
#define ARTVCDynamicConfigIceTransportPolicyKey @"iceTransportPolicy"
//Deprecated.it's not used now.always use H.264
#define ARTVCDynamicConfigDisableH264Key @"disableH264"
#define ARTVCDynamicConfigMaxBitrateKey @"maxBitrate"
#define ARTVCDynamicConfigMinBitrateKey @"minBitrate"
#define ARTVCDynamicConfigMaxBitrateForCustomVideoKey @"maxBitrateForCustomVideo"
#define ARTVCDynamicConfigMaxBitrateForScreenSharingKey @"maxBitrateForScreenSharing"
#define ARTVCDynamicConfigEnableStatsForSubscribedUserKey @"enableStatsForSubscribedUser"
//attention,if DTLS disabled,the underlying call won't be encryped,risking private data leaked.
#define ARTVCDynamicConfigDisableDTLSKey @"disableDTLS"
/**
 * 云控配置协议
 */
XRTC_OBJC_EXPORT
@protocol ARTVCDynamicConfigProtocol<NSObject>
/**
 * 获取key对应的云控配置，如果未配置，请返回你nil，客户端使用底层默认的配置。
 * ARTVCDynamicConfigPreferVideoEncodeTypeKey对应的value为NSString，@"1"表示优先选择H264,@"0"表示优先选择VP8
 * ARTVCDynamicConfigIceTransportPolicyKey对应的value为NSString，其值为ARTVCIceTransportPolicy枚举值
 * ARTVCDynamicConfigDisableH264Key对应的value为NSString，@"1"表示diabaleH264,@"0"表示enableH264
 * ARTVCDynamicConfigMaxBitrateKey对应的value为NSString，单位是Kbps，譬如@"400" 表示400kbps
 *
   ARTVCDynamicConfigMinBitrateKey对应的value为NSString，单位是Kbps，譬如@"400" 表示400kbps
 * ARTVCDynamicConfigEnableStatsForSubscribedUserKey为NSString，@"1"表示打开统计,@"0"表示关闭统计
 */
-(NSString*)configWithKey:(NSString*)key;

@end


typedef NS_ENUM(NSInteger,ARTVCSdpMode){
    //none
    ARTVCSdpModeNone                       = 0,
    //Audio Sendrecv,Video Sendrecv
    ARTVCSdpModeAudioSendrecvVideoSendrecv = 1,
    //Audio Sendrecv,VideoInactive
    ARTVCSdpModeAudioSendrecvVideoInactive = 2,
    //Audio Inactive,Video Sendrecv
    ARTVCSdpModeAudioInactiveVideoSendrecv = 3,
    //Audio Inactive,Video Recvonly
    ARTVCSdpModeAudioInactiveVideoRecvonly = 4,
    //Audio Recvonly,Video Inactive
    ARTVCSdpModeAudioRecvonlyVideoInactive = 5,
    //Audio Recvonly,Video Recvonly
    ARTVCSdpModeAudioRecvonlyVideoRecvonly = 6,
    //Audio Sendonly,Video Inactive
    ARTVCSdpModeAudioSendonlyVideoInactive = 7,
    //Audio Sendrecv,Video Recvonly
    ARTVCSdpModeAudioSendrecvVideoRecvonly = 9,
    //Audio Inactive,Video SendOnly
    ARTVCSdpModeAudioInactiveVideoSendonly = 10,
    //Audio Sendonly,Video Sendonly
    ARTVCSdpModeAudioSendonlyVideoSendonly = 13,
    //Audio Sendrecv,Video Sendonly
    ARTVCSdpModeAudioSendrecvVideoSendonly = 15
    
};







