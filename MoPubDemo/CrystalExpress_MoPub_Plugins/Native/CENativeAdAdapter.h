//  Minimum support Intowow SDK 3.14.0
//
//  CENativeAdAdapter.h
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MPNativeAdAdapter.h"
#endif

@class CENativeAd;

@interface CENativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

- (instancetype)initWithCENativeAd:(CENativeAd *)nativeAd adProperties:(NSDictionary *)adProps;

@end
