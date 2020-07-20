/*
 *  Copyright 2017 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <Foundation/Foundation.h>

#import "RTCVideoCapturer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Captures buffers by API Caller itself.meantime，as a caller,delegate here MUST NOT be set by caller.it's designed to be used by SDK only.
 *
 * See @c XRTCVideoCapturer for more info on capturers.
 */
XRTC_OBJC_EXPORT
@interface ARTVCCustomVideoCapturer : XRTCVideoCapturer
///**
// * Starts asynchronous capture of frames
// */
//- (void)startCapture;
//
///**
// * Immediately stops capture.
// */
//- (void)stopCapture;
/**
 provide custom video frame periodly,act as camera's output,frame rate  15FPS/30FPS e.g.
 provied sample MUST be with rotation Zero.
 */
-(void)provideCustomVideoFramePeriodlyWith:(CVPixelBufferRef)sampleBuffer;
@end

NS_ASSUME_NONNULL_END
