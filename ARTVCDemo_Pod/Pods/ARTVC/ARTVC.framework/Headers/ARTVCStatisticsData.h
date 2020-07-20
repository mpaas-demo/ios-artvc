//
//  StatisticsData.h
//  ARTVC
//
//  Created by aspling on 2017/6/2.
//  Copyright © 2017年 Alipay. All rights reserved.
//
#import "RTCMacros.h"
#ifdef ARTVC_ENABLE_STATS
#import <Foundation/Foundation.h>

#ifndef USE_BUILTIN_RPC_SYNC_CHANNEL
#define ACStatsData_Audio_Send_Ssrc_Key @"audioSendSrrc"
#define ACStatsData_Audio_Recv_Ssrc_Key @"audioRecvSrrc"
#define ACStatsData_Video_Send_Ssrc_Key @"videoSendSrrc"
#define ACStatsData_Video_Recv_Ssrc_Key @"videoRecvSrrc"
#define ACStatsData_Audio_Send_Codec_Key @"audioSendCodec"
#define ACStatsData_Audio_Recv_Codec_Key @"audioRecvCodec"
#define ACStatsData_Video_Send_Codec_Key @"videoSendCodec"
#define ACStatsData_Video_Recv_Codec_Key @"videoRecvCodec"
//#define ACStatsData_Audio_PayloadType_Key @"audioPayloadType"
//#define ACStatsData_Video_PayloadType_Key @"videoPayloadType"
#define ACStatsData_Send_MasterSalt_Key @"sendMasterSalt"
#define ACStatsData_Recv_MasterSalt_Key @"recvMasterSalt"
#define ACStatsData_SrtpCipher_Key @"srtpCipher"
#endif
/**
 * 用于业务的数据结果统计，注意时间相关的单位精确到ms级别
 */
XRTC_OBJC_EXPORT
@interface ARTVCStatisticsData : NSObject
/**
 * 通话结果,0表成功，非零表失败（具体错误码）
 */
@property(nonatomic,assign) long result;
/**
 * 主被叫
 */
@property(nonatomic,assign) BOOL isCaller;

/**
 * 本端server reflect ip,形如30.18.68.47:50972，取不到填空
 */
@property(nonatomic,copy) NSString* localIp;

/**
 * 对端server reflect ip，形如30.18.68.47:50972,取不到填空
 */
@property(nonatomic,copy) NSString* remoteIp;

/**
 * 中转server ip，形如30.18.68.47:50972
 */
@property(nonatomic,strong) NSMutableArray<NSString*>* turnServers;

/**
 * 打洞server ip，形如30.18.68.47:50972
 */
@property(nonatomic,strong) NSMutableArray<NSString*>*  stunServers;

/**
 * 是否走直连
 */
@property(nonatomic,assign) BOOL isP2P;

/**
 * 发送音频包数
 */
@property(nonatomic,assign) long sentAudioPackgs;

/**
 * 发送视频包数
 */
@property(nonatomic,assign) long sentVideoPackgs;

/**
 * 发送音频字节数
 */
@property(nonatomic,assign) long sentAudioBytes;

/**
 * 发送视频字节数
 */
@property(nonatomic,assign) long sentVideoBytes;

/**
 * 接收音频包数
 */
@property(nonatomic,assign) long recvAudioPackgs;

/**
 * 接收视频包数
 */
@property(nonatomic,assign) long recvVideoPackgs;

/**
 * 接收音频字节数
 */
@property(nonatomic,assign) long recvAudioBytes;

/**
 * 接收视频字节数
 */
@property(nonatomic,assign) long recvVideoBytes;

/**
 * 持续时长，单位s
 */
@property(nonatomic,assign) NSTimeInterval callDuration;

/**
 * 发送最小RTT，单位ms
 */
@property(nonatomic,assign) long sentMinRtt;

/**
 * 发送最大RTT，单位ms
 */
@property(nonatomic,assign) long sentMaxRtt;

/**
 * 接收最小RTT，单位ms
 */
//   public int recvMinRtt;

/**
 * 接收最大RTT，单位ms
 */
//   public int recvMaxRtt;
//音频丢包率
@property(nonatomic,assign) double audioLossRate;
//视频丢包率
@property(nonatomic,assign) double videoLossRate;
//可用带宽单位kbps
@property(nonatomic,assign) double availableSendBwe;
@property(nonatomic,copy) NSString* videoSendFps;
@property(nonatomic,copy) NSString* videoRecvFps;
@property(nonatomic,copy) NSString* videoSendResolution;
@property(nonatomic,copy) NSString* videoRecvResolution;
@property(nonatomic,copy) NSString* videoEncodeType;
@property(nonatomic,copy) NSString* codecImplementationName;
//单位bps
@property(nonatomic,copy) NSString* totalRecvBitrate;
@property(nonatomic,copy) NSString* totalSendBitrate;
@property(nonatomic,copy) NSString* audioSendBitrate;
@property(nonatomic,copy) NSString* audioRecvBitrate;
@property(nonatomic,copy) NSString* callId;//for p2p,as a bridge to pass callId between objects without connection.
/**
 * 附加信息
 */
@property(nonatomic,strong) NSMutableDictionary*  extras;
@end
#endif
