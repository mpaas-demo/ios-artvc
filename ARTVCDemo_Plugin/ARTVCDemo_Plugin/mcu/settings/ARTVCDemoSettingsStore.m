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
#import "ARTVCDemoSettingsStore.h"
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "

static NSString *const kUserDefaultsMediaConstraintsKey =
    @"rtc_video_resolution_media_constraints_key";
static NSString *const kUserDefaultsBitrateKey =
@"rtc_video_bitrate_key";
static NSString *const kUserDefaultsFramerateKey =
@"rtc_video_framerate_key";
static NSString *const kUserDefaultsServerconfigKey = @"rtc_video_serverconfig_key";
static NSString *const kUserDefaultRelayKey = @"rtc_video_relaycconfig_key";
static NSString *const kUserDefaultVideoCodecKey = @"rtc_video_videocodecconfig_key";
static NSString *const kUserDefaultDtlsDisabledKey = @"rtc_dtls_disabled_key";
static NSString *const kUserDefaultEnablePublishKey = @"rtc_enable_publish_key";
static NSString *const kUserDefaultEnableSubscribeKey = @"rtc_enable_subscribe_key";
static NSString *const kUserDefaultEnableFlexFECKey = @"rtc_enable_flexfec_key";
static NSString *const kUserDefaultBWEExperimentKey = @"rtc_enable_bwe_experiment_key";
static NSString *const kUserDefaultInivteAfterCreateRoomKey = @"rtc_enable_invite_after_createroom_key";
static NSString *const kUserDefaultInviteeUidKey = @"rtc_enable_invitee_uid_key";
static NSString *const kUserDefaultLiveUrlKey = @"rtc_enable_live_url_key";
static NSString *const kUserDefaultUidKey = @"rtc_enable_uid_key";

static NSString *const kUserDefaultBiznameKey = @"rtc_enable_bizname_key";
static NSString *const kUserDefaultSubbizKey = @"rtc_enable_subbiz_key";
static NSString *const kUserDefaultSignatureKey = @"rtc_enable_signature_key";
static NSString *const kUserDefaultCustomServerUrlKey = @"rtc_enable_CustomServerUrl_key";
static NSString *const kUserDefaultPacingExperimentKey = @"rtc_pacing_experiment_key";
static NSString *const kUserDefaultNackExperimentKey = @"rtc_nack_experiment_key";
static NSString *const kUserDefaultPlayoutDelayExperimentKey = @"rtc_playout_delay_experiment_key";
static NSString *const kUserDefaultJitterExperimentKey = @"rtc_jitter_experiment_key";
static NSString *const kUserDefaultMockedConfigsKey = @"rtc_mocked_configs_key";
static NSString *const kUserDefaultDisableSmoothRenderingExperimentKey = @"rtc_diable_smooth_rendering_experiment_key";
#ifdef ARTVC_BUILD_FOR_MPAAS
static NSString *const kUserDefaultWorkspaceIdKey = @"rtc_mpaas_workspaceId_key";
#endif

static NSString *const kUserDefaultLoopbackTestKey = @"rtc_enable_loopback_test_key";
static NSString *const kUserDefaultUseBloxKey = @"rtc_enable_blox_key";
static NSString *const kUserDefaultBeautyLevelKey = @"rtc_beauty_level_key";
static NSString *const kUserDefaultVirtualBackgroundKey = @"rtc_enable_virtualBackground_key";

static NSString *const kUserDefaultBiznameDefaultValue = @"demo";
static NSString *const kUserDefaultSubbizDefaultValue = @"default";
static NSString *const kUserDefaultSignatureDefaultValue = @"signature";

NS_ASSUME_NONNULL_BEGIN
@implementation ARTVCDemoSettingsStore

- (nullable NSString *)videoResolutionConstraintsSetting {
    NSString* constraints = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsMediaConstraintsKey];
    NSLog(@"constraints from userDefaults:%@",constraints);
    return constraints;
}

