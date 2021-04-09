/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
#import "ARTVCDemoSettingsModel+Private.h"
#import "ARTVCDemoSettingsStore.h"
//#import "WebRTC/RTCMediaConstraints.h"
#import <APMUtils/APMLog.h>
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "

#define DEFAULT_FRAMERATE 15
//means bitrate controlled by SDK itself ad default.
#define DEFAULT_BITRATE 0
#define ONLINESERVER @"wss://artvcroom.alipay.com:443/ws";
#define CONFTESTSERVER @"ws://artvcroom.d3119.dl.alipaydev.com/ws";
#define P2PTESTSERVER @"ws://artvcroom.inc.alipay.net/ws";
//#define TESTSERVER @"ws://artvcroom.alipaydev.com/ws";


NS_ASSUME_NONNULL_BEGIN
static NSArray<NSString *> *videoResolutionsStaticValues() {
  return @[ @"480x360" ,@"640x360",@"960x540",@"1280x720"];
}

@interface ARTVCDemoSettingsModel () {
  ARTVCDemoSettingsStore *_settingsStore;
}
@end

@implementation ARTVCDemoSettingsModel

- (NSArray<NSString *> *)availableVideoResoultionsMediaConstraints {
  return videoResolutionsStaticValues();
}

- (NSString *)currentVideoResoultionConstraintFromStore {
  NSString *constraint = [[self settingsStore] videoResolutionConstraintsSetting];
  if (!constraint) {
    constraint = [self defaultVideoResolutionMediaConstraint];
    // To ensure consistency add the default to the store.
    [[self settingsStore] setVideoResolutionConstraintsSetting:constraint];
  }
    APM_INFO(@"currentVideoResoultionConstraintFromStore:%@",constraint);
  return constraint;
}

- (BOOL)storeVideoResoultionConstraint:(NSString *)constraint {
  if (![[self availableVideoResoultionsMediaConstraints] containsObject:constraint]) {
    return NO;
  }
  [[self settingsStore] setVideoResolutionConstraintsSetting:constraint];
  return YES;
}

#pragma mark - Testable

- (ARTVCDemoSettingsStore *)settingsStore {
  if (!_settingsStore) {
    _settingsStore = [[ARTVCDemoSettingsStore alloc] init];
  }
  return _settingsStore;
}

- (nullable NSString *)currentVideoResolutionWidthFromStore {
  NSString *mediaConstraintFromStore = [self currentVideoResoultionConstraintFromStore];

  return [self videoResolutionComponentAtIndex:0 inConstraintsString:mediaConstraintFromStore];
}

- (nullable NSString *)currentVideoResolutionHeightFromStore {
  NSString *mediaConstraintFromStore = [self currentVideoResoultionConstraintFromStore];
  return [self videoResolutionComponentAtIndex:1 inConstraintsString:mediaConstraintFromStore];
}

#pragma mark -

- (NSString *)defaultVideoResolutionMediaConstraint {
  return videoResolutionsStaticValues()[1];
}

- (nullable NSString *)videoResolutionComponentAtIndex:(int)index
                                   inConstraintsString:(NSString *)constraint {
  if (index != 0 && index != 1) {
    return nil;
  }
  NSArray *components = [constraint componentsSeparatedByString:@"x"];
  if (components.count != 2) {
    return nil;
  }
  return components[index];
}

#pragma mark - Conversion to XRTCMediaConstraints

- (nullable NSDictionary *)currentMediaConstraintFromStoreAsRTCDictionary {
  NSDictionary *mediaConstraintsDictionary = nil;

  NSString *widthConstraint = [self currentVideoResolutionWidthFromStore];
  NSString *heightConstraint = [self currentVideoResolutionHeightFromStore];
  if (widthConstraint && heightConstraint) {
    mediaConstraintsDictionary = @{
      @"minWidth" : widthConstraint,
      @"minHeight" : heightConstraint
    };
  }
  return mediaConstraintsDictionary;
}

#pragma mark - bitrate
-(NSUInteger)currentBitrate{
    
    NSUInteger br = [[self settingsStore] bitrate];
    if(br == 0){
        return DEFAULT_BITRATE;
    }
    return br;
}
-(void)storeBitrate:(NSUInteger)value{
    return [[self settingsStore] setBitrate:value];
}
#pragma mark - framerate
-( NSUInteger)currentFramerate{
    NSUInteger fr = [[self settingsStore] framerate];
    if(fr == 0){
        return DEFAULT_FRAMERATE;
    }
    return fr;
}
-(void)storeFramerate:(NSUInteger)value{
    return [[self settingsStore] setFramerate:value];
}
#pragma mark - serverconfig
-(BOOL)isOnlineServer{
    return [[self settingsStore] serverconfig];
}
-(void)storeServerconfig:(BOOL)value{
    return [[self settingsStore] setServerconfig:value];
}
-(NSString *)serverUrl:(BOOL)p2p{
    if(p2p){
        if([self isOnlineServer]){
            return ONLINESERVER;
        }
        return P2PTESTSERVER;
    }else{
        return CONFTESTSERVER;
    }
}
#pragma mark - dtls
-(BOOL)isDtlsDisabled{
    return [[self settingsStore] dtlsDisabled];
}
-(void)storeDtlsDisabled:(BOOL)disabled{
    [[self settingsStore] setDtlsDisabled:disabled];
}
#pragma mark - replay
-(BOOL)isRelaySpecified{
    return [[self settingsStore] isRelaySpecified];
}
-(void)storeRelayMode:(BOOL)relay{
    [[self settingsStore] setRelayMode:relay];
}

-(BOOL)eanblePublish{
    return [[self settingsStore] eanblePublish];
}
-(void)setEnablePublish:(BOOL)value{
    [[self settingsStore] setEnablePublish:value];
}
-(BOOL)eanbleSubscribe{
    return [[self settingsStore] eanbleSubscribe];
}
-(void)setEnableSubscribe:(BOOL)value{
    [[self settingsStore] setEnableSubscribe:value];
}





-(BOOL)eanbleInviteAfterCreateRoom{
    return [[self settingsStore] eanbleInviteAfterCreateRoom];
}
-(void)setEanbleInviteAfterCreateRoom:(BOOL)value{
    [[self settingsStore] setEanbleInviteAfterCreateRoom:value];
}

-(NSString*)inviteeUid{
    return [[self settingsStore] inviteeUid];
}
-(void)setInviteeUid:(NSString*)value{
    [[self settingsStore] setInviteeUid:value];
}

-(NSString*)liveUrl{
    return [[self settingsStore] liveUrl];
}
-(void)setLiveUrl:(NSString*)value{
    [[self settingsStore] setLiveUrl:value];
}

-(NSString*)uid{
    return [[self settingsStore] uid];
}
-(void)setUid:(NSString*)value{
    [[self settingsStore] setUid:value];
}

-(NSString*)bizname{
    return [[self settingsStore] bizname];
}
-(void)setBizname:(NSString*)value{
    [[self settingsStore] setBizname:value];
}

-(NSString*)signature{
    return [[self settingsStore] signature];
}
-(void)setSignature:(NSString*)value{
    [[self settingsStore] setSignature:value];
}

@end
NS_ASSUME_NONNULL_END
#endif
#endif
