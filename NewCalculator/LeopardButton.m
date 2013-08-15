//
//  LeopardButton.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-08-03.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "LeopardButton.h"
#import <QuartzCore/QuartzCore.h>

@interface LeopardButton ()
@property (nonatomic) BOOL isInitialised;
@end

@implementation LeopardButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)setUpTitleForStates
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.isInitialised = NO;
    }
    
    return self;
}

- (CGContextRef)getMaskedContext:(CGRect)rect witRadius:(int)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextAddPath(context, clippath);
    CGContextClip(context);
    
    return context;
}

- (UIImage *)restoreContextAndGetImage:(CGContextRef)context
{
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRestoreGState(context);
    
    return image;
}

- (void)setBackground:(CGRect)rect forHighlightedStateUsingRadius:(int)radius
{
    const CGFloat *color = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    CGContextRef context = [self getMaskedContext:rect witRadius:radius];
    
    // Fill the context with white color
    CGContextSetRGBFillColor(context, color[0], color[0], color[0], 1.f);
    CGContextFillRect(context, rect);
    CGContextSaveGState(context);
    
    UIImage *image = [self restoreContextAndGetImage:context];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)setBackground:(CGRect)rect forNormalStateUsingRadius:(int)radius
{
    CGContextRef context = [self getMaskedContext:rect witRadius:radius];
    
    UIImage *originalImage = [UIImage imageNamed:@"leopardskin.jpg"];
    [originalImage drawInRect:rect];
    
    UIImage *maskedImage = [self restoreContextAndGetImage:context];
    [self setBackgroundImage:maskedImage forState:UIControlStateNormal];
}

- (void)setUpBackgroundForStates:(CGRect)rect
{
    int radius = 20;
    [self setBackground:rect forNormalStateUsingRadius:radius];
    [self setBackground:rect forHighlightedStateUsingRadius:radius];
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!self.isInitialised) {
        [self setUpBackgroundForStates:rect];
        [self setUpTitleForStates];
        self.isInitialised = YES;
    }
}

@end
