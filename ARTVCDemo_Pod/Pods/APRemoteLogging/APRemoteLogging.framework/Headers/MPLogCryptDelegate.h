//
//  MPLogCryptDelegate.h
//  APRemoteLogging
//
//  Created by kuoxuan on 2020/7/16.
//  Copyright © 2020 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPLogCryptDelegate <NSObject>

/**
 埋点加密方法
 */
- (NSString *)logEnCrypt:(NSString *)input;

/**
 埋点解密方法
 */
- (NSString *)logDeCrypt:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
