//
//  NSString+Ant3DJsonStrToDictionary.h
//  Ant3D
//
//  Created by Monster on 2019/5/31.
//  Copyright © 2019年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (APMJSONSerialization)

- (NSDictionary *)apm_JSONObject;
@end

NS_ASSUME_NONNULL_END
