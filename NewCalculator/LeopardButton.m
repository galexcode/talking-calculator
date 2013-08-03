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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"leopardskin.jpg"] forState:UIControlStateNormal];
        self.layer.cornerRadius = 20.0;
        self.layer.masksToBounds = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
