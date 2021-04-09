//
//  ARTVCStatisticTypes.h
//  ARTVC
//
//  Created by aspling on 2017/11/6.
//  Copyright © 2017年 Alipay. All rights reserved.
//
#import "RTCMacros.h"
#ifdef ARTVC_ENABLE_STATS
#import <Foundation/Foundation.h>

XRTC_OBJC_EXPORT
@interface ARTVCRealtimeStatsItem:NSObject
/** timestamp，单位s*/
@property(nonatomic,strong) NSNumber* time;
//base
@property(nonatomic,copy) NSString* sdkVersion;
//configParams
@property(nonatomic,copy) NSString* targetResolution;
@property(nonatomic,copy) NSString* targetFps;
@property(nonatomic,copy) NSString* targetKbps;

//connection stats googCandidatePair
/** 实际总发码率 单位bps*/
@property(nonatomic,copy) NSString* totalSendBitrate;
/** 实际总的收码率 单位bps*/
@property(nonatomic,copy) NSString* totalRecvBitrate;
/** 网络延迟（毫秒）*/
@property(nonatomic,copy) NSString* rtt;
@property(nonatomic,copy) NSString* googLocalCandidateType;
@property(nonatomic,copy) NSString* googRemoteCandidateType;
@property(nonatomic,copy) NSString* googLocalAddress;
@property(nonatomic,copy) NSString* googRemoteAddress;
@property(nonatomic,copy) NSString* googReadable;
@property(nonatomic,copy) NSString* googWritable;

//bwe stats
/** 发送端的带宽评估（bps））*/
@property(nonatomic,copy) NSString* availableSendBwe;
@property(nonatomic,copy) NSString* googTargetEncBitrate;
/** 实际编码码率 单位bps*/
@property(nonatomic,copy) NSString* actualEncodeBitrate;
@property(nonatomic,copy) NSString* googTransmitBitrate;
@property(nonatomic,copy) NSString* googRetransmitBitrate;
@property(nonatomic,copy) NSString* googBucketDelay;

//video send
/** 视频码率发 单位bps*/
@property(nonatomic,copy) NSString* videoSendBitrate;
/** 实际视频发帧率 */
@property(nonatomic,copy) NSString* videoSendFps;
/** 编码器输入帧率 */
@property(nonatomic,copy) NSString* encodeInputFps;
/** 实际视频发分辨率 */
@property(nonatomic,copy) NSString* videoSendResolution;
/** 视频发送丢包率*/
@property(nonatomic,copy) NSString* videoLossRate;
/** 编码类型（1，h264，0，vp8）*/
@property(nonatomic,copy) NSString* videoEncodeType;
/** 编码实现name，硬编，软编*/
@property(nonatomic,copy) NSString* codecImplementationName;
@property(nonatomic,copy) NSString* googCodecName_videoSend;
@property(nonatomic,copy) NSString* googAvgEncodeMs_video;
@property(nonatomic,copy) NSString* googRtt_video;
@property(nonatomic,copy) NSString* googBandwidthLimitedResolution;
@property(nonatomic,copy) NSString* googCpuLimitedResolution;
@property(nonatomic,copy) NSString* googAdaptationChanges;
@property(nonatomic,copy) NSString* hugeFramesSent;
@property(nonatomic,copy) NSString* googNacksReceived;
@property(nonatomic,copy) NSString* googFirsReceived;
@property(nonatomic,copy) NSString* googPlisReceived;
@property(nonatomic,copy) NSString* packetsLost;



//video recv
/** 视频码率收 单位bps*/
@property(nonatomic,copy) NSString* videoRecvBitrate;

/** 实际视频收帧率 */
@property(nonatomic,copy) NSString* videoRecvFps;
/** 实际视频收分辨率 */
@property(nonatomic,copy) NSString* videoRecvResolution;
@property(nonatomic,copy) NSString* googDecodeMs;
@property(nonatomic,copy) NSString* googCodecName_videoRecv;
@property(nonatomic,copy) NSString* googFrameRateDecoded;
@property(nonatomic,copy) NSString* googFrameRateOutput;
@property(nonatomic,copy) NSString* googCurrentDelayMs_video;
@property(nonatomic,copy) NSString* googFirsSent;
@property(nonatomic,copy) NSString* googNacksSent;
@property(nonatomic,copy) NSString* googPlisSent;
@property(nonatomic,copy) NSString* googJitterBufferMs_video;
@property(nonatomic,copy) NSString* googRenderDelayMs_video;
@property(nonatomic,copy) NSString* googTimingFrameInfo;
@property(nonatomic,copy) NSString* googFirstFrameReceivedToDecodedMs;
@property(nonatomic,copy) NSString* videoReceivedPacketsLost;
@property(nonatomic,copy) NSString* googInterframeDelayMax;
@property(nonatomic,copy) NSString* googMinPlayoutDelayMs;
@property(nonatomic,copy) NSString* googMaxDecodeMs;
@property(nonatomic,copy) NSString* videoRecvLossRate;



//audio send
/** 音频发送丢包率*/
@property(nonatomic,copy) NSString* audioLossRate;
@property(nonatomic,copy) NSString* audioSendPacketsLost;
/** 声音码率发 单位bps*/
@property(nonatomic,copy) NSString* audioSendBitrate;
@property(nonatomic,copy) NSString* googCodecName_audioSend;
@property(nonatomic,copy) NSString* googRtt_audio;
@property(nonatomic,copy) NSString* audioInputLevel;
@property(nonatomic,copy) NSString* totalAudioEnergy;

