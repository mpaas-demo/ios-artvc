//
//  ARTVCDemoConferenceVC.h
//  AntMedia
//
//  Created by aspling on 2017/7/20.
//  Copyright © 2017年 aspling. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ARTVCDemoConferenceVC : UIViewController
@property (nonatomic,copy) NSString* roomId;
@property (nonatomic,copy) NSString* rtoken;
@property (nonatomic,assign) BOOL audioOnly;
@property (nonatomic,assign) BOOL testAliyunSDK;
@property (nonatomic,assign) BOOL testBroadcast;
@property(nonatomic,assign) BOOL testCustomVideoCapture;
@end
