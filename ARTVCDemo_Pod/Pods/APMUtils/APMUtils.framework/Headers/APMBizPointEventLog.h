//
//  APMPointMonitor.h
//  APMUtils
//
//  Created by Kris Tian on 2019/6/20.
//  Copyright © 2019 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMBizPointEventLog : NSObject

/**
 * 功能或关键业务不可用时的埋点上报
 *
 * bizName  业务名字            （字符串，如：BIZ_FRAME，BIZ_NETWORK，BIZ_SYNC，BIZ_MEDIA，以及其它业务自己定义）
 * subName  业务不可用功能点名字  （字符串，如：CLIENT_STARTUP_DEAD，以及其它业务自己定义）
 * failCode 不可用原因分类码     （整型值，业务自己定义）
 * params   埋点扩展参数        （dict，业务自己定义）
 */
+ (void)reportBiz:(NSString *)bizName event:(NSString* )event failCode:(NSInteger)code params:(NSDictionary*) params;

@end

NS_ASSUME_NONNULL_END
