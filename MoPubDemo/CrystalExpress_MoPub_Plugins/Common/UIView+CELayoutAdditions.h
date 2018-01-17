//
//  UIView+CELayoutAdditions.h
//  MoPubDemo
//
//  Copyright © 2017 intowow. All rights reserved.
//
@import UIKit;

@interface UIView (CELayoutAdditions)

//Add constraints to the receiver's superview that keep ad in center and keep aspect ratio.
- (void)ce_fitSuperview;

@end
