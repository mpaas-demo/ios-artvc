//
//  APMAppContext.h
//  APMUtils
//
//  Created by Kris Tian on 2020/5/28.
//  Copyright © 2020 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

//<---- 此处定义和钱包app运行上下文的接口,接口内为空实现, APMAlipayAdapter中通过category画覆盖当前的方法实现-->

@interface APMAppContextInterface : NSObject

/// 获取当前支付宝的用户id
+ (NSString *)currentUserId;

/// 尝试刷新支付宝的cookie中的token值
+ (void)tryRefreshToken;

/// 获取付费音频的加密key
+ (NSString *)getPaidMusicEncryptKey;

/// 是否是后台启动
+ (BOOL)launchFromBackground;

/// 获取当前的NavigationController,如果获取不到,直接返回nil
+ (UINavigationController*)currentNavigationController;


/// 获取默认加密的key
+ (NSString *)getDefaultEncryptKey;

/// 磁盘空间不足告警通知
+ (NSString *)storageSpaceWarningNotificationKey;


@end

NS_ASSUME_NONNULL_END
