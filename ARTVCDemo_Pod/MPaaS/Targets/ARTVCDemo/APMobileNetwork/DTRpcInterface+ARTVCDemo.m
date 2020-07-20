//
//  DTRpcInterface+ARTVCDemo.m
//  ARTVCDemo
//
//  Created by kuoxuan on 2020/07/17. All rights reserved.
//

#import "DTRpcInterface+ARTVCDemo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation DTRpcInterface (ARTVCDemo)

- (NSString*)gatewayURL
{
    return @"https://mpaas-mgs.aliyuncs.com/mgw.htm";
}

- (NSString*)signKeyForRequest:(NSURLRequest*)request
{
    return @"ONEX41E7C28061348_IOS";
}

- (NSString *)productId
{
    return @"ONEX41E7C28061348";
}

- (NSString*)commonInterceptorClassName
{
    return @"DTRpcCommonInterceptor";
}

@end

#pragma clang diagnostic pop

