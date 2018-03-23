//  Minimum support Intowow SDK 3.26.1
//
//  CEMPNativeAdAdapter.h
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

@interface CEMPNativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

- (instancetype)initWithCENativeAd:(CENativeAd *)nativeAd adProperties:(NSDictionary *)adProps;

@end
