//  Minimum support Intowow SDK 3.14.0
//
//  CENativeCustomEvent.h
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MPNativeCustomEvent.h"
#endif

@interface CENativeCustomEvent : MPNativeCustomEvent

@end
