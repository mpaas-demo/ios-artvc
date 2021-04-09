//
//  APMDefaultCryptInterface.h
//  APMUtils
//
//  Created by Kris Tian on 2020/6/5.
//  Copyright © 2020 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMDefaultCryptInterface : NSObject

/// 使用特定的key和对成加密算法对二进制加密, 可使用decryptData解密
/// @param data 待加密数据
+ (NSData*)encryptData:(NSData*)data;

/// 对encryptData数据进行解密
/// @param data 待解密数据
+ (NSData*)decryptData:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