- (void)setVideoResolutionConstraintsSetting:(NSString *)constraintsString {
  [[NSUserDefaults standardUserDefaults] setObject:constraintsString
                                            forKey:kUserDefaultsMediaConstraintsKey];
}

-(NSUInteger)bitrate{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsBitrateKey];
    if(value){
        return [value integerValue];
    }
    return 0;
}
-(void)setBitrate:(NSUInteger)value{
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultsBitrateKey];
}

-(NSUInteger)framerate{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsFramerateKey];
    if(value){
        return [value integerValue];
    }
    return 0;
}
-(void)setFramerate:(NSUInteger)value{
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultsFramerateKey];
}

-(BOOL)serverconfig{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsServerconfigKey];
    if(value){
        return [value boolValue];
    }
    //默认设置为测试环境
    [self setServerconfig:NO];
    return NO;
}

-(void)setServerconfig:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultsServerconfigKey];
}

-(BOOL)dtlsDisabled{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultDtlsDisabledKey];
    if(value){
        return [value boolValue];
    }
    //默认设置启用dtls
    [self setDtlsDisabled:NO];
    return NO;
}

-(void)setDtlsDisabled:(BOOL)yesOrNo{
    NSString *str = [NSString stringWithFormat:@"%d",yesOrNo];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultDtlsDisabledKey];
}

-(BOOL)isRelaySpecified{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultRelayKey];
    if(value){
        return [value boolValue];
    }
    //默认设置relay为NO
    [self setRelayMode:NO];
    return NO;
}

-(void)setRelayMode:(BOOL)yesOrNo{
    NSString *str = [NSString stringWithFormat:@"%d",yesOrNo];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultRelayKey];
}

-(BOOL)eanblePublish{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultEnablePublishKey];
    if(value){
        return [value boolValue];
    }
    [self setEnablePublish:YES];
    return YES;
}
-(void)setEnablePublish:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultEnablePublishKey];
}

-(BOOL)eanbleSubscribe{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultEnableSubscribeKey];
    if(value){
        return [value boolValue];
    }
    [self setEnableSubscribe:YES];
    return YES;
}
-(void)setEnableSubscribe:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultEnableSubscribeKey];
}

-(BOOL)eanbleFlexFEC{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultEnableFlexFECKey];
    if(value){
        return [value boolValue];
    }
    [self setEnableFlexFEC:NO];
    return NO;
}
-(void)setEnableFlexFEC:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultEnableFlexFECKey];
}

-(NSString*)bweExperimentFlag{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultBWEExperimentKey];
    if(value){
        return value;
    }
    value = @"Enabled-0.02,0.1,300";
    [self setBweExperimentFlag:value];
    return value;
}
-(void)setBweExperimentFlag:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                              forKey:kUserDefaultBWEExperimentKey];
}

-(BOOL)eanbleInviteAfterCreateRoom{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultInivteAfterCreateRoomKey];
    if(value){
        return [value boolValue];
    }
    [self setEanbleInviteAfterCreateRoom:NO];
    return NO;
}
-(void)setEanbleInviteAfterCreateRoom:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:kUserDefaultInivteAfterCreateRoomKey];
}

-(NSString*)inviteeUid{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultInviteeUidKey];
    return value;
}
-(void)setInviteeUid:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultInviteeUidKey];
}

-(NSString*)liveUrl{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultLiveUrlKey];
    return value;
}
-(void)setLiveUrl:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultLiveUrlKey];
}
-(NSString*)uid{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUidKey];
    return value;
}
-(void)setUid:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultUidKey];
}
-(NSString*)bizname{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultBiznameKey];
    if(!value){
        [self setBizname:kUserDefaultBiznameDefaultValue];
        return kUserDefaultBiznameDefaultValue;
    }
    return value;
}
-(void)setBizname:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultBiznameKey];
}
-(NSString*)subbiz{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSubbizKey];
    if(!value){
        [self setSubbiz:kUserDefaultSubbizDefaultValue];
        return kUserDefaultSubbizDefaultValue;
    }
    return value;
}
-(void)setSubbiz:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultSubbizKey];
}
-(NSString*)signature{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSignatureKey];
    if(!value){
        [self setSignature:kUserDefaultSignatureDefaultValue];
        return kUserDefaultSignatureDefaultValue;
    }
    return value;
}
-(void)setSignature:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultSignatureKey];
}
-(NSString*)customServerUrl{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultCustomServerUrlKey];
    return value;
}
-(void)setCustomServerUrl:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultCustomServerUrlKey];
}

