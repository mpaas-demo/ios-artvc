//
//  NSDictionary+DTExtensions.h
//  APContact
//
//  Created by 逆仞 on 14-3-18.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef id (^NSDictionaryObjectValidator)(id object);


/**
 * DTExtensions for reading value for key
 * @see NSUserDefaults
 */
@interface NSDictionary (DTExtensions)

/* C */
- (float)floatForKey_mp:(id)aKey;
- (float)floatForKey_mp:(id)aKey defaultValue:(float)defaultValue;
- (double)doubleForKey_mp:(id)aKey;
- (double)doubleForKey_mp:(id)aKey defaultValue:(double)defaultValue;
/* C More */
- (long long)longLongForKey:(id)aKey;
- (unsigned long long)unsignedLongLongForKey:(id)aKey;

/* OC */
- (BOOL)boolForKey_mp:(id)aKey;
- (BOOL)boolForKey_mp:(id)aKey defaultValue:(BOOL)defaultValue;
- (NSInteger)integerForKey_mp:(id)aKey;
- (NSInteger)integerOrNotFoundForKey:(id)aKey;
- (NSInteger)integerForKey_mp:(id)aKey defaultValue:(NSInteger)defaultValue;

/* OC More */
- (NSUInteger)unsignedIntegerForKey_mp:(id)aKey;
- (NSUInteger)unsignedIntegerOrNotFoundForKey:(id)aKey;
- (NSUInteger)unsignedIntegerForKey:(id)aKey defaultValue:(NSUInteger)defaultValue;

/* OC Object */
- (NSNumber *)numberForKey_mp:(id)aKey;
- (NSNumber *)numberForKey:(id)aKey defaultValue:(NSNumber *)defaultValue;
- (NSString *)stringForKey_mp:(id)aKey;
- (NSString *)stringOrEmptyStringForKey:(id)akey;
- (NSString *)stringForKey:(id)akey defaultValue:(NSString *)defaultValue;
- (NSArray *)arrayForKey_mp:(id)aKey;
- (NSArray *)arrayForKey:(id)aKey defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)dictionaryForKey_mp:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey defaultValue:(NSDictionary *)defaultValue;
- (NSData *)dataForKey_mp:(id)aKey;
- (NSData *)dataForKey:(id)aKey defaultValue:(NSData *)defaultValue;
- (NSDate *)dateForKey_mp:(id)aKey;
- (NSDate *)dateForKey:(id)aKey defaultValue:(NSDate *)defaultValue;
- (NSURL *)URLForKey:(id)aKey;
- (NSURL *)URLForKey:(id)aKey defaultValue:(NSURL *)defaultValue;

/* OC Object More */
- (id)objectForKey:(id)aKey class:(Class)theClass;
- (id)objectForKey:(id)aKey class:(Class)theClass defaultValue:(id)defaultValue;
- (id)objectForKey:(id)aKey protocol:(Protocol *)protocol;
- (id)objectForKey:(id)aKey protocol:(Protocol *)protocol defaultValue:(id)defaultValue;
- (id)objectForKey:(id)aKey class:(Class)theClass protocol:(Protocol *)protocol;
- (id)objectForKey:(id)aKey class:(Class)theClass protocol:(Protocol *)protocol defaultValue:(id)defaultValue;
- (id)objectForKey:(id)aKey callback:(NSDictionaryObjectValidator)callback;

@end


/**
 * DTExtensions for writing value for key
 */
@interface NSMutableDictionary (DTExtensions)

/* C */
- (void)setFloat_mp:(float)value forKey:(id<NSCopying>)aKey;
- (void)setDouble_mp:(double)value forKey:(id<NSCopying>)aKey;

/* C More */
- (void)setLongLong_mp:(long long)value forKey:(id<NSCopying>)aKey;
- (void)setUnsignedLongLong_mp:(unsigned long long)value forKey:(id<NSCopying>)aKey;

/* OC */
- (void)setBool_mp:(BOOL)value forKey:(id<NSCopying>)aKey;
- (void)setInteger_mp:(NSInteger)value forKey:(id<NSCopying>)aKey;

/* OC More */
- (void)setUnsignedInteger_mp:(NSUInteger)value forKey:(id<NSCopying>)aKey;

/* OC Object */
- (void)setObjectOrNil:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 *  @brief 给可变字典设置对象，如果对象为nil，直接返回不修改原始数据
 *
 *  @param anObject obj
 *  @param aKey     key
 */
- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

