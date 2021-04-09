//
//  MPaaSInterface+ARTVCDemo_Plugin.m
//  ARTVCDemo_Plugin
//
//  Created by shaochangying on 2021/04/09.
//  Copyright © 2021 Alibaba. All rights reserved.
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
