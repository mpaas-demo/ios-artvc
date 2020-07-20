//
//  ATUploader.h
//  APRemoteLogging
//
//  Created by 卡迩 on 2018/7/11.
//  Copyright © 2018年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATUploadRequest;
typedef void(^ATUploadCompletionBlock)(BOOL success,NSDictionary *info);

typedef NS_ENUM(NSUInteger,ATUploadChannel){
    ATChannelHTTP = 0,
    ATChannelMMTP = 1,
};

@interface ATUploader : NSObject

- (instancetype)initWithQueue:(NSOperationQueue *)queue NS_DESIGNATED_INITIALIZER;

- (void)enqueueRequest:(ATUploadRequest *)req;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLSession *urlSession;

- (NSArray<NSString *> *)filesToUpload:(NSString *)bizId;

//需要保证该方法在queue中调用
- (NSString *)uploadContentOfFile:(NSString *)path;

- (void)trashFiles:(NSArray *)paths;

// isEnable YES 设置为debug模式，日志文件上传后不会被删除，会移动到uploaded目录，默认为NO
+ (void)setDebugEnable:(BOOL)isEnable;


@end

////////////////////////////////////////////////////////////////////////////////

@interface ATUploadRequest : NSObject

@property (nonatomic, assign) ATUploadChannel channel;
@property (nonatomic, strong) NSString *bizId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSArray<NSString *> *filePaths;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy  ) ATUploadCompletionBlock completionBlock;
@property (nonatomic, strong) NSString *delayRate;/**削峰还原标志*/

@end
