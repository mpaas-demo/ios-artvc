//
//  APRemoteLogger+Internal.h
//  APRemoteLogging
//
//  Created by 卡迩 on 2017/4/12.
//  Copyright © 2017年 Alipay. All rights reserved.
//

#import "APRemoteLogging.h"

@class APLogManualPageInfo;

/**
 内部埋点使用的 bizType，需要从下面的 bizType 中获取，以规范埋点开关的管控
 */
typedef NS_ENUM(NSInteger, mPaaSBizType)
{
    mPaaS_Alive_iOS,       // 报活
    mPaaS_Launch_iOS,     // 启动速度
    mPaaS_LAG_iOS,        // 卡顿
    mPaaS_ANR_iOS,        // 卡死
    mPaaS_Crash_iOS,      // 闪退
    mPaaS_Automation_iOS, // 自动化
    mPaaS_HotPatch_iOS,   // hotpatch
    mPaaS_Push_iOS,       // 推送
    mPaaS_Sync_iOS,       // 同步
    mPaaS_Scan_iOS,       // 扫码
    mPaaS_Nebula_iOS,     // H5容器
    mPaaS_TinyApp_iOS,    // 小程序
    mPaaS_RPC_iOS,        // RPC
    mPaaS_Upgrade_iOS,    // 版本升级
    mPaaS_ConfigService_iOS, // 开关配置
    mPaaS_Share_iOS,       // 分享
    mPaaS_Storage_iOS,     // 统一存储
    mPaaS_LBS_iOS,         // LBS
    mPaaS_CDP_iOS,         // CDP
    mPaaS_Device_iOS,       // 设备标识
    mPaaS_TAC_iOS,          // TAC
    mPaaS_WebApp_iOS,       // webapp
    mPaaS_WebAppTiny_iOS,   // webapp-tiny
    mPaaS_NebulaTech_iOS,    // NebulaTech
    mPaaS_OCR_iOS,         // OCR
    mPaaS_SafeKeyboard_iOS, // 安全键盘
    mPaaS_Traffic_iOS,      // 流量监控
    mPaaS_Framework_iOS,     // 框架
    mPaaS_Multimedia_iOS,    //多媒体
};


//把APRemoteLogging.h中那堆不需要普通业务关注的接口移到了这里. by 卡迩
NS_ASSUME_NONNULL_BEGIN
@interface APRemoteLogger (Internal)

#pragma mark -
#pragma mark 兼容需要保留

#ifdef SDK_IS4_ALIPAY
/**
 *   注意：新的埋点不要调用此接口，为保持兼容以前的代码所以保留
 *              8.3之前的老的页面继续使用此接口，8.3新开的页面使用writeLogWithActionId:..这个接口
 *
 *  @param dict log 字典
 */
+(void)writeLogWithLogDictionary:(NSDictionary *) dict /*__deprecated*/;
#endif

#pragma mark -
#pragma mark Global State

/**
 获取最近一次手动PV埋点(pageMonitor)生成的pageInfo对象.

 @return 最近一次手动PV埋点生成的pageInfo对象.
 */
+ (nullable APLogManualPageInfo *)currentPageInfo;

/**
 获取最后点击的控件的spm值.

 @return 最后点击的控件的spm值(若有).
 */
+(nullable NSString *)lastClickSpm;

/**
 更新最后点击的spm值.
 @note 该方法供自动化埋点SDK调用,业务方不要使用.
 @param spm 最后点击的spm值.可以为空.
 */
+(void)setLastClickSpm:(nullable NSString *)spm;

#ifdef SDK_IS4_ALIPAY
/**
 *  界面点击的ActionToken(TraceID)
 *
 *  @return 最近界面点击的ActionToken(TraceID)
 */
+(nullable NSString *) currentActionToken;

/**
 *  界面点击的ActionToken的生成时间戳，为精简RPC包大小而提供
 *
 *  @return 最近界面点击的ActionToken的生成时间戳
 */
+(unsigned long long) tokenTimestamp;

/**
 *  界面点击的最近一个控件标识
 *
 *  @return 最近界面点击的最近一个控件标识
 */
+(nullable NSString *) currentActionControlID;

/**
 *  当前页面的ID
 *
 *  @return 当前页面的ID
 */
+(nullable NSString *) currentPageID;

+(nullable NSString *) lastPageID;
#endif

+(nullable NSString *) currentSubAppID;

#ifdef SDK_IS4_ALIPAY
+(void) resetCurrentPageId:(nonnull NSString *)pageId;
/**
 *  页面数据准备好到达可用状态，由业务主动调用
 *
 *  @return void
 */
+ (void)pageDidFinishInitializing;

/**
 *  字符串数组格式化转成str1|str2|str3格式字符串
 *
 *  @param array 字符串数组
 *
 *  @return 格式化后字符串
 */
