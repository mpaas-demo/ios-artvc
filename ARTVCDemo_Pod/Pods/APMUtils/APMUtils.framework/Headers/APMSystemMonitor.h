//
//  APMSystemMonitor.h
//  APMUtils
//
//  Created by tao zeng on 2019/4/26.
//  Copyright © 2019 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMSystemMonitor : NSObject

/**
 *  获取当前进程CPU使用率，如0.1即表示10%
 */
+ (float)cpuUsage;

@end

NS_ASSUME_NONNULL_END
