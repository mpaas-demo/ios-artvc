/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RTCVideoRotation) {
  RTCVideoRotation_0 = 0,
  RTCVideoRotation_90 = 90,
  RTCVideoRotation_180 = 180,
  RTCVideoRotation_270 = 270,
};

@protocol XRTCVideoFrameBuffer;

// XRTCVideoFrame is an ObjectiveC version of xwebrtc::VideoFrame.
//XRTC_OBJC_EXPORT
@interface XRTCVideoFrame : NSObject

/** Width without rotation applied. */
@property(nonatomic, readonly) int width;

/** Height without rotation applied. */
@property(nonatomic, readonly) int height;
@property(nonatomic, readonly) RTCVideoRotation rotation;

/** Timestamp in nanoseconds. */
@property(nonatomic, readonly) int64_t timeStampNs;

/** Timestamp 90 kHz. */
@property(nonatomic, assign) int32_t timeStamp;

@property(nonatomic, readonly) id<XRTCVideoFrameBuffer> buffer;

//added by klaus for m76,about rendering
@property(nonatomic, assign) CGSize renderSize;//OpenGL渲染目标大小
@property(nonatomic, assign) BOOL mirror;//OpenGL渲染是否需要镜像，默认NO
@property(nonatomic, assign) BOOL localCameraFrame;//本地摄像头数据，OpenGL渲染时处理方向用（保持和系统相机预览行为一致），默认NO

- (instancetype)init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;

/** Initialize an XRTCVideoFrame from a pixel buffer, rotation, and timestamp.
 *  Deprecated - initialize with a XRTCCVPixelBuffer_Unique instead
 */
- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                           rotation:(RTCVideoRotation)rotation
                        timeStampNs:(int64_t)timeStampNs
    DEPRECATED_MSG_ATTRIBUTE("use initWithBuffer instead");

/** Initialize an XRTCVideoFrame from a pixel buffer combined with cropping and
 *  scaling. Cropping will be applied first on the pixel buffer, followed by
 *  scaling to the final resolution of scaledWidth x scaledHeight.
 */
- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                        scaledWidth:(int)scaledWidth
                       scaledHeight:(int)scaledHeight
                          cropWidth:(int)cropWidth
                         cropHeight:(int)cropHeight
                              cropX:(int)cropX
                              cropY:(int)cropY
                           rotation:(RTCVideoRotation)rotation
                        timeStampNs:(int64_t)timeStampNs
    DEPRECATED_MSG_ATTRIBUTE("use initWithBuffer instead");

/** Initialize an XRTCVideoFrame from a frame buffer, rotation, and timestamp.
 */
- (instancetype)initWithBuffer:(id<XRTCVideoFrameBuffer>)frameBuffer
                      rotation:(RTCVideoRotation)rotation
                   timeStampNs:(int64_t)timeStampNs;

/** Return a frame that is guaranteed to be I420, i.e. it is possible to access
 *  the YUV data on it.
 */
- (XRTCVideoFrame *)newI420VideoFrame;

@end

NS_ASSUME_NONNULL_END
