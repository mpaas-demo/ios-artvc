//
//  APMAssetReader.h
//  APMultimedia
//
//  Created by Kris Tian on 2020/6/23.
//  Copyright © 2020 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMFormatDescription.h>
#import <CoreMedia/CMSampleBuffer.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface APMAssetReader : NSObject

/// 资源读取的时间段
@property (nonatomic) CMTimeRange timeRange;
/**
 * Indicates whether video composition is enabled for export, and supplies the instructions for video composition.
 *
 * You can observe this property using key-value observing.
 */
@property (nonatomic, copy) AVVideoComposition *videoComposition;
/**
 * Indicates whether non-default audio mixing is enabled for export, and supplies the parameters for audio mixing.
 */
@property (nonatomic, copy) AVAudioMix *audioMix;

/// 资源读取的进度
@property (nonatomic, assign, readonly) float progress;

/// 资源信息读取失败错误信息
@property (nonatomic, strong, readonly) NSError *error;

/*!
@property status
@abstract
   The status of reading sample buffers from the receiver's asset.

@discussion
   The value of this property is an AVAssetReaderStatus that indicates whether reading is in progress, has completed successfully, has been canceled, or has failed
*/
@property (nonatomic, assign, readonly) AVAssetReaderStatus status;

/// 资源中是否包含音频信息
@property (nonatomic, assign, readonly) BOOL containsAudio;

/// 资源中是否包含视频信息
@property (nonatomic, assign, readonly) BOOL containsVideo;

/**
 *  目前只支持kCVPixelFormatType_420YpCbCr8PlanarFullRange与kCVPixelFormatType_32BGRA, 默认kCVPixelFormatType_420YpCbCr8PlanarFullRange
 */
@property (nonatomic, assign) OSType frameFormat;

/// 从本地文件创建reader
/// @param filePath 本地文件地址
- (instancetype)initWithFilePath:(NSString *)filePath;

/// 从AVAsset创建reader
/// @param asset AVAsset对象
- (instancetype)initWithAsset:(AVAsset *)asset;

/// 开始读取数据,如果读取数据失败,通过error属性获取失败信息
- (BOOL)startReading;

/// 取消读取数据
- (void)cancelReading;

/// 获取下一帧音频数据, 如果获取数据为NULL,通过status属性来判断是否读取结束. 需要在startReading后获取数据
- (CMSampleBufferRef)copyNextAudioSampleBuffer;

/// 获取下一帧视频数据, 如果获取数据为NULL,通过status属性来判断是否读取结束. 需要在startReading后获取数据
- (CMSampleBufferRef)copyNextVideoSampleBuffer;

@end

NS_ASSUME_NONNULL_END
