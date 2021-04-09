//
//  APMBase64.h
//  APMCommon
//
//  Created by Kris Tian on 2019/8/12.
//  Copyright © 2019 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APMBase64 : NSObject

+ (NSString *)base64EncodedStringWithString:(NSString *)string;

//+ (NSData *)base64DecodedDataWithEncodedData:(NSData *)encodedData;

+ (NSData *)base64DecodedDataWithEncodedString:(NSString *)encodedString;

@end

