//  Minimum support Intowow SDK 3.26.1
//
//  CEMPNativeAdAdapter.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMPNativeAdAdapter.h"
#import "MPNativeAdConstants.h"
#import "CENativeAd.h"
#import "CEMediaView.h"
#import "CEVideoViewProfile.h"

@interface CEMPNativeAdAdapter () <CENativeAdEventDelegate>

@property (nonatomic, readonly) CENativeAd * ceNativeAd;
@property (nonatomic, readonly) CEMediaView * ceMediaView;

@end

@implementation CEMPNativeAdAdapter

@synthesize properties = _properties;

- (instancetype)initWithCENativeAd:(CENativeAd *)nativeAd adProperties:(NSDictionary *)adProps
{
    if (self = [super init]) {
        _ceNativeAd = nativeAd;
        [_ceNativeAd setEventDelegate:self];
        
        NSMutableDictionary * properties;
        if (adProps) {
            properties = [NSMutableDictionary dictionaryWithDictionary:adProps];
        } else {
            properties = [NSMutableDictionary dictionary];
        }
        
        if (_ceNativeAd.title) {
            [properties setObject:_ceNativeAd.title forKey:kAdTitleKey];
        } else if ([adProps objectForKey:@"default_title"]) {
            [properties setObject:[adProps objectForKey:@"default_title"] forKey:kAdTitleKey];
        }
        
        if (_ceNativeAd.body) {
            [properties setObject:_ceNativeAd.body forKey:kAdTextKey];
        } else if([adProps objectForKey:@"default_mainText"]) {
            [properties setObject:[adProps objectForKey:@"default_mainText"] forKey:kAdTextKey];
        }
        
        if (_ceNativeAd.icon.url.path) {
            [properties setObject:_ceNativeAd.icon.url.path forKey:kAdIconImageKey];
        }
        
        _ceMediaView = [[CEMediaView alloc] initWithVideoViewProfile:CEVideoViewProfileNativeDefaultProfile];

        if (_ceNativeAd) {
            [properties setObject:_ceNativeAd forKey:@"ceNativeAd"];
        }
        
        if (_ceNativeAd.coverImagePath) {
            [properties setObject:_ceNativeAd.coverImagePath forKey:kAdMainImageKey];
        }
        
        if (_ceNativeAd.callToAction) {
            [properties setObject:_ceNativeAd.callToAction forKey:kAdCTATextKey];
        } else if ([adProps objectForKey:@"default_CTAText"]){
            [properties setObject:[adProps objectForKey:@"default_CTAText"] forKey:kAdCTATextKey];
        }
        
        _properties = properties;
        
    }
    
    return self;
}

#pragma mark - MPNativeAdAdapter

- (NSURL *)defaultActionURL
{
    return nil;
}

- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}

- (void)willAttachToView:(UIView *)view
{
    [self.ceNativeAd registerViewForInteraction:view withViewController:[self.delegate viewControllerForPresentingModalView] withClickableViews:@[view, self.ceMediaView]];
}

- (UIView *)mainMediaView
{
    return self.ceMediaView;
}

#pragma mark - CENativeAdEventDelegate

- (void)nativeAdWillTrackImpression:(CENativeAd *)nativeAd
{
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLogImpression:)]) {
        [self.delegate nativeAdWillLogImpression:self];
    }
}

- (void)nativeAdDidClick:(CENativeAd *)nativeAd
{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
}

@end
