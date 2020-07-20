/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_BASE_CRITICALSECTION_H_
#define WEBRTC_BASE_CRITICALSECTION_H_

//#include "webrtc/base/atomicops.h"
//#include "webrtc/base/checks.h"
//#include "webrtc/base/constructormagic.h"
//#include "webrtc/base/thread_annotations.h"
//#include "webrtc/base/platform_thread_types.h"


#include <pthread.h>

// See notes in the 'Performance' unit test for the effects of this flag.
#define USE_NATIVE_MUTEX_ON_MAC 0


#define CS_DEBUG_CHECKS RTC_DCHECK_IS_ON

#if CS_DEBUG_CHECKS
#define CS_DEBUG_CODE(x) x
#else  // !CS_DEBUG_CHECKS
#define CS_DEBUG_CODE(x)
#endif  // !CS_DEBUG_CHECKS

namespace iSMI {

// Locking methods (Enter, TryEnter, Leave)are const to permit protecting
// members inside a const context without requiring mutable CriticalSections
// everywhere.
class CriticalSection {
 public:
  CriticalSection();
  ~CriticalSection();

  void Enter() const;
  bool TryEnter() const;
  void Leave() const;

 private:

  mutable pthread_mutex_t mutex_;
};


} // namespace iSMI

#endif // WEBRTC_BASE_CRITICALSECTION_H_
