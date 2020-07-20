//
//  ARTVCStatisticSendProtocol.h
//  ARTVC
//
//  Created by aspling on 2018/5/9.
//  Copyright © 2018年 Alipay. All rights reserved.
//
#import "RTCMacros.h"
#ifdef ARTVC_ENABLE_STATS
#ifndef ARTVCStatisticSendProtocol_h
#define ARTVCStatisticSendProtocol_h
#import "ARTVCStatisticTypes.h"

/**
 * 消息发送protocol定义
 */
XRTC_OBJC_EXPORT
@protocol ARTVCStatisticSendProtocol <NSObject>
@optional
-(void)sendStatisticReport:(ARTVCStatisticReportBase*)report;
@end
#endif /* ARTVCStatisticSendProtocol_h */
#endif
