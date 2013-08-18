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

- (MathGrammar *)addReslutAndReducePowerOfTen:(NSMutableArray *)result
                                    withPower:(int)power
                                 stringFormat:(NSString *)format
                                    andString:(NSString *)stringValue
{
    int value = [self valueOfPowerOfTen:power];
    
    [result addObject:[NSString stringWithFormat:format, value]];
    if (stringValue != nil) {
        [result addObject:stringValue];
    }
    
    int reducedNumber = [self removePowerOfTen:power withValue:value];
    return [MathGrammar grammarWithInt:reducedNumber];
}

- (NSMutableArray *)impl:(NSMutableArray *)result withGrammar:(MathGrammar *)grammar
{
    int power = [grammar powerOfTen];
    
    if (power == 9) {
        MathGrammar *g = [self addReslutAndReducePowerOfTen:result withPower:power stringFormat:@"%d" andString:@"1000000000"];
        return [g impl:result withGrammar:g];
        
    } else if (power > 6) {
        int thousand = pow(10, 6);
        int first = self.number / thousand;
        int rest = self.number % thousand;
        
        MathGrammar *firstGrammar = [MathGrammar grammarWithInt:first];
        result = [firstGrammar impl:result withGrammar:firstGrammar];
        
        [result addObject:@"1000000"];
        
        MathGrammar *restGrammar = [MathGrammar grammarWithInt:rest];
        result = [restGrammar impl:result withGrammar:restGrammar];
        
        return result;
    } else if (power == 6) {
        MathGrammar *g = [self addReslutAndReducePowerOfTen:result withPower:power stringFormat:@"%d" andString:@"1000000"];
        return [g impl:result withGrammar:g];
    } else if (power > 3) {
        int thousand = pow(10, 3);
        int first = self.number / thousand;
        int rest = self.number % thousand;
        
        MathGrammar *firstGrammar = [MathGrammar grammarWithInt:first];
        result = [firstGrammar impl:result withGrammar:firstGrammar];
        
        [result addObject:@"1000"];
        
        MathGrammar *restGrammar = [MathGrammar grammarWithInt:rest];
        result = [restGrammar impl:result withGrammar:restGrammar];
        
        return result;
        
    } else if (power == 3) {
        MathGrammar *g = [self addReslutAndReducePowerOfTen:result withPower:power stringFormat:@"%d" andString:@"1000"];
        return [g impl:result withGrammar:g];
    } else if (power == 2) {
        MathGrammar *g = [self addReslutAndReducePowerOfTen:result withPower:power stringFormat:@"%d" andString:@"100"];
        return [g impl:result withGrammar:g];
    } else if (power == 1) {
        if (self.number > 19) {
            MathGrammar *g = [self addReslutAndReducePowerOfTen:result withPower:power stringFormat:@"%d0" andString:nil];
            return [g impl:result withGrammar:g];
        } else {
            [result addObject:[NSString stringWithFormat:@"%d", self.number]];
            return result;
        }
    } else {
        if (self.number == 0) {
            // Do nothing
        } else {
            [result addObject:[NSString stringWithFormat:@"%d", self.number]];
            
            return result;
        }
    }
    
    return result;
}

- (NSArray *)getSpeechRepresentation
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    return [self impl:result withGrammar:self];
}

@end
