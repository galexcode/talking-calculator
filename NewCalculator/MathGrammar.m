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
@property (nonatomic) int powerOfTen;
@property (nonatomic) int number;
@end

@implementation MathGrammar

- (id)init
{
    self = [super init];
    if (self) {
        self.powerOfTen = -1;
    }
    return self;
}

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
    if (_powerOfTen == -1) {
        _powerOfTen = [MathGrammar powerOfTen:self.number withResult:0];
    }
    return _powerOfTen;
}

+ (int)stripOnePowerOfTen:(int)value
{
    if (value < 10) {
        return value;
    } else {
        MathGrammar *grammar = [MathGrammar grammarWithInt:value];
        int reductionValue = pow(10, grammar.powerOfTen);
        int reducedNumber = value % reductionValue;
        return [self stripOnePowerOfTen:reducedNumber];
    }
}

- (int)valueOfPowerOfTen:(int)powerOfTen
{
    int power = self.powerOfTen;
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
    return self.powerOfTen == 1 && self.number > 19;
}

- (NSMutableArray *)addResultAndContinue:(NSMutableArray *)result
{
    int value = [self valueOfPowerOfTen:self.powerOfTen];
    int tenToThePower = pow(10, self.powerOfTen);
    
    if ([self numberIsUnique]) {
        [result addObject:[NSString stringWithFormat:@"%d0", value]];
    } else {
        [result addObject:[NSString stringWithFormat:@"%d", value]];
        [result addObject:[NSString stringWithFormat:@"%d", tenToThePower]];
    }
    
    int reducedNumber = [self removePowerOfTen:self.powerOfTen withValue:value];
    MathGrammar *grammar = [MathGrammar grammarWithInt:reducedNumber];
    
    return [grammar getSpeechRepresentationWithResult:result];
}

- (int)splitOnPower
{
    return self.powerOfTen > 6 ? 6 : 3;
}

- (NSMutableArray *)dividePowerAndConquer:(NSMutableArray *)result
{
    int powerToSplit = [self splitOnPower];
    int tenToThePower = pow(10, powerToSplit);
    int first = self.number / tenToThePower;
    int rest = self.number % tenToThePower;
    
    MathGrammar *firstGrammar = [MathGrammar grammarWithInt:first];
    result = [firstGrammar getSpeechRepresentationWithResult:result];
    
    [result addObject:[NSString stringWithFormat:@"%d", tenToThePower]];
    
    MathGrammar *restGrammar = [MathGrammar grammarWithInt:rest];
    result = [restGrammar getSpeechRepresentationWithResult:result];
    
    return result;
}

- (BOOL)powerIsEssential
{
    return self.powerOfTen == 9 || self.powerOfTen == 6 || self.powerOfTen == 3 || self.powerOfTen == 2;
}

- (BOOL)splitIsNeeded
{
    return self.powerOfTen > 9 || self.powerOfTen > 3;
}

- (NSMutableArray *)getSpeechRepresentationWithResult:(NSMutableArray *)result
{
    if ([self powerIsEssential]) {
        return [self addResultAndContinue:result];
    } else if ([self splitIsNeeded]) {
        [self dividePowerAndConquer:result];
    } else if (self.powerOfTen == 1) {
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
    return [self getSpeechRepresentationWithResult:result];
}

@end