-(BOOL)enableUseBloxWay{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUseBloxKey];
    if (value) {
        return [value boolValue];
    }
    [self setUseBloxWayChanged:NO];
    return NO;
}
-(void)setUseBloxWayChanged:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kUserDefaultUseBloxKey];
}
-(NSString*)beautyLevel{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultBeautyLevelKey];
    return value;
}
-(void)setBeautyLevel:(float)level{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",level]
                                                  forKey:kUserDefaultBeautyLevelKey];
}
-(BOOL)enableVirtualBG{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultVirtualBackgroundKey];
    if (value) {
        [self setVirtualBG:[value boolValue]];
        return [value boolValue];
    }
    [self setVirtualBG:NO];
    return NO;
}
-(void)setVirtualBG:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kUserDefaultVirtualBackgroundKey];
}
-(NSString*)pacingExperiment{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPacingExperimentKey];
    return value;
}
-(void)setPacingExperiment:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultPacingExperimentKey];
}
-(NSString*)nackExperiment{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNackExperimentKey];
    if(value){
        return value;
    }
    //default value
    value = @"Enabled-0.05,0.9,0.8,0.7,2,10";
    [self setNackExperiment:value];
    return value;
}
-(void)setNackExperiment:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultNackExperimentKey];
}
-(NSString*)playoutDelayExperiment{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPlayoutDelayExperimentKey];
    if(value){
        return value;
    }
    //default value
    value = @"Disabled";
    [self setPlayoutDelayExperiment:value];
    return value;
}
-(void)setPlayoutDelayExperiment:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultPlayoutDelayExperimentKey];
}
-(NSString*)jitterExperiment{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultJitterExperimentKey];
    if(value){
        return value;
    }
    //default value
    value = @"Enabled-1.5,60,30,2.33,15,3,0,100";
    [self setJitterExperiment:value];
    return value;
}
-(void)setJitterExperiment:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultJitterExperimentKey];
}
-(NSString*)mockedConfigs{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultMockedConfigsKey];
    if(value){
        return value;
    }
    //default value is nil
    [self setJitterExperiment:value];
    return value;
}
-(void)setMockedConfigs:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultMockedConfigsKey];
}
-(BOOL)isVideoSmoothRenderingDisabled{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultDisableSmoothRenderingExperimentKey];
    if(value){
        return [value boolValue];
    }
    //默认设置为开启平滑渲染
    [self disableVideoSmoothRendering:NO];
    return NO;
}
-(void)disableVideoSmoothRendering:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                                  forKey:kUserDefaultDisableSmoothRenderingExperimentKey];
}
-(BOOL)isLoopbackTestEnabled{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultLoopbackTestKey];
    if(value){
        return [value boolValue];
    }
    //默认关闭环回测试
    [self enableLoopbackTest:NO];
    return NO;
}
-(void)enableLoopbackTest:(BOOL)value{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                                  forKey:kUserDefaultLoopbackTestKey];
}
#ifdef ARTVC_BUILD_FOR_MPAAS
-(void)setWorkspaceId:(NSString*)workspaceId{
    if(!workspaceId) return;
    [[NSUserDefaults standardUserDefaults] setObject:workspaceId
                                                  forKey:kUserDefaultWorkspaceIdKey];
}
-(NSString*)workspaceId{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultWorkspaceIdKey];
    return value;
}
#endif
@end
NS_ASSUME_NONNULL_END
#endif
#endif
