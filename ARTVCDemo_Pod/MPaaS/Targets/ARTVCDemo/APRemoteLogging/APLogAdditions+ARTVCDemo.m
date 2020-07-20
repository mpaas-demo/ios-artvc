//
//  APLogAdditions+ARTVCDemo.m
//  ARTVCDemo
//
//  Created by kuoxuan on 2020/07/17. All rights reserved.
//

#import "APLogAdditions+ARTVCDemo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation APLogAdditions (ARTVCDemo)

- (NSString*)logServerURL
{
    return @"https://mpaas-mas-loggw.aliyuncs.com/loggw/logUpload.do";
}

- (NSArray*)defaultUploadLogTypes
{
    return @[@(APLogTypeBehavior), @(APLogTypeCrash), @(APLogTypeAuto), @(APLogTypeMonitor), @(APLogTypeKeyBizTrace), @(APLogTypePerformance)];
}

- (NSString *)platformID
{
    return @"ONEX41E7C28061348_IOS-shaojian";
}

@end

#pragma clang diagnostic pop

