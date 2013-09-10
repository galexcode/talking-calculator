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

- (UIImage *)getUIImageFromContext:(CGContextRef)context
{
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    return image;
}

- (void)setBackground:(CGRect)rect forHighlightedStateUsingPath:(CGPathRef)borderPath
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddPath(context, borderPath);
    CGContextClip(context);
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    UIImage *image = [self getUIImageFromContext:context];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)drawShadow:(CGContextRef)context withPath:(CGPathRef)borderPath
{
    int softness = 3;
    CGSize shadowOffset = CGSizeMake (-1,  1);

    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, softness, [UIColor grayColor].CGColor);
    CGContextAddPath(context, borderPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

- (void)setBackgroundImage:(CGContextRef)context withPath:(CGPathRef)borderPath
{
    CGContextSaveGState(context);
    CGContextAddPath(context, borderPath);
    CGContextClip(context);
    CGRect smallerRect = CGPathGetPathBoundingBox(borderPath);

    UIImage *originalImage = [UIImage imageNamed:@"leopardskin.jpg"];
    [originalImage drawInRect:smallerRect];
    UIImage *maskedImage = [self getUIImageFromContext:context];
    [self setBackgroundImage:maskedImage forState:UIControlStateNormal];
    CGContextRestoreGState(context);
}

- (void)drawBorder:(CGContextRef)context withPath:(CGPathRef)borderPath
{
    CGContextSaveGState(context);
    CGContextAddPath(context, borderPath);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)setBackground:(CGRect)rect forNormalStateUsingPath:(CGPathRef)borderPath
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawShadow:context withPath:borderPath];
    [self setBackgroundImage:context withPath:borderPath];
    [self drawBorder:context withPath:borderPath];
}

- (void)setUpBackgroundForStates:(CGRect)rect
{
    int radius = 20;
    CGRect smallerRect = CGRectInset(rect, 2, 2);
    CGPathRef border = [UIBezierPath bezierPathWithRoundedRect:smallerRect cornerRadius:radius].CGPath;
    [self setBackground:smallerRect forNormalStateUsingPath:border];
    [self setBackground:smallerRect forHighlightedStateUsingPath:border];
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
