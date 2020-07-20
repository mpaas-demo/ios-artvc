//
//  APMSystemInfo.h
//  APMUtils
//
//  Created by klaus on 2019/4/16.
//  Copyright © 2019 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMSystemInfo : NSObject
//CFBundleShortVersionString = "10.1.62",return @"null" if cann't find one
+(NSString*)shortAppVersion;
//CFBundleVersion = "10.1.62.000001";,return @"null" if cann't find one
+(NSString*)buildAppVersion;
//DTPlatformVersion = "12.2";,return @"null" if cann't find one
+(NSString*)iOSVersion;
//@"iPhone10,3",return @"null" if cann't find one
//see https://www.theiphonewiki.com/wiki/Models
+(NSString*)detailDeviceModel;
@end

NS_ASSUME_NONNULL_END
