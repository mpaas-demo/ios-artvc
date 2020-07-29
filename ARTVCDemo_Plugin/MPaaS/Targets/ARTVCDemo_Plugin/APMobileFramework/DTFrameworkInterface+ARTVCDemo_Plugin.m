//
//  DTFrameworkInterface+ARTVCDemo_Plugin.m
//  ARTVCDemo_Plugin
//
//  Created by 阔悬 on 2020/07/29.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import "DTFrameworkInterface+ARTVCDemo_Plugin.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation DTFrameworkInterface (ARTVCDemo_Plugin)

- (BOOL)shouldLogReportActive
{
    return YES;
}

- (NSTimeInterval)logReportActiveMinInterval
{
    return 0;
}

- (BOOL)shouldLogStartupConsumption
{
    return YES;
}

- (BOOL)shouldAutoactivateBandageKit
{
    return YES;
}

- (BOOL)shouldAutoactivateShareKit
{
    return YES;
}

- (DTNavigationBarBackTextStyle)navigationBarBackTextStyle
{
    return DTNavigationBarBackTextStyleAlipay;
}

@end

#pragma clang diagnostic pop
