//
//  UIView+CELayoutAdditions.m
//  MoPubDemo
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "UIView+CELayoutAdditions.h"

@implementation UIView (CELayoutAdditions)

- (void)ce_fitSuperview
{
    UIView *superview = self.superview;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAspect];
    [self setCenterConstraintToSuperview];

    CGFloat widthRatio = self.frame.size.width / superview.frame.size.width;
    CGFloat heightRatio = self.frame.size.height / superview.frame.size.height;

    if (widthRatio > heightRatio) {
        [self setWidthConstraintToSuperview];
    } else {
        [self setHeightConstraintToSuperview];
    }
}

- (void)setAspect
{
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:(self.frame.size.height / self.frame.size.width)
                         constant:0]];
}

- (void)setCenterConstraintToSuperview
{
    UIView *superview = self.superview;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
}

- (void)setWidthConstraintToSuperview
{
    UIView *superview = self.superview;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
}

- (void)setHeightConstraintToSuperview
{
    UIView *superview = self.superview;
    [superview addConstraint:[NSLayoutConstraint
                              constraintWithItem:self
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:superview
                              attribute:NSLayoutAttributeHeight
                              multiplier:1
                              constant:0]];
}

@end
