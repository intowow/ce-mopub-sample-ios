//  Minimum support Intowow SDK 3.26.1
//
//  CEMPRewardedVideoCustomEvent.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMPRewardedVideoCustomEvent.h"
#import "CERewardedVideoAD.h"
#import "MPLogging.h"

#define Default_Rewarded_Timeout 10

@interface CEMPRewardedVideoCustomEvent () <CERewardedVideoADRequestDelegate, CERewardedVideoADEventDelegate>

@property (nonatomic, strong) CERewardedVideoAD *ceRewardedAD;

@end

@implementation CEMPRewardedVideoCustomEvent

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    @try{
        NSString * placement = [info objectForKey:@"placement_id"];
        if (!placement || [placement isEqualToString:@""]) {
            MPLogError(@"Placement ID is required for CE rewarded video ad");
            [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
            return;
        }

        NSArray *audienceTags = [info objectForKey:@"audience_tags"];
        [I2WAPI setAudienceTargetingUserTags:[NSSet setWithArray:audienceTags]];

        MPLogInfo(@"Requesting CERewardedVideoAD");
        CERequestInfo *reqInfo = [CERequestInfo new];
        reqInfo.placement = placement;
        reqInfo.timeout = Default_Rewarded_Timeout;
        _ceRewardedAD = [[CERewardedVideoAD alloc] init];
        [_ceRewardedAD setEventDelegate:self];
        [_ceRewardedAD loadAdAsyncWithInfo:reqInfo reqDelegate:self];
    }
    @catch(NSException *e) {
        MPLogError(@"CrystalExpress rewarded video failed to load with error : %@", e);
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
    }
}

- (BOOL)hasAdAvailable
{
    if (!self.ceRewardedAD.ad) {
        return NO;
    }

    return [I2WAPI isAdValid:self.ceRewardedAD.ad];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ceRewardedAD showFromViewController:viewController animated:YES];
    });
}

- (void)handleCustomEventInvalidated
{
    _ceRewardedAD = nil;
}

#pragma mark - CERewardedVideoADRequestDelegate
-(void)rewardedVideoADDidLoaded:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad did load");
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

-(void)rewardedVideoADDidFail:(CERewardedVideoAD *)rewardedVideoAD withError:(NSError *)error
{
    MPLogInfo(@"Rewarded video ad did fail to load with error: %@", error);
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

#pragma mark - CERewardedVideoADEventDelegate
-(void)rewardedVideoADWillDisplay:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad will display");
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

-(void)rewardedVideoADDidDisplayed:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad did display");
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

-(void)rewardedVideoADWillDismiss:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad will dismiss");
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
}

-(void)rewardedVideoADDidDismiss:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad did dismiss");
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

-(void)rewardedVideoADDidClick:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad was clicked");
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
}

-(void)rewardedVideoADDidRewardUser:(CERewardedVideoAD *)rewardedVideoAD
{
    MPLogInfo(@"Rewarded video ad did reward user");
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:nil];
}

-(void)dealloc
{
    _ceRewardedAD = nil;
}

@end
