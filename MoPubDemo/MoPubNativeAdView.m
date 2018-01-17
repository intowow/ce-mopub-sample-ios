//
//  MoPubNativeAdView.m
//  crystalexpress-mopub
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "MoPubNativeAdView.h"

static CGRect mainFrame;
static CGRect mediaViewFrame;
static CGRect titleFrame;
static CGRect desFrame;
static CGRect CTAFrame;
static CGRect iconImageViewFrame;

@implementation MoPubNativeAdView

+ (void)setLayoutWithMainFrame:(CGRect)adMainFrame
            iconImageViewFrame:(CGRect)adIconImageViewFrame
              adMediaViewFrame:(CGRect)adMediaViewFrame
                  adTitleFrame:(CGRect)adTitleFrame
                    adDesFrame:(CGRect)adDesFrame
                      CTAFrame:(CGRect)adCTAFrame
{
    mainFrame = adMainFrame;
    mediaViewFrame = adMediaViewFrame;
    titleFrame = adTitleFrame;
    desFrame = adDesFrame;
    CTAFrame = adCTAFrame;
    iconImageViewFrame = adIconImageViewFrame;
}

- (id)init
{
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.37];
        self.frame = mainFrame;
        self.mainImageView = [[UIImageView alloc] initWithFrame:mediaViewFrame];
        self.mainImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.mainImageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];

        self.mainTextLabel = [[UILabel alloc] initWithFrame:desFrame];
        [self.mainTextLabel setFont:[UIFont systemFontOfSize:17]];
        self.mainTextLabel.textColor = [UIColor grayColor];
        [self addSubview:self.mainTextLabel];

        self.callToActionLabel = [[UILabel alloc] initWithFrame:CTAFrame];
        [self.callToActionLabel setFont:[UIFont systemFontOfSize:14]];
        self.callToActionLabel.textColor = [UIColor blueColor];
        self.callToActionLabel.textAlignment = NSTextAlignmentCenter;
        [[self.callToActionLabel layer] setBorderWidth:1.0f];
        [[self.callToActionLabel layer] setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:self.callToActionLabel];

        self.iconImageView = [[UIImageView alloc] initWithFrame:iconImageViewFrame];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (UILabel *)nativeMainTextLabel
{
    return self.mainTextLabel;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.titleLabel;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.callToActionLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIImageView *)nativeMainImageView
{
    return self.mainImageView;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyInformationIconImageView;
}

@end
