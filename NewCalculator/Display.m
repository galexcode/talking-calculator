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

- (NSString *)addSpaceEveryThousand:(NSString *)valueAsString
{
    NSRange range = [valueAsString rangeOfString:@"."];
    if (range.length > 0) {
        NSString *before = [valueAsString substringToIndex:range.location];
        NSString *withSpaces = [Display addSpaceEveryThousandImpl:before];
        return [withSpaces stringByAppendingString:[valueAsString substringFromIndex:range.location]];
    } else {
        return [Display addSpaceEveryThousandImpl:valueAsString];
    }
}

+ (NSString *)addSpaceEveryThousandImpl:(NSString *)valueAsString
{
    NSInteger count = [valueAsString length];
    if (count < 4) {
        return valueAsString;
    }
    
    NSInteger thirdLast = count - 3;
    NSString *last = [valueAsString substringFromIndex:thirdLast];
    NSString *first = [valueAsString substringToIndex:thirdLast];
    
    NSString *result = [@" " stringByAppendingString:last];
    
    return [[self addSpaceEveryThousandImpl:first] stringByAppendingString:result];
}

- (NSString *)valueAsString
{
    return [self addSpaceEveryThousand:self.value];
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
    self.containsComma = NO;
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

- (void)addComma
{
    if (!self.containsComma) {
        self.containsComma = YES;
        [self addDigitWithString:@"."];
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
    // TODO add tests!
    RepeatedStrings*result = [[RepeatedStrings alloc] init];
    [result addString:preString];
    NSString *valueAsString = [[self valueAsNumber] stringValue];
    
    return [Display valueAsArrayOfRepeatedStringsImpl:valueAsString withResult:result];
}

@end

