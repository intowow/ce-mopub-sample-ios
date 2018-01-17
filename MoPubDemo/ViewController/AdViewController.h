//
//  ViewController.h
//
//  Copyright © 2015 intowow. All rights reserved.
//

#define Native_Unit_ID @"562d64768379459aaff0247a18be470c"
#define Banner_Unit_ID @"e52f4a38c4c14b23bf8df25d756d0e6d"
#define Interstitial_Unit_ID @"3ae0a7e453684f068bcbe2a77079ece9"
#define Rewarded_Unit_ID @"8d1919ed40224bdfa436a53666169f8b"

#import <UIKit/UIKit.h>
#import "MPNativeAdDelegate.h"
#import "MPAdView.h"
#import "MPInterstitialAdController.h"
#import "MPRewardedVideo.h"

@interface AdViewController : UIViewController <MPNativeAdDelegate, MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>

@property (strong, nonatomic)   IBOutlet UIView * adUIView;
@property (strong, nonatomic)   IBOutlet UIView * adMediaCoverView;
@property (strong, nonatomic)   IBOutlet UIImageView * adIconImageView;
@property (strong, nonatomic)   IBOutlet UILabel * adTitle;
@property (strong, nonatomic)   IBOutlet UILabel * adBody;
@property (strong, nonatomic)   IBOutlet UIButton * callToActionBtn;
@property (strong, nonatomic)   IBOutlet UIView * callToActionWrapper;
@property (strong, nonatomic)   IBOutlet UIButton * loadAdBtn;
@property (strong, nonatomic)   IBOutlet UIButton *loadBannerBtn;
@property (strong, nonatomic) IBOutlet UIButton *loadInterstitialBtn;
@property (strong, nonatomic) IBOutlet UIButton *loadRewardedBtn;
@property (strong, nonatomic)   MPAdView * adView;
@property (strong, nonatomic)   MPInterstitialAdController *interstitial;

@end
