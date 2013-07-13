//
//  Display.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-11.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "Display.h"

@interface Display()

@property (strong, nonatomic) NSString *value;

@end

@implementation Display

@synthesize value = _value;

- (NSString *)value
{
    if (_value == nil) {
        _value = @"0";
    }
    return _value;
}

- (void)setValueWithNumber:(NSNumber *)number
{
    self.value = [number stringValue];
}

- (NSNumber *)valueAsNumber
{
    return [NSNumber numberWithDouble:[self.value doubleValue]];
}

+ (NSString *)addSpaceEveryThousand:(NSString *)valueAsString
{
    NSInteger count = [valueAsString length];
    if (count < 4) {
        return valueAsString;
    }
    
    NSInteger thirdLast = count - 3;
    NSString *last = [valueAsString substringFromIndex:thirdLast];
    NSString *first = [valueAsString substringToIndex:thirdLast];
    
    NSString *result = [@" " stringByAppendingString:last];
    
    return [[self addSpaceEveryThousand:first] stringByAppendingString:result];
}

- (NSString *)valueAsString
{
    return [[self class] addSpaceEveryThousand:self.value];
}

- (void)addDigitWithString:(NSString *)digit
{
    if ([self.value isEqualToString:@"0"]) {
        self.value = digit;
    } else {
        self.value = [self.value stringByAppendingString:digit];
    }
}

- (void)addDigitWithInt:(int)digit
{
    [self addDigitWithString:[NSString stringWithFormat:@"%d",digit]];
}

- (void)beginNewEntry
{
    self.value = @"0";
}

@end
