//
//  ViewController.m
//
//  Copyright © 2015 intowow. All rights reserved.
//

#import "AdViewController.h"
#import "MPNativeAd.h"
#import "MPStaticNativeAdRendererSettings.h"
#import "MPStaticNativeAdRenderer.h"
#import "MPNativeAdRequestTargeting.h"
#import "MPNativeAdRequest.h"
#import "MoPubNativeAdView.h"
#import "MPNativeAdConstants.h"
#import "MPNativeAdRendererConfiguration.h"
#import "CENativeAdRenderer.h"
#import "MoPub.h"

@interface AdViewController ()
@property (nonatomic, strong) MPNativeAd * nativeAd;
@property (nonatomic, strong) UIView * nativeExtendView;
@property (nonatomic, assign) CGRect rectOriginal;
@property (nonatomic, assign) UIView *nativeDisplayView;
@property (nonatomic, strong) UIView *cardAdView;
@end

@implementation AdViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage * bgImg = [UIImage imageNamed:@"asset.bundle/bg.jpg"];
    UIImageView * bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    [bgImgView setFrame:screenRect];
    [self.view insertSubview:bgImgView atIndex:0];

    if (screenRect.size.height <= 480) {
        _loadAdBtn.frame = CGRectMake(_loadAdBtn.frame.origin.x,
                                      _adUIView.frame.origin.y + _adUIView.frame.size.height + 2,
                                      _loadAdBtn.frame.size.width,
                                      _loadAdBtn.frame.size.height);
    }

    _rectOriginal = _adMediaCoverView.frame;//keep auto resize view
    [self configAdViewLayout];

} /* viewDidLoad */

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate {
    return NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)configAdViewLayout
{
    [MoPubNativeAdView setLayoutWithMainFrame:_adUIView.frame
                           iconImageViewFrame:_adIconImageView.frame
                             adMediaViewFrame:_rectOriginal
                                 adTitleFrame:_adTitle.frame
                                   adDesFrame:_adBody.frame
                                     CTAFrame:_callToActionWrapper.frame];
}

- (void)clearView
{
    if (_adView) {
        [_adView removeFromSuperview];
        _adView = nil;
    }
    if (_nativeExtendView) {
        [_nativeExtendView removeFromSuperview];
        _nativeExtendView = nil;
    }
}

#pragma mark - MoPub Native Ad

- (IBAction) loadNativeAd:(id)sender {
    [self clearView];
    [self requestNativeAd];
}

- (void)requestNativeAd
{
    NSLog(@"requestNativeAd");
    
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [MoPubNativeAdView class];
    settings.viewSizeHandler = ^(CGFloat maximumWidth) {
        return CGSizeMake(maximumWidth, 312.0f);
    };
    MPNativeAdRendererConfiguration *config = [CENativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    
    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:Native_Unit_ID
                                                           rendererConfigurations:@[config]];
    MPNativeAdRequestTargeting *targeting = [[MPNativeAdRequestTargeting alloc] init];
    adRequest.targeting = targeting;
    dispatch_async(dispatch_get_main_queue(), ^{
        [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
            if (error) {
                NSLog(@"request native ad error, error = %@", error);
            } else {
                self.nativeAd = response;
                self.nativeAd.delegate = self;
                [self attachAd];
            }
        }];
    });
}

- (void)attachAd
{
    NSError * err;
    [self clearView];
    _nativeExtendView = [self.nativeAd retrieveAdViewWithError:&err];
    if (err) {
        NSLog(@"retrieveAdViewWithError, error = %@", err);
        return;
    } else {
        _nativeExtendView.frame = _adUIView.frame;
        [self.view addSubview:_nativeExtendView];
    }
}

#pragma mark - MPNativeAdDelegate, MPAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

#pragma mark - MoPub Banner Ad

- (IBAction)loadBannerAd:(id)sender {
    [self clearView];
    _adView = [[MPAdView alloc] initWithAdUnitId:Banner_Unit_ID size:CGSizeMake(_rectOriginal.size.width, _rectOriginal.size.height)];
    _adView.delegate = self;
    [_adView stopAutomaticallyRefreshingContents];
    [_adView loadAd];
}

#pragma mark - MPAdViewDelegate
//Banner ad callback
- (void)adViewDidLoadAd:(MPAdView *)view
{
    _adView.frame = CGRectMake(0, _rectOriginal.origin.y + _adUIView.frame.origin.y, view.adContentViewSize.width, view.adContentViewSize.height);
    _adView.center = CGPointMake(CGRectGetMidX(self.view.bounds), _adView.center.y);

    [self.view addSubview:_adView];
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"adViewDidFailToLoadAd");
}

#pragma mark - MoPub Interstitial Ad

- (IBAction)loadInterstitialAd:(id)sender {
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:Interstitial_Unit_ID];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"interstitialDidLoadAd");
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"interstitialDidFailToLoadAd");
}

#pragma mark - MoPub Rewarded Video Ad

- (IBAction)loadRewardedAd:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:self];
    });
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:Rewarded_Unit_ID withMediationSettings:nil];
}

#pragma mark - MPRewardedVideoDelegate
- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"rewardedVideoAdDidLoadForAdUnitID, adUnitID = %@", adUnitID);
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:Rewarded_Unit_ID]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:Rewarded_Unit_ID fromViewController:self withReward:nil];
    }
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    NSLog(@"rewardedVideoAdDidFailToLoadForAdUnitID, error = %@", error.description);
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward
{
    NSLog(@"rewardedVideoAdShouldRewardForAdUnitID, adUnitID = %@", adUnitID);
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"rewardedVideoAdDidReceiveTapEventForAdUnitID, adUnitID = %@", adUnitID);
}

@end
