/*
 *  Copyright 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCVideoFrame.h"

#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class XRTCVideoCapturer;

XRTC_OBJC_EXPORT
@protocol XRTCVideoCapturerDelegate <NSObject>
- (void)capturer:(XRTCVideoCapturer *)capturer didCaptureVideoFrame:(XRTCVideoFrame *)frame;
@end

XRTC_OBJC_EXPORT
@interface XRTCVideoCapturer : NSObject

@property(nonatomic, weak) id<XRTCVideoCapturerDelegate> delegate;

- (instancetype)initWithDelegate:(id<XRTCVideoCapturerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
