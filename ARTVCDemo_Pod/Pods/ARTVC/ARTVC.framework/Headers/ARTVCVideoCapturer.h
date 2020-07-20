//
//  ARTVCVideoCapturer.h
//  sources
//
//  Created by klaus on 2019/8/23.
//

#import <Foundation/Foundation.h>
#import "RTCVideoCapturer.h"
NS_ASSUME_NONNULL_BEGIN
@class XRTCVideoSource;
@class XRTCCameraVideoCapturer;
//export for testing
XRTC_OBJC_EXPORT
@interface ARTVCVideoCapturer : NSObject
@property(nonatomic,assign,readonly)BOOL capturerStarted;
/**default is NO*/
@property(nonatomic,assign) BOOL useBackCamera;
/**default is 1280*/
@property(nonatomic,assign) int width;
/**default is 720*/
@property(nonatomic,assign) int height;
/**default is 30*/
@property(nonatomic,assign) int fps;
@property(nonatomic,strong,readonly)XRTCCameraVideoCapturer* capturer;
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithSource:(XRTCVideoSource*)source;
//TODO:test-only,remove it or refactor it later.
-(instancetype)initWithDelete:(id<XRTCVideoCapturerDelegate>)source;
-(BOOL)startCapture;
-(BOOL)stopCapture;
-(BOOL)switchCamera;
/**
 check current camera position is  back  or not,if true,return YES.
 */
-(BOOL)currentCameraPositionIsBack;
@end

NS_ASSUME_NONNULL_END
