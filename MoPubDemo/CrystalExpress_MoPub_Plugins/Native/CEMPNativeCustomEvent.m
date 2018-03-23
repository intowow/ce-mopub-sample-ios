//  Minimum support Intowow SDK 3.26.1
//
//  CEMPNativeCustomEvent.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMPNativeCustomEvent.h"
#import "CENativeAd.h"
#import "CEMPNativeAdAdapter.h"
#import "MPNativeAd.h"
#import "MPNativeAdError.h"
#import "MPLogging.h"

#define Default_Native_Timeout 10

@interface CEMPNativeCustomEvent () <CENativeAdDelegate>

@property (nonatomic, readwrite, strong) CENativeAd * ceNativeAd;
@property (nonatomic, readwrite, strong) NSDictionary * serverInfo;

@end

@implementation CEMPNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    _serverInfo = info;

    NSString * placement = [info objectForKey:@"placement_id"];
    if (!placement || [placement isEqualToString:@""]) {
        MPLogError(@"Placement ID is required for CE native ad");
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(@"Invalid CENative placement ID")];
        return;
    }

    NSArray *audienceTags = [info objectForKey:@"audience_tags"];
    [I2WAPI setAudienceTargetingUserTags:[NSSet setWithArray:audienceTags]];

    CERequestInfo *reqInfo = [CERequestInfo new];
    reqInfo.placement = placement;
    reqInfo.timeout = Default_Native_Timeout;
    _ceNativeAd = [[CENativeAd alloc] init];
    _ceNativeAd.delegate = self;
    [_ceNativeAd loadAdWithInfo:reqInfo];
}

#pragma mark - CENativeAdDelegate
- (void) nativeAdDidLoad:(CENativeAd *)nativeAd
{
    CEMPNativeAdAdapter *adAdapter = [[CEMPNativeAdAdapter alloc] initWithCENativeAd:nativeAd adProperties:_serverInfo];
    MPNativeAd * interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    if (nativeAd.coverImagePath) {
        NSURL *url = [NSURL URLWithString:[nativeAd.coverImagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imageURLs addObject:url];
    }
    
    [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
}

- (void) nativeAd:(CENativeAd *)nativeAd didFailWithError:(NSError *)error
{
    MPLogDebug(@"CENative ad failed to load with error: %@", error.description);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
