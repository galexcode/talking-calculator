//
//  LeopardButton.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-08-03.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "LeopardButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation LeopardButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setCommonProperties
{
    self.layer.cornerRadius = 20.0;
    self.layer.masksToBounds = YES;
}

- (void)setUpNormalState
{
    [self setBackgroundImage:[UIImage imageNamed:@"leopardskin.jpg"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    // Create a 1 by 1 pixel context
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    
}

- (void)setUpHighlightedState
{
    [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setCommonProperties];
        [self setUpNormalState];
        [self setUpHighlightedState];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
