//  Minimum support Intowow SDK 3.26.1
//
//  CEMPCardCustomEvent.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMPCardCustomEvent.h"
#import "CECardAD.h"
#import "MPLogging.h"
#import "UIView+CELayoutAdditions.h"

#define Default_Card_Timeout 10

@interface CEMPCardCustomEvent () <CECardADDelegate>

@property (nonatomic, strong) CECardAD *ceCardAd;
@property (nonatomic, assign) CGSize adSize;

@end

@implementation CEMPCardCustomEvent

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
    CERequestInfo *reqInfo = [CERequestInfo new];
    reqInfo.placement = placement;
    reqInfo.timeout = Default_Card_Timeout;
    _ceCardAd = [[CECardAD alloc] initWithVideoViewProfile:CEVideoViewProfileCardDefaultProfile];
    [_ceCardAd setDelegate:self];
    [_ceCardAd loadAdWithInfo:reqInfo];
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