+ (nonnull NSString *)convertToStringFromArray:(nonnull NSArray *)array;

/**
 *  设置扩展参数，支持扩展参数的日志模型（行为，性能）
 *  字典转成 key=value^key=value^key=value 格式字符串
 *
 *  @return void
 */
+ (void)setFoundationExtended:(nullable NSDictionary *)dict;

/**
 *  字典格式化 转成 key:value&key:value&key:value 格式字符串
 *
 *  @param dictionary 字典
 *  @param kvSeparator 可以为空，默认使用:连接，字典key和value的连接字符（比如key:value）
 *  @param componentsSeparator 可以为空，默认使用&连接，每队key，value组合后的连接字符（比如key:value&key:value）
 *  @return 格式化后的字符串
 *
 */
+ (nonnull NSString *)convertToStringFromDictionary:(nonnull NSDictionary *)dictionary
                                        kvSeparator:(nullable NSString *)separator1
                                componentsSeparator:(nullable NSString *)separator2;

#endif
/**
 *  取索引的pageid
 *  @param index  pageid索引
 *  @return 页面流水号
 */
+ (nullable NSString *)pageIdForIndex:(nonnull NSObject *)index;

#ifdef SDK_IS4_ALIPAY
/**
 *  取索引的pageid的时间戳
 *  @param index  pageid索引
 *  @return 页面流水号的时间戳
 */
+ (nullable NSString *)pageIdTimestampForIndex:(nonnull NSObject *)index;

/**
 *  取索引的spmid
 *  @param index  pageid索引
 *  @return 页面spmid
 */
+ (nullable NSString *)spmIdForIndex:(nonnull NSObject *)index;
#endif


/**
 *  取索引的信息
 *  @param index  pageid索引
 *  @param type  pageInfo类型
 *  @return 页面信息
 */
+ (nullable NSString *)pageInfomationForIndex:(nonnull NSObject *)index forType:(APRemoteLoggerPageInfomationType)type;

#ifdef SDK_IS4_ALIPAY
/**
 *  清除所有无效的历史流水号
 */
+ (void)resetPageMonitorContext;

/**
 *  向spmpage列表中添加page页
 */
+ (void)addSpmPage:(nonnull NSString *)spmPage;

/**
 *  得到日志等级
 */
+ (NSInteger)levelNumberForString:(nonnull NSString *)strLevel;

/**
 *  设置外部开关值
 */
+ (void)setSwitchValue:(nullable NSString *)value forKey:(nonnull NSString *)key;

/**
 设置统一开关值

 @param configDict 开关字典
 */
+(void)setSwitchDict:(NSDictionary *)configDict;

#endif

/**
 *  获取外部开关值
 */
+ (NSString *)switchValueForKey:(nonnull NSString *)key;

#ifdef SDK_IS4_ALIPAY
/**
 是否已经完成历史日志文件检查
 @note 在该方法返回YES后,触发某个bizType的日志的上报会附加上历史日志,否则只会上报本次启动产生的日志
 @return 在启动完成一定时间后会捞取历史日志到内存中,当该动作已完成时,返回 YES, 否则返回 NO.
 */
+ (BOOL)isHistoryLogFileChecked;

/**
 自动化埋点记录的refer值(若有)
 @return 当前自动化埋点记录的refer值(若有)，未引入autotracker时，总是返回nil.
 */
+ (nullable NSString *)currentAutoRefer;

#pragma mark -
#pragma mark 以下函数业务不要调用

+(void)mPaaS_writeCrashLog:(NSString *) report vcStack:(NSString *) vcStack;
+(NSDictionary*)stateWhenCrashed:(NSString*)vcStack thread:(thread_t)thread ucontext:(void *)ucontext;
+(void)mPaaS_writeCrashLog:(NSString *)report state:(NSDictionary*)state innerVersion:(NSString *)innerVersion;
+(void)writeOOMLog:(NSString *)report state:(NSDictionary *)infoDic;

+ (void)writePerformanceLogWithType:(APLogType)type
                            subType:(NSString *) subType
                        extraParams:(NSArray *) extraParams
                    actionControlID:(NSString *) controlID
                         actionToke:(NSString *) actionToken;
+(void)upload;
#endif
+ (void)protectExtentionParams:(NSMutableArray *)params;

#ifdef SDK_IS4_ALIPAY
+(void) logAutoEventWithBizType:(NSString*)bizType params:(NSArray*)params;
+(void) logPageBeginRenderWithPageName:(NSString *) name;
+(void) logPageStartWithPageId:(NSString *) pageId appId:(NSString *) appId
                   sourceAppId:(NSString *) sourceAppId pageName:(NSString *) pageName;

+ (void)logPageMonitorWithMonitorType:(NSString *)monitorType;
+ (NSString *)logPageMonitorType;

