//
//  APHttpManager.h
//  test
//
//  Created by tashigaofei on 14-9-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTNetModel.h"

#ifndef MTNetStatistic_H
#define MTNetStatistic_H
#define Filter_OK 1
#define Filter_Deny 0
#define MTH5PVChangeNotification @"MTH5PVChangedNotification"
#endif

@interface MTNetStatistic : NSObject
+ (void)doMTLoadWork;

-(BOOL) doFilter:(MTNetLog *) logInfo withLoging:(BOOL) logging;
-(void)doStat:(MTNetLog *) log;
-(NSString *) getAndClearScoreOverview;
-(NSString *) getDataFlowOverview;
-(NSDictionary*) getAndClearReportData;
-(NSString *) getAndClearBundlesStat;
//-(void) saveStatData;
-(void) deleteStatData;
+(BOOL) isNetHookEnable;
-(NSString *) getNetAverageScore;
-(NSDictionary *)getAndClearDetailReportData;
+ (void)saveCellularTrafficExceptionSize:(NSInteger)size; // 设置异常流量大小的阈值
@end


