//
//  MPaaSInterface+ARTVCDemo_Plugin.m
//  ARTVCDemo_Plugin
//
//  Created by 阔悬 on 2020/07/29.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import "MPaaSInterface+ARTVCDemo_Plugin.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation MPaaSInterface (ARTVCDemo_Plugin)

- (BOOL)enableSettingService
{
    return NO;
}

- (NSString *)userId
{
    return nil;
}

@end

#pragma clang diagnostic pop
