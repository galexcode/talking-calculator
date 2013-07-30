//
//  Display.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-11.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "Display.h"
#import "RepeatedStrings.h"

@interface Display()

@property (strong, nonatomic) NSString *value;
@property BOOL newEntry;

@end

@implementation Display

@synthesize value = _value;
@synthesize newEntry = _newEntry;

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
    if (self.newEntry == YES) {
        self.value = @"0";
        self.newEntry = NO;
    }
    
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
    self.newEntry = YES;
}

- (void)asArray:(NSString *)string withResult:(NSMutableArray *)result
{
    if ([string isEqualToString:@""]) {
        return;
    } else {
        NSString *first = [string substringToIndex:1];
        [result addObject:first];
        [self asArray:[string substringFromIndex:1] withResult:result];
    }
}

- (NSArray *)valueAsArrayOfStrings
{
    NSString *string = [[self valueAsNumber] stringValue];
    
    NSMutableArray *stringArray = [[NSMutableArray alloc] initWithCapacity:[string length]];
    
    [self asArray:string withResult:stringArray];
    return stringArray;
}

+ (RepeatedStrings *)valueAsArrayOfRepeatedStringsImpl:(NSString *)value withResult:(RepeatedStrings *)result
{
    if ([value isEqualToString:@""]) {
        return result;
    }
    
    NSString *first = [value substringToIndex:1];
    NSString *rest = [value substringFromIndex:1];
    
    [result addString:first];
    return [self valueAsArrayOfRepeatedStringsImpl:rest withResult:result];
}

- (RepeatedStrings *)valueAsArrayOfRepeatedStrings
{
    return [self valueAsArrayOfRepeatedStringsWithString:@""];
}

- (RepeatedStrings *)valueAsArrayOfRepeatedStringsWithString:(NSString *)preString
{
    NSString *valueAsString = [preString stringByAppendingString:[[self valueAsNumber] stringValue]];
    RepeatedStrings*result = [[RepeatedStrings alloc] init];
    
    return [Display valueAsArrayOfRepeatedStringsImpl:valueAsString withResult:result];
}

@end