//audio recv
/** 当前音频接收时延 单位ms */
@property(nonatomic,copy) NSString* audioCurrentDelayMs;
@property(nonatomic,copy) NSString* googJitterBufferMs_audio;
/** 声音码率收 单位bps*/
@property(nonatomic,copy) NSString* audioRecvBitrate;
@property(nonatomic,copy) NSString* audioRecvPacketsLost;
@property(nonatomic,copy) NSString* googCodecName_audioRecv;
@property(nonatomic,copy) NSString* totalAudioEnergy_recv;
@property(nonatomic,copy) NSString* audioRecvLossRate;

/** p2p:1 服务端中转：0*/
@property(nonatomic,copy) NSString* isP2P;
#ifndef USE_BUILTIN_RPC_SYNC_CHANNEL
/** coturn解密信息*/
@property(nonatomic,strong) NSDictionary* coturnCryptInfos;
#endif
/** CPU*/
@property(nonatomic,copy) NSString* cpu;
/** 平均QP*/
@property(nonatomic,copy) NSString* avgQP;

/** 多人通话下才有该字段，表示多人通话中的某一路流*/
@property(nonatomic,copy) NSString* streamId;
@property(nonatomic,copy) NSString* callId;//p2p
//it used in toDictionary method,controling which item can be selected for generating the json dictionary.
@property(nonatomic,assign) BOOL isPublish;

///** 返回闲鱼定制化的字典*/
//-(NSDictionary*)toDictionary_specifiedForIdlefish;
/** 对象转成字典，包含对象所有字段*/
-(NSMutableDictionary*)toDictionary;
/** item数组转为json*/
+(NSString*)toJsonWithItems:(NSArray<ARTVCRealtimeStatsItem*>*)items;
/** item数组转为NSArray,array的成员是nsdictionary,用于后续json序列化。*/
+(NSArray *)toArrayWithItems:(NSArray<ARTVCRealtimeStatsItem*>*)items;
@end

typedef NS_ENUM(NSInteger,ARTVCStatisticReportType){
    ARTVCStatisticReportType_Realtime,
    ARTVCStatisticReportType_AfterHangup
};

XRTC_OBJC_EXPORT
@interface ARTVCStatisticReportBase : NSObject
//房间id
@property(nonatomic,copy) NSString* roomId;
//用户Id
@property(nonatomic,copy) NSString* uid;
@property(nonatomic,copy) NSString* callId;
//是否主叫
@property(nonatomic,assign) BOOL isCaller;
@property(nonatomic,assign) ARTVCStatisticReportType type;
@end

XRTC_OBJC_EXPORT
@interface ARTVCStatisticRealtimeReport : ARTVCStatisticReportBase
//监控起始时间（精确到秒）
@property(nonatomic,assign) long startTs;
//质量监控数据，JsonArray格式（同Websocket协议格式）
/*
 {
 "opcmd": 25,
 "seqNum": 12345678,
 "roomId": "147599831481816",
 "rtoken": "xxx",
 "bUid": "2088202921927970",
 "isCaller": true,
 "startTs": 1497861487,
 "statistics": [
 {
 "time": 5,
 "cameraEnabled": true,
 "micEnabled": true,
 "rtt": "714",
 "totalRecvBitRate": "462596",
 "totalSendBitRate": "452324",
 "audioRecvBitRate": "37500",
 "audioSendBitRate": "37060",
 "videoEncodeType": "1",
 "videoRecvFPS": "15",
 "videoRecvResolution": "640x368",
 "videoSendFPS": "15",
 "videoSendResolution": "640x360"
 },
 {
 "time": 10,
 "cameraEnabled": true,
 "micEnabled": true,
 "rtt": "510",
 "totalRecvBitRate": "462596",
 "totalSendBitRate": "452324",
 "audioRecvBitRate": "37500",
 "audioSendBitRate": "37060",
 "videoEncodeType": "1",
 "videoRecvFPS": "15",
 "videoRecvResolution": "640x368",
 "videoSendFPS": "15",
 "videoSendResolution": "640x360"
 }
 ]
 }
 */
@property(nonatomic,strong) NSMutableArray<ARTVCRealtimeStatsItem*>* reportItems;
@end

XRTC_OBJC_EXPORT
@interface ARTVCStatisticReportAfterHangup : ARTVCStatisticReportBase
//发起通话时间（毫秒）
@property(nonatomic,assign) long startTs;
//是否成功接通
@property(nonatomic,assign) BOOL isSuccConnected;
//通话连接成功时间（毫秒）
@property(nonatomic,assign) long connectedTs;
//通话时长（毫秒）
@property(nonatomic,assign) long duration;
/**
 callerCancel 主叫未接通前取消
 callerTimeout 呼叫超时未接听
 calleeReject 被叫拒绝
 calleeBusy 被叫占线
 connectError 通话连接异常
 callerExit 接通后主叫挂断
 calleeExit 接通后被叫挂断
 callingError 通话异常中断
 */
@property(nonatomic,copy) NSString* endType;
//错误信息
@property(nonatomic,copy) NSString* errMsg;
//其它信息,JSON 多人通话为{"streamId":"12345678"}
@property(nonatomic,strong) NSString* extInfos;
-(NSDictionary*)toDictionary;
@end
#endif
