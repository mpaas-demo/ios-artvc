//
//  APHttpLog.h
//  test
//
//  Created by tashigaofei on 14-9-18.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTNetLog : NSObject

@property(nonatomic, copy) NSString *URL;
@property(nonatomic, copy) NSString *Host;
@property(nonatomic, copy) NSString *API;
@property(nonatomic, copy) NSString *Duration;
@property(nonatomic, copy) NSString *UploadSize;
@property(nonatomic, copy) NSString *DownloadSize;
@property(nonatomic, copy) NSString *ReqHdrSize;
@property(nonatomic, copy) NSString *ResHdrSize;
@property(nonatomic, copy) NSString *Stat;
@property(nonatomic, copy) NSString *Page;
@property(nonatomic, copy) NSString *NetType;
@property(nonatomic, copy) NSString *Owner;
//@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, copy) NSString *MIMEType;
@property(nonatomic, assign) BOOL isH5Log;
@property(nonatomic, copy) NSString *channel;
@property(nonatomic, copy) NSString *errorCode;

-(NSDictionary *) dictionaryRepresentation;
-(int) dataSize;

@end

@interface MTModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *) dictionaryRepresentation;
@end

@interface MTURLStat : MTModel
@property(nonatomic, strong) NSNumber *times;
@property(nonatomic, strong) NSNumber *size;
@property(nonatomic, strong) NSNumber *lastSize;
@property(nonatomic, strong) NSNumber *failTimes;
@property(nonatomic, strong) NSString *bundle;
@property(nonatomic, copy) NSString *channel;
@end

@interface MTBundleStat : MTModel
@property(nonatomic, strong) NSNumber *times;
@property(nonatomic, strong) NSNumber *size;
@property(nonatomic, strong) NSNumber *failTimes;
@property(nonatomic, strong) NSString *bundle;
@end

@interface MTHostStat : MTModel
@property(nonatomic, strong) NSNumber *size;
@end

@interface MTOverViewStat : MTModel
@property(nonatomic, strong) NSNumber *size;
@property(nonatomic, strong) NSNumber *uploadSize;
@property(nonatomic, strong) NSNumber *downloadSzie;
@property(nonatomic, strong) NSNumber *mobileUploadSize;
@property(nonatomic, strong) NSNumber *mobileDownloadSzie;
@end

@interface MTNetException : MTModel
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *times;
@property(nonatomic, strong) NSNumber *hostSzie;
@property(nonatomic, strong) NSNumber *httpSize;
@property(nonatomic, strong) NSString *page;
@property(nonatomic, strong) NSString *bundle;
@end

@interface MTRequestHistory : MTModel
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *bundle;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *size;
@end

@interface MTPVHistory : MTModel
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *bundle;
@property (nonatomic, strong) NSNumber *time;
@end

@interface MTScoreUnit : MTModel
@property (nonatomic, strong) MTPVHistory *pv;
@property (nonatomic, strong) NSMutableArray *requests;
@end


