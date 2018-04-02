//  Minimum support Intowow SDK 3.26.1
//
//  CENativeAdRenderer.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMPNativeAdRenderer.h"
#import "MPNativeAdRendererConfiguration.h"
#import "MPStaticNativeAdRendererSettings.h"
#import "MPNativeAdError.h"
#import "MPNativeAdRendering.h"
#import "MPNativeAdAdapter.h"
#import "MPNativeAdConstants.h"
#import "MPNativeAdRendererImageHandler.h"
#import "MPNativeAdRenderingImageLoader.h"
#import "CEMediaView.h"
#import "CENativeAd.h"
#import "UIView+CELayoutAdditions.h"

@interface CEMPNativeAdRenderer () <MPNativeAdRendererImageHandlerDelegate>

@property (nonatomic) UIView<MPNativeAdRendering> *adView;
@property (nonatomic) id<MPNativeAdAdapter> adapter;
@property (nonatomic) BOOL adViewInViewHierarchy;
@property (nonatomic) Class renderingViewClass;
@property (nonatomic) MPNativeAdRendererImageHandler *rendererImageHandler;

@end


@implementation CEMPNativeAdRenderer

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings
{
    MPNativeAdRendererConfiguration *config = [[MPNativeAdRendererConfiguration alloc] init];
    config.rendererClass = [self class];
    config.rendererSettings = rendererSettings;
    config.supportedCustomEvents = @[@"CEMPNativeCustomEvent"];
   
    return config;
}

- (instancetype)initWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings
{
    if (self = [super init]) {
        MPStaticNativeAdRendererSettings *settings = (MPStaticNativeAdRendererSettings *)rendererSettings;
        _renderingViewClass = settings.renderingViewClass;
        _viewSizeHandler = [settings.viewSizeHandler copy];
        _rendererImageHandler = [MPNativeAdRendererImageHandler new];
        _rendererImageHandler.delegate = self;
    }
    
    return self;
}

- (UIView *)retrieveViewWithAdapter:(id<MPNativeAdAdapter>)adapter error:(NSError **)error
{
    if (!adapter) {
        if (error) {
            *error = MPNativeAdNSErrorForRenderValueTypeError();
        }
        
        return nil;
    }
    
    self.adapter = adapter;
    
    if ([self.renderingViewClass respondsToSelector:@selector(nibForAd)]) {
        self.adView = (UIView<MPNativeAdRendering> *)[[[self.renderingViewClass nibForAd] instantiateWithOwner:nil options:nil] firstObject];
    } else {
        self.adView = [[self.renderingViewClass alloc] init];
    }
    
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if ([self.adView respondsToSelector:@selector(nativeMainTextLabel)]) {
        self.adView.nativeMainTextLabel.text = [adapter.properties objectForKey:kAdTextKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativeTitleTextLabel)]) {
        self.adView.nativeTitleTextLabel.text = [adapter.properties objectForKey:kAdTitleKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativeCallToActionTextLabel)] && self.adView.nativeCallToActionTextLabel) {
        self.adView.nativeCallToActionTextLabel.text = [adapter.properties objectForKey:kAdCTATextKey];
    }

    if ([self.adView respondsToSelector:@selector(nativeMainImageView)] && self.adView.nativeMainImageView) {
        NSString *mainImagePath = [adapter.properties objectForKey:kAdMainImageKey];
        if (mainImagePath != nil) {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:mainImagePath];
            if (image != nil) {
                self.adView.nativeMainImageView.image = image;
            }
        }
    }

    if ([self.adView respondsToSelector:@selector(nativeIconImageView)] && self.adView.nativeIconImageView) {
        NSString *iconImagePath = [adapter.properties objectForKey:kAdIconImageKey];
        if (iconImagePath != nil) {
            UIImage * image = [[UIImage alloc] initWithContentsOfFile:iconImagePath];
            if (image != nil) {
                self.adView.nativeIconImageView.image = image;
            }
        }
    }

    if ([self shouldLoadMediaView]) {
        UIView *mediaView = [self.adapter mainMediaView];
        UIView *mainImageView = [self.adView nativeMainImageView];
        
        mediaView.frame = mainImageView.bounds;
        CEMediaView * ceMediaView = (CEMediaView *)mediaView;
        [ceMediaView setNativeAd:[adapter.properties objectForKey:@"ceNativeAd"]];
        
        mediaView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        mainImageView.userInteractionEnabled = YES;
        
        [mainImageView addSubview:ceMediaView];
        [ceMediaView ce_fitSuperview];
    }

    return self.adView;
}

- (BOOL)shouldLoadMediaView
{
    return [self.adapter respondsToSelector:@selector(mainMediaView)]
    && [self.adapter mainMediaView]
    && [self.adView respondsToSelector:@selector(nativeMainImageView)]
    && [self.adapter.properties objectForKey:@"ceNativeAd"];
}

- (void)DAAIconTapped
{
    if ([self.adapter respondsToSelector:@selector(displayContentForDAAIconTap)]) {
        [self.adapter displayContentForDAAIconTap];
    }
}

- (void)adViewWillMoveToSuperview:(UIView *)superview
{
    self.adViewInViewHierarchy = (superview != nil);
}

#pragma mark - MPNativeAdRendererImageHandlerDelegate

- (BOOL)nativeAdViewInViewHierarchy
{
    return self.adViewInViewHierarchy;
}
@end
