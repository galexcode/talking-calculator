//
//  MathOperator.h
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-02.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathOperatorException : NSException
@end

@interface MathOperator : NSObject

- (NSNumber *)performOperation:(NSNumber *)lhs
                          with:(NSNumber *)rhs;

- (double)calculate:(double)lhs
               with:(double)rhs;

+ (MathOperator *)createWithString:(NSString *)operator;

@end

@interface UnaryOperator : NSObject

- (NSNumber *)performOperationWith:(NSNumber *)number;
- (id)initWithNumber:(NSNumber *)number;

@end

@interface MulOperator : MathOperator
@end

@interface DivOperator : MathOperator
@end

@interface AddOperator : MathOperator
@end

@interface SubOperator : MathOperator
@end

@interface InclusiveTaxOperator : UnaryOperator
@end

@interface ExclusiveTaxOperator : UnaryOperator
@end
