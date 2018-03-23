//  Minimum support Intowow SDK 3.26.1
//
//  CEMPInterstitialCustomEvent.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMPInterstitialCustomEvent.h"
#import "CESplash2AD.h"
#import "MPLogging.h"

#define Default_Interstitial_Timeout 10

@interface CEMPInterstitialCustomEvent () <CESplash2ADDelegate>

@property (nonatomic, strong) CESplash2AD *ceSplashAD;

@end


@implementation CEMPInterstitialCustomEvent

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    @try {
        NSString * placement = [info objectForKey:@"placement_id"];
        if (!placement || [placement isEqualToString:@""]) {
            MPLogError(@"Placement ID is required for CE interstitial ad");
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
            return;
        }

        NSArray *audienceTags = [info objectForKey:@"audience_tags"];
        [I2WAPI setAudienceTargetingUserTags:[NSSet setWithArray:audienceTags]];

        MPLogInfo(@"Requesting CESplashAD");
        CERequestInfo *reqInfo = [CERequestInfo new];
        reqInfo.placement = placement;
        reqInfo.timeout = Default_Interstitial_Timeout;
        _ceSplashAD = [[CESplash2AD alloc] initWithVideoViewProfile:CEVideoViewProfileSplash2DefaultProfile];
        [_ceSplashAD setDelegate:self];
        [_ceSplashAD loadAdWithInfo:reqInfo];
    }
    @catch(NSException *e) {
        MPLogError(@"CrystalExpress Interstitial failed to load with error : %@", e);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

-(void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ceSplashAD showFromViewController:rootViewController animated:YES];
    });
}

#pragma mark - CESplash2ADDelegate
- (void)splash2ADDidLoaded:(CESplash2AD *)splash2AD
{
    MPLogInfo(@"Interstitial ad did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:splash2AD];
}

- (void)splash2ADDidFail:(CESplash2AD *)splash2AD withError:(NSError *)error
{
    MPLogInfo(@"Interstitial ad did fail to load with error: %@", error.description);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)splash2ADWillDisplay:(CESplash2AD *)splash2AD
{
    MPLogInfo(@"Interstitial ad will appear");
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)splash2ADDidDisplayed:(CESplash2AD *)splash2AD
{
    MPLogInfo(@"Interstitial ad did appeat");
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)splash2ADWillDismiss:(CESplash2AD *)splash2AD
{
    MPLogInfo(@"Interstitial ad will disappear");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)splash2ADDidDismiss:(CESplash2AD *)splash2AD
{
    MPLogInfo(@"Interstitial ad did disappear");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)splash2ADDidClick:(CESplash2AD *)splash2AD
{
    MPLogInfo(@"Interstitial ad clicked");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

- (void)dealloc
{
    _ceSplashAD = nil;
}

@end
