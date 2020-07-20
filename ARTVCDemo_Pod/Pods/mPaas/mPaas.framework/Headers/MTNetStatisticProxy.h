//
//  MTNetStatisticProxy.h
//  APMonitor
//
//  为了优化启动速度，控制启动时机
//
//  Created by myy on 17/4/17.
//  Copyright © 2017年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTNetModel.h"


@interface MTNetStatisticProxy : NSObject

+(instancetype)sharedInstance;

+ (void)setNetMonitorEnable:(BOOL)enable;
+ (BOOL)netMonitorEnable;
-(void)markBootFinish; //标识app启动完成，从而延迟触发一些配置解析和统计逻辑
-(BOOL)doFilter:(MTNetLog *) logInfo withLoging:(BOOL) logging;
-(void)doStat:(MTNetLog *) log;
-(NSString *) getAndClearScoreOverview;
-(NSString *) getDataFlowOverview;
-(NSDictionary*) getAndClearReportData;
-(NSString *) getAndClearBundlesStat;
//-(void) saveStatData;
-(NSString *) getNetAverageScore;
- (NSDictionary *)getAndClearDetailReportData;

@end
