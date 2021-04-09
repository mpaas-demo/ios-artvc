//
//  APMRemoteLog.h
//  APMUtils
//
//  Created by tao zeng on 2017/10/17.
//  Copyright © 2017年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

static  NSString * _Nonnull const kEventActionID = @"event";


typedef NS_ENUM (NSUInteger, APMRemoteLogLevel) {
    APMRemoteLogLevelHigh,//关键业务日志
    APMRemoteLogLevelMedium,//普通业务日志
    APMRemoteLogLevelLow, //问题诊断类日志
};

@interface APMRemoteLog : NSObject


+ (void)writeLogWithActionId:(nonnull NSString *)actionId
                   extParams:(nullable NSArray *)extParams
                       appId:(nullable NSString *)appId
                        seed:(nullable NSString *)seed
                        ucId:(nullable NSString *)ucId;

+(void)writeLogWithActionId:(nonnull NSString *)actionId
                  extParams:(nullable NSArray *)extParams
                      appId:(nullable NSString *)appId
                       seed:(nullable NSString *)seed
                       ucId:(nullable NSString *)ucId
                    bizType:(nullable NSString *)bizType;

+(void)writeLogWithActionId:(nonnull NSString *)actionId
                  extParams:(nullable NSArray *)extParams
                      appId:(nullable NSString *)appId
                       seed:(nullable NSString *)seed
                       ucId:(nullable NSString *)ucId
                    bizType:(nullable NSString *)bizType
                   logLevel:(APMRemoteLogLevel)logLevel;

+ (void)writeLogWithActionId:(nonnull NSString *)actionId
                   extParams:(nullable NSArray *)extParams
                       appId:(nullable NSString *)appId
                        seed:(nullable NSString *)seed
                        ucId:(nullable NSString *)ucId
                     bizType:(nullable NSString *)bizType
         formatterDictionary:(nullable NSDictionary *)formatterDictionary;

//mpaas only.bizType is mPaaS_Multimedia_iOS
//category override by APMLogging.framework 's mpaas version.
+ (void)mpaas_writeLogWithActionId:(nonnull NSString *)actionId
                         extParams:(nullable NSArray *)extParams
                             appId:(nullable NSString *)appId
                              seed:(nullable NSString *)seed
                              ucId:(nullable NSString *)ucId
               formatterDictionary:(nullable NSDictionary *)formatterDictionary;

@end
