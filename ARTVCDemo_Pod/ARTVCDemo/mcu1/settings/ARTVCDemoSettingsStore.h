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

NS_ASSUME_NONNULL_BEGIN

/**
 * Light-weight persistent store for user settings.
 *
 * It will persist between application launches and application updates.
 */
@interface ARTVCDemoSettingsStore : NSObject

/**
 * Returns current video resolution media constraint string stored in the store.
 */
- (nullable NSString *)videoResolutionConstraintsSetting;

/**
 * Stores the provided value as video resolution media constraint.
 * @param value the string to be stored
 */
- (void)setVideoResolutionConstraintsSetting:(NSString *)value;

-(NSUInteger)bitrate;
-(void)setBitrate:(NSUInteger)value;

-(NSUInteger)framerate;
-(void)setFramerate:(NSUInteger)value;;

-(BOOL)serverconfig;
-(void)setServerconfig:(BOOL)value;;

-(BOOL)dtlsDisabled;
-(void)setDtlsDisabled:(BOOL)yesOrNo;

-(BOOL)isRelaySpecified;
-(void)setRelayMode:(BOOL)relay;

-(BOOL)eanblePublish;
-(void)setEnablePublish:(BOOL)value;
-(BOOL)eanbleSubscribe;
-(void)setEnableSubscribe:(BOOL)value;
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

-(NSString*)signature;
-(void)setSignature:(NSString*)value;

@end
NS_ASSUME_NONNULL_END
