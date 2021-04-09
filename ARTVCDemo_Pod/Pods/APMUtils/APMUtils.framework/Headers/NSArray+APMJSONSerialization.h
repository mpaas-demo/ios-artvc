//
//  NSArray+Ant3D_JSONSerialization.h
//  Ant3D
//
//  Created by Monster on 2019/9/5.
//  Copyright © 2019年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (APMJSONSerialization)

+ (NSString *)apm_objectToJson:(id)obj;

@end

NS_ASSUME_NONNULL_END
