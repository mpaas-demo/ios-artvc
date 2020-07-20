//
//  ARTVCRealtimeStatisticSummary.h
//  sources
//
//  Created by klaus on 2020/3/3.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"
NS_ASSUME_NONNULL_BEGIN
XRTC_OBJC_EXPORT
@interface ARTVCRealtimeStatisticSummary : NSObject
//connection stats googCandidatePair
/** 实际总发码率 单位bps*/
@property(nonatomic,copy) NSString* totalSendBitrate;
/** 实际总的收码率 单位bps*/
@property(nonatomic,copy) NSString* totalRecvBitrate;
/** 网络延迟（毫秒）*/
/** 网络延迟（毫秒）*/
@property(nonatomic,copy) NSString* rtt;
//video send
/** 视频码率发 单位bps*/
@property(nonatomic,copy) NSString* videoSendBitrate;
/** 实际视频发帧率 */
@property(nonatomic,copy) NSString* videoSendFps;
//video recv
/** 视频码率收 单位bps*/
@property(nonatomic,copy) NSString* videoRecvBitrate;

/** 实际视频收帧率 */
@property(nonatomic,copy) NSString* videoRecvFps;

/** 声音码率发 单位bps*/
@property(nonatomic,copy) NSString* audioSendBitrate;
/** 声音码率收 单位bps*/
@property(nonatomic,copy) NSString* audioRecvBitrate;

/** 视频发送丢包率*/
@property(nonatomic,copy) NSString* videoLossRate;
//audio send
/** 音频发送丢包率*/
@property(nonatomic,copy) NSString* audioLossRate;
/** cpu */
@property(nonatomic,copy) NSString* cpu;
@end

NS_ASSUME_NONNULL_END
