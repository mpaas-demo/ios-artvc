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

#import "RTCMacros.h"

/** The only valid value for the following if set is XkRTCFieldTrialEnabledValue. */
RTC_EXTERN NSString * const XkRTCFieldTrialAudioSendSideBweKey;
RTC_EXTERN NSString * const XkRTCFieldTrialAudioForceNoTWCCKey;
RTC_EXTERN NSString * const XkRTCFieldTrialAudioForceABWENoTWCCKey;
RTC_EXTERN NSString * const XkRTCFieldTrialSendSideBweWithOverheadKey;
RTC_EXTERN NSString * const XkRTCFieldTrialFlexFec03AdvertisedKey;
RTC_EXTERN NSString * const XkRTCFieldTrialFlexFec03Key;
RTC_EXTERN NSString * const XkRTCFieldTrialH264HighProfileKey;
RTC_EXTERN NSString * const XkRTCFieldTrialMinimizeResamplingOnMobileKey;
RTC_EXTERN NSString * const XkRTCFieldTrialBweLossExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialPacingExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialNackExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialPlayoutDelayExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialJitterEstimatorExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialVideoSmoothRenderingExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialVideoTimingExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialICEExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialDPExperimentKey;
RTC_EXTERN NSString * const XkRTCFieldTrialAvSyncExperimentKey;

/** The valid value for field trials above. */
RTC_EXTERN NSString * const XkRTCFieldTrialEnabledValue;
RTC_EXTERN NSString * const XkRTCFieldTrialDisabledValue;

/** Initialize field trials using a dictionary mapping field trial keys to their
 * values. See above for valid keys and values. Must be called before any other
 * call into WebRTC. See: webrtc/system_wrappers/include/field_trial.h
 */
RTC_EXTERN void XRTCInitFieldTrialDictionary(NSDictionary<NSString *, NSString *> *fieldTrials);
