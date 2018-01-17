//
//  MoPubNativeAdView.h
//  crystalexpress-mopub
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNativeAdRendering.h"

@interface MoPubNativeAdView : UIView <MPNativeAdRendering>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *mainTextLabel;
@property (strong, nonatomic) UILabel *callToActionLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImageView *privacyInformationIconImageView;

+ (void)setLayoutWithMainFrame:(CGRect)adMainFrame
            iconImageViewFrame:(CGRect)adIconImageViewFrame
              adMediaViewFrame:(CGRect)adMediaViewFrame
                  adTitleFrame:(CGRect)adTitleFrame
                    adDesFrame:(CGRect)adDesFrame
                      CTAFrame:(CGRect)adCTAFrame;
@end