NSString *pageDidAppearName(NSString *pageName);
+ (void)logPageEndRenderWithPageName:(NSString *)name;

+(BOOL) statusForWriteLogSwitch:(NSString*) logType;
+(BOOL) statusForSendLogSwitch:(NSString*) logType;

+(void) checkCrashLogWithCompletionBlock:(void (^)(void)) block;
void updateSwitchProfile(NSString *actionType);

// 添加OC版本的接口，为了利用OC的动态特性实现模块间解耦合
+ (void)SLWriteMonitorLog:(NSDictionary*)attachDict appID:(NSString*)appID monitorType:(NSString*)monitorType subMonitorType:(NSString*)subMonitorType mPaaSBizType:(mPaaSBizType)bizType;
+ (void)APWriteNetLog:(NSString*)identifier size:(NSString*)size type:(NSString*)type owner:(NSString*)owner extDict:(NSDictionary*)extDict;
void APWriteNetLog(NSString *identifier, NSString *size, NSString* type, NSString *owner, NSDictionary * extDict);

///**
// *   暂停日志上传，最大暂停时间为60s，时间过后自动打开日志上传
// *   设置这个机制的原因是防止调用方异常，没有调用resumeLogUploading等情况下，导致日志无法上传。
// *
// *  @param secondes 自定义的日志暂停上传时间，最大值为60s，最小值为1s，其余值将导致默认暂停10s
// */
//+(void) suspendLogUploadingForSeconds:(int) seconds;

///**
// *   立即恢复日志上传功能
// */
//+(void) resumeLogUploading;

#endif

/**
 添加周期性执行的block. 每30s执行一次.
 */
+(void)addPeriodicallyExecutedBlock:(void (^)(void))block;

#pragma mark - Interface for Alipayinside

/**
 添加自定义bizType 内容 日志
 */
+ (void)writeLogWithCustomContent:(NSString *) content
                          bizType:(NSString *) bizType;

#ifdef SDK_IS4_TAOBAO
/**
 * 设置用户的id跟认证信息
 * @param userId,登录用户的用户id
 */
+ (void)setUserId:(NSString *)userId;

#endif

/**
 @param module 模块名称，如APMobileFramework。此值对应自定义分析大盘配置中的事件，即一个模块对一个事件

 @param params 参数信息，以字典形式存入，key对应自定义分析配置中的属性

 */
- (void)writeMPaaSSDKLogWithModule:(NSString *)module params:(NSDictionary *)params;



#pragma mark - 仅 mPaaS 内部使用


+ (NSString *)getMPaaSBaseline;


/**
 内部专用行为埋点接口，用于组件状态上报
 @param bizType 埋点业务类型，必传，用于埋点开关控制，需要使用上面定义枚举
 @param seed    埋点ID，必传，用于数据清洗
 @param extraParams 埋点扩展参数数组，@{"", "", "", @{}}
 */
+ (void)writeBehaviorLogWithBizType:(mPaaSBizType)bizType
                              seed:(nonnull NSString *)seed
                       extraParams:(nonnull  NSArray *)extraParam;


/**
 内部专用复杂行为埋点接口
 */
+ (void)writeBehaviorLogWithActionId:(NSString *)actionId
                           extParams:(NSArray *)extraParam
                               appId:(NSString *)appId
                                seed:(NSString *)seed
                                ucId:(NSString *)ucId
                             bizType:(mPaaSBizType)bizType
         formatterDictionary:(NSDictionary *)formatterDictionary;

/**
 专用性能接口，上报大盘使用的性能埋点
 @param bizType 埋点业务类型，必传，用于埋点开关控制，需要使用上面定义枚举
 @param number 日志上报条数阈值。当传入 0 时，底层方法会取默认上报条数阈值。
 */
+ (void)mPaaS_writePerformanceLogWithType:(mPaaSBizType)type
                                  subType:(nullable NSString *)subType
                              extraParams:(nullable NSArray *)extraParams
                      formatterDictionary:(nullable NSDictionary *)formatterDictionary
                             perUploadNum:(NSUInteger)number;


/**
 卡死日志上报
 */
+ (void)mPaaS_writeANRPerformanceLogWithBizType:(mPaaSBizType)bizType
                               subType:(nullable NSString *)subType
                           extraParams:(nullable NSArray *)extraParams
                   formatterDictionary:(nullable NSDictionary *)dictionary
                          perUploadNum:(NSUInteger)number;

/**
 卡顿日志上报
 */
void  mPaaS_SLWriteMonitorLog(NSDictionary * attachDict, NSString* appID, NSString *monitorType, NSString *subMonitorType, mPaaSBizType bizType);

/**
 * 网络类型
 */
+ (NSString *)currentNetEnvString;


@end
NS_ASSUME_NONNULL_END
