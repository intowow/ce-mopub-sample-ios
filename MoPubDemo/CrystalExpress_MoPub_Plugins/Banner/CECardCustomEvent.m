//  Minimum support Intowow SDK 3.14.0
//
//  CECardCustomEvent.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CECardCustomEvent.h"
#import "CECardAD.h"
#import "MPLogging.h"
#import "UIView+CELayoutAdditions.h"

#define Default_Card_Timeout 10

@interface CECardCustomEvent () <CECardADDelegate>

@property (nonatomic, strong) CECardAD *ceCardAd;
@property (nonatomic, assign) CGSize adSize;

@end

@implementation CECardCustomEvent

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return YES;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    _adSize = size;
    NSString * placement = [info objectForKey:@"placement_id"];
    if (!placement || [placement isEqualToString:@""]) {
        MPLogError(@"Placement ID is required for CE banner ad");
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }

    NSArray *audienceTags = [info objectForKey:@"audience_tags"];
    [I2WAPI setAudienceTargetingUserTags:[NSSet setWithArray:audienceTags]];

    MPLogInfo(@"Requesting CECardAd");
    _ceCardAd = [[CECardAD alloc] initWithPlacement:placement];
    [_ceCardAd setDelegate:self];
    [_ceCardAd loadAdWithTimeout:Default_Card_Timeout];
}

#pragma mark - CECardADDelegate

- (void)cardADDidLoaded:(CECardAD *)cardAD
{
    MPLogInfo(@"Banner ad did load");
    UIView * adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.adSize.width, self.adSize.height)];
    adView.backgroundColor = [UIColor blackColor];
    [adView addSubview:cardAD.adUIView];
    [cardAD.adUIView ce_fitSuperview];
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
}

- (void)cardADDidFail:(CECardAD *)cardAD withError:(NSError *)error
{
    MPLogInfo(@"Banner ad failed to load with error: %@", error.description);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

@end
