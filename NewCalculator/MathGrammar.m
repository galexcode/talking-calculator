//
//  MathGrammar.m
//  Leo Calc
//
//  Created by Olof Hellquist on 2013-08-17.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#include <math.h>
#import "MathGrammar.h"

@interface MathGrammar ()

@property (nonatomic) int number;
@end

@implementation MathGrammar

+ (MathGrammar *)grammarWithInt:(int)number
{
    MathGrammar *grammar = [[MathGrammar alloc] init];
    grammar.number = number;
    
    return grammar;
}

+ (int)powerOfTen:(int)number withResult:(int)result
{
    int quote = number / 10;
    if (quote == 0) {
        return result;
    } else {
        return [self powerOfTen:quote withResult:result + 1];
    }
}

- (int)powerOfTen
{
    return [MathGrammar powerOfTen:self.number withResult:0];
}

+ (int)stripOnePowerOfTen:(int)value
{
    if (value < 10) {
        return value;
    } else {
        MathGrammar *grammar = [MathGrammar grammarWithInt:value];
        int power = pow(10, [grammar powerOfTen]);
        int reducedNumber = value % power;
        return [self stripOnePowerOfTen:reducedNumber];
    }
}

- (int)valueOfPowerOfTen:(int)powerOfTen
{
    int power = [self powerOfTen];
    if (powerOfTen > power) {
        return 0;
    }
    
    int divisor = pow(10, powerOfTen);
    int value = self.number / divisor;
    return [MathGrammar stripOnePowerOfTen:value];
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%d", self.number];
}

- (int)removePowerOfTen:(int)power withValue:(int)value
{
     return self.number - value * pow(10, power);
}

- (BOOL)numberIsUnique
{
    return [self powerOfTen] == 1 && self.number > 19;
}

- (NSMutableArray *)addResultAndContinue:(NSMutableArray *)result
{
    int power = [self powerOfTen];
    int value = [self valueOfPowerOfTen:power];
    int tenToThePower = pow(10, power);
    
    if ([self numberIsUnique]) {
        [result addObject:[NSString stringWithFormat:@"%d0", value]];
    } else {
        [result addObject:[NSString stringWithFormat:@"%d", value]];
        [result addObject:[NSString stringWithFormat:@"%d", tenToThePower]];
    }
    
    int reducedNumber = [self removePowerOfTen:power withValue:value];
    MathGrammar *grammar = [MathGrammar grammarWithInt:reducedNumber];
    
    return [grammar impl:result];
}

- (NSMutableArray *)dividePower:(int)power andConquer:(NSMutableArray *)result
{
    int tenToThePower = pow(10, power);
    int first = self.number / tenToThePower;
    int rest = self.number % tenToThePower;
    
    MathGrammar *firstGrammar = [MathGrammar grammarWithInt:first];
    result = [firstGrammar impl:result];
    
    [result addObject:[NSString stringWithFormat:@"%d", tenToThePower]];
    
    MathGrammar *restGrammar = [MathGrammar grammarWithInt:rest];
    result = [restGrammar impl:result];
    
    return result;
}

- (BOOL)powerIsEssential
{
    int power = [self powerOfTen];
    
    return power == 9 || power == 6 || power == 3 || power == 2;
}

- (NSMutableArray *)impl:(NSMutableArray *)result
{
    int power = [self powerOfTen];
    
    if ([self powerIsEssential]) {
        return [self addResultAndContinue:result];
    } else if (power > 6) {
        return [self dividePower:6 andConquer:result];
    } else if (power > 3) {
        return [self dividePower:3 andConquer:result];
    } else if (power == 1) {
        if (self.number > 19) {
            return [self addResultAndContinue:result];
        } else {
            [result addObject:[NSString stringWithFormat:@"%d", self.number]];
        }
    } else {
        if (self.number != 0) {
            [result addObject:[NSString stringWithFormat:@"%d", self.number]];
        }
    }
    
    return result;
}

- (NSArray *)getSpeechRepresentation
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    return [self impl:result];
}

@end
