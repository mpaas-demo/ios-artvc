/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef SDK_OBJC_BASE_RTCMACROS_H_
#define SDK_OBJC_BASE_RTCMACROS_H_

#define XRTC_OBJC_EXPORT __attribute__((visibility("default")))

#if defined(__cplusplus)
#define RTC_EXTERN extern "C" XRTC_OBJC_EXPORT
#else
#define RTC_EXTERN extern XRTC_OBJC_EXPORT
#endif

#ifdef __OBJC__
#define RTC_FWD_DECL_OBJC_CLASS(classname) @class classname
#else
#define RTC_FWD_DECL_OBJC_CLASS(classname) typedef struct objc_object classname
#endif

//-----------macro add for old p2p sdk begin -----------------------------------------------
//macro below MUST changed according to different branch
//undef macro first if already defined in webrtc/BUILD.gn,or there is compiling error below:
//error: 'USE_BUILTIN_WEBSOCKET_CHANNEL' macro redefined [-Werror,-Wmacro-redefined]
#if defined(USE_BUILTIN_WEBSOCKET_CHANNEL)
#undef USE_BUILTIN_WEBSOCKET_CHANNEL
#endif
#define USE_BUILTIN_WEBSOCKET_CHANNEL

#if defined(ARTVC_SMALLEST_BINARY)
#undef ARTVC_SMALLEST_BINARY
#endif
#define ARTVC_SMALLEST_BINARY

#if defined(ARTVC_ENABLE_STATS)
#undef ARTVC_ENABLE_STATS
#endif
#define ARTVC_ENABLE_STATS
//-----------macro add for old p2p sdk end -----------------------------------------------

//-----macros for mpass begin-----
#if defined(ARTVC_BUILD_FOR_MPAAS)
#undef ARTVC_BUILD_FOR_MPAAS
#endif
#define ARTVC_BUILD_FOR_MPAAS
//-----macros for mpass end-----

#endif  // SDK_OBJC_BASE_RTCMACROS_H_
