//
//  MathOperator.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-02.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "MathOperator.h"

@implementation MathOperatorException
@end

@interface MathOperator()

@end

@implementation MathOperator

- (NSNumber *)performOperation:(NSNumber *)lhs
                          with:(NSNumber *)rhs
{
    double dLhs = [lhs doubleValue];
    double dRhs = [rhs doubleValue];
    
    return [NSNumber numberWithDouble:[self calculate:dLhs with:dRhs]];
}

+ (MathOperator *)createWithString:(NSString *)operator
{
    if ([operator isEqualToString:@"+"]) {
        return [[AddOperator alloc] init];
    }
    if ([operator isEqualToString:@"-"]) {
        return [[SubOperator alloc] init];
    }
    if ([operator isEqualToString:@"*"]) {
        return [[MulOperator alloc] init];
    }
    if ([operator isEqualToString:@"/"]) {
        return [[DivOperator alloc] init];
    }
    
    [MathOperatorException raise:@"Operator is not supported" format:@"%@", operator];
    return NULL;
}

- (double)calculate:(double)lhs
               with:(double)rhs
{
    [MathOperatorException raise:@"MathOperator is an abstract class" format:@""];
    
    return -1.0;
}

@end

@implementation MulOperator

- (double)calculate:(double)lhs
               with:(double)rhs
{
    return lhs * rhs;
}
@end


@implementation DivOperator

- (double)calculate:(double)lhs
               with:(double)rhs
{
    return lhs / rhs;
}
@end

@implementation AddOperator

- (double)calculate:(double)lhs
               with:(double)rhs
{
    return lhs + rhs;
}
@end

@implementation SubOperator

- (double)calculate:(double)lhs
               with:(double)rhs
{
    return lhs - rhs;
}
@end