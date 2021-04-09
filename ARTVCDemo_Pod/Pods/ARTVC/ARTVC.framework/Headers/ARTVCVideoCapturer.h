//
//  ARTVCVideoCapturer.h
//  sources
//
//  Created by klaus on 2019/8/23.
//

#import <Foundation/Foundation.h>
#import "RTCVideoCapturer.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class XRTCVideoSource;
@class XRTCCameraVideoCapturer;
//export for testing
XRTC_OBJC_EXPORT
@protocol ARTVCVideoCapturerDelegate <NSObject>
- (void)didVideoCapturerEncounterError:(NSError *)error;
- (void)didFirstFrameRendered:(UIView *)view;
@end
XRTC_OBJC_EXPORT
@interface ARTVCVideoCapturer : NSObject
@property(nonatomic,weak) id<ARTVCVideoCapturerDelegate> delegate;
@property(nonatomic,assign)BOOL useSmartAVProcessing;
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

// clean background relative
/** The threshold sensitivity controls how similar pixels need to be colored to be replaced
    The default value is 0.35
*/
@property (nonatomic, assign) float threshold;
/** The degree of smoothing controls how gradually similar colors are replaced in the image
    The default value is 0.09
*/
@property (nonatomic, assign) float smoothing;
/** The color to be cleaned
    The default value is green, 0x00FF00
*/
@property (nonatomic, assign) int backgroundColor;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithSource:(XRTCVideoSource*)source;
-(instancetype)initWithSource:(XRTCVideoSource *)source useSmartAVProcessing:(BOOL)useSmartAVProcessing;
//TODO:test-only,remove it or refactor it later.
-(instancetype)initWithDelete:(id<XRTCVideoCapturerDelegate>)source;
-(BOOL)startCapture;
-(BOOL)stopCapture;
-(BOOL)switchCamera;
/**
 check current camera position is  back  or not,if true,return YES.
 */
-(BOOL)currentCameraPositionIsBack;
/**
 blox's methods
 */
-(void)setBeautyLevel:(float)level;
-(void)setBackImageToGLSynthesizeWithImage:(UIImage *)image;
-(void)setMainViewer:(UIView *)view;
-(void)startCameraSourceWithBackCamera:(BOOL)backCamera;
-(void)setContentMode:(UIViewContentMode)contentMode;
-(UIImage *)snapshotForLocalCamera;
@end

NS_ASSUME_NONNULL_END
