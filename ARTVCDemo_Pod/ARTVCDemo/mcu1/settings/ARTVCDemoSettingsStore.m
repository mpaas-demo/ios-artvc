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
static NSString *const kUserDefaultInivteAfterCreateRoomKey = @"rtc_enable_invite_after_createroom_key";
static NSString *const kUserDefaultInviteeUidKey = @"rtc_enable_invitee_uid_key";
static NSString *const kUserDefaultLiveUrlKey = @"rtc_enable_live_url_key";
static NSString *const kUserDefaultUidKey = @"rtc_enable_uid_key";

static NSString *const kUserDefaultBiznameKey = @"rtc_enable_bizname_key";

static NSString *const kUserDefaultSignatureKey = @"rtc_enable_signature_key";

static NSString *const kUserDefaultBiznameDefaultValue = @"demo";
static NSString *const kUserDefaultSubbizDefaultValue = @"default";


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
-(NSString*)signature{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSignatureKey];
    
    return value;
}
-(void)setSignature:(NSString*)value{
    if(!value) return;
    [[NSUserDefaults standardUserDefaults] setObject:value
                                                  forKey:kUserDefaultSignatureKey];
}
@end
NS_ASSUME_NONNULL_END
#endif
#endif
