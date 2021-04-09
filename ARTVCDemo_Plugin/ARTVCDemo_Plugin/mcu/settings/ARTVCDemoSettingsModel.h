/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#import <Foundation/Foundation.h>
#import <ARTVC/RTCMacros.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * Model class for user defined settings.
 *
 * Currently used for streaming media constraints and bitrate only.
 * In future audio media constraints support can be added as well.
 * Offers list of avaliable video resolutions that can construct streaming media constraint.
 * Exposes methods for reading and storing media constraints from persistent store.
 * Also translates current user defined media constraint into XRTCMediaConstraints
 * dictionary.
 */
@interface ARTVCDemoSettingsModel : NSObject

/**
 * Returns array of available capture resoultions.
 *
 * The capture resolutions are represented as strings in the following format
 * [width]x[height]
 */
- (NSArray<NSString *> *)availableVideoResoultionsMediaConstraints;

/**
 * Returns current video resolution media constraint string.
 * If no constraint is in store, default value of 640x480 is returned.
 * When defaulting to value, the default is saved in store for consistency reasons.
 */
- (NSString *)currentVideoResoultionConstraintFromStore;

/**
 * Stores the provided video resolution media constraint string into the store.
 *
 * If the provided constraint is no part of the available video resolutions
 * the store operation will not be executed and NO will be returned.
 * @param constraint the string to be stored.
 * @return YES/NO depending on success.
 */
- (BOOL)storeVideoResoultionConstraint:(NSString *)constraint;

/**
 * Converts the current media constraints from store into dictionary with XRTCMediaConstraints
 * values.
 *
 * @return NSDictionary with RTC width and height parameters
 */
- (nullable NSDictionary *)currentMediaConstraintFromStoreAsRTCDictionary;

-(NSUInteger)currentBitrate;
-(void)storeBitrate:(NSUInteger)value;
-(NSUInteger)currentFramerate;
-(void)storeFramerate:(NSUInteger)value;
-(BOOL)isOnlineServer;
-(void)storeServerconfig:(BOOL)value;
-(BOOL)isDtlsDisabled;
-(void)storeDtlsDisabled:(BOOL)disabled;
-(BOOL)isRelaySpecified;
-(void)storeRelayMode:(BOOL)relay;

-(NSString*)serverUrl:(BOOL)p2p;

-(BOOL)eanblePublish;
-(void)setEnablePublish:(BOOL)value;
-(BOOL)eanbleSubscribe;
-(void)setEnableSubscribe:(BOOL)value;

-(BOOL)eanbleFlexFEC;
-(void)setEnableFlexFEC:(BOOL)value;

-(NSString*)bweExperimentFlag;
-(void)setBweExperimentFlag:(NSString*)value;

-(BOOL)eanbleInviteAfterCreateRoom;
-(void)setEanbleInviteAfterCreateRoom:(BOOL)value;

-(NSString*)inviteeUid;
-(void)setInviteeUid:(NSString*)value;

-(NSString*)liveUrl;
-(void)setLiveUrl:(NSString*)value;

-(NSString*)uid;
-(void)setUid:(NSString*)value;

-(NSString*)bizname;
-(void)setBizname:(NSString*)value;
-(NSString*)subbiz;
-(void)setSubbiz:(NSString*)value;
-(NSString*)signature;
-(void)setSignature:(NSString*)value;
-(NSString*)customServerUrl;
-(void)setCustomServerUrl:(NSString*)value;

-(BOOL)enableUseBloxWay;
-(void)setUseBloxWayChanged:(BOOL)value;
-(NSString*)beautyLevel;
-(void)setBeautyLevel:(float)level;
-(BOOL)enableVirtualBG;
-(void)setVirtualBG:(BOOL)value;
-(NSString*)pacingExperiment;
-(void)setPacingExperiment:(NSString*)value;
-(NSString*)nackExperiment;
-(void)setNackExperiment:(NSString*)value;
-(NSString*)playoutDelayExperiment;
-(void)setPlayoutDelayExperiment:(NSString*)value;
-(NSString*)jitterExperiment;
-(void)setJitterExperiment:(NSString*)value;
-(NSString*)mockedConfigs;
-(void)setMockedConfigs:(NSString*)value;
-(BOOL)isVideoSmoothRenderingDisabled;
-(void)disableVideoSmoothRendering:(BOOL)value;
-(BOOL)isLoopbackTestEnabled;
-(void)enableLoopbackTest:(BOOL)value;
#ifdef ARTVC_BUILD_FOR_MPAAS
-(void)setWorkspaceId:(NSString*)workspaceId;
-(NSString*)workspaceId;
#endif
@end
NS_ASSUME_NONNULL_END
