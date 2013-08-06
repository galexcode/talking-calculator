//
//  MathOperatorTest.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-02.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "MathOperatorTest.h"
#import "MathOperator.h"

@implementation MathOperatorTest

- (void)testMulOperatorShouldDoMultiplication
{
    MulOperator *op = [[MulOperator alloc] init];
    
    double result = [op calculate:5.0 with:2.0];
    double expected = 10.0;
    
    STAssertTrue(result == expected, @"Should equal %f, actual %f", expected, result);
}

- (void)testDivOperatorShouldDivide
{
    DivOperator *op = [[DivOperator alloc] init];
    
    double result = [op calculate:10.0 with:2.0];
    double expected = 5.0;
    
    STAssertTrue(result == expected, @"Should equal %f, actual %f", expected, result);
}

- (void)testAddOperatorShouldDivide
{
    AddOperator *op = [[AddOperator alloc] init];
    
    double result = [op calculate:10.0 with:2.0];
    double expected = 12.0;
    
    STAssertTrue(result == expected, @"Should equal %f, actual %f", expected, result);
}


- (void)testSubOperatorShouldDivide
{
    SubOperator *op = [[SubOperator alloc] init];
    
    double result = [op calculate:10.0 with:2.0];
    double expected = 8.0;
    
    STAssertTrue(result == expected, @"Should equal %f, actual %f", expected, result);
}

- (void)testItShouldBePossibleToCreateOperatorsBasedOnStringsAndPerfomCalculation
{
    
    MathOperator *op = [MathOperator createWithString:@"-"];
    
    double result = [op calculate:10.0 with:2.0];
    double expected = 8.0;
    
    STAssertTrue(result == expected, @"Should equal %f, actual %f", expected, result);
}

- (void)testItShouldBePossibleToCreateOperatorsBasedOnStrings
{
    
    MathOperator *op = [MathOperator createWithString:@"-"];
    op = [MathOperator createWithString:@"+"];
    op = [MathOperator createWithString:@"*"];
    op = [MathOperator createWithString:@"/"];
}

- (void)testCreatingAnInvalidOperatorShouldThrow
{
    
    STAssertThrowsSpecific([MathOperator createWithString:@"a"], MathOperatorException, @"");
}

- (void)testATaxOperatorShouldBeInstantiatedWithARate
{
    NSNumber *rate = [NSNumber numberWithDouble:0.45];
    InclusiveTaxOperator *op = [[InclusiveTaxOperator alloc] initWithNumber:rate];
    
    STAssertNoThrow([op performOperationWith:nil], @"");
}

- (void)testAnInclusiveTaxOperatorShouldReturnTheTermDividedByTheRate
{
    NSNumber *rate = [NSNumber numberWithDouble:0.25];
    InclusiveTaxOperator *op = [[InclusiveTaxOperator alloc] initWithNumber:rate];
    
    NSNumber *nominal = [NSNumber numberWithDouble:2.5];
    NSNumber *result = [NSNumber numberWithDouble:(2.5 * 1.25)];
    
    STAssertEqualObjects([op performOperationWith:nominal], result, @"");
}

- (void)testAnInclusiveTaxOperatorShouldReturnTheTermDividedByTheRateSimple
{
    NSNumber *rate = [NSNumber numberWithDouble:0.25];
    InclusiveTaxOperator *op = [[InclusiveTaxOperator alloc] initWithNumber:rate];
    
    NSNumber *nominal = [NSNumber numberWithDouble:100];
    NSNumber *result = [NSNumber numberWithDouble:(100 * (1 + 0.25))];
    
    STAssertEqualObjects([op performOperationWith:nominal], result, @"");
}

- (void)testAnExclusiveTaxOperatorShouldReturnTheTermMultipliedByTheRate
{
    NSNumber *rate = [NSNumber numberWithDouble:0.25];
    ExclusiveTaxOperator *op = [[ExclusiveTaxOperator alloc] initWithNumber:rate];
    
    NSNumber *nominal = [NSNumber numberWithDouble:2.5];
    NSNumber *result = [NSNumber numberWithDouble:(2.5 / (1 +0.25))];
    
    STAssertEqualObjects([op performOperationWith:nominal], result, @"");
}

- (void)testAnExclusiveTaxOperatorShouldReturnTheTermMultipliedByTheRateSimple
{
    NSNumber *rate = [NSNumber numberWithDouble:0.25];
    ExclusiveTaxOperator *op = [[ExclusiveTaxOperator alloc] initWithNumber:rate];
    
    NSNumber *nominal = [NSNumber numberWithDouble:100.0];
    double expected = 80.0;
    double result = [[op performOperationWith:nominal] doubleValue];
    
    STAssertTrue(abs(expected - result) < 1E-12, @"");
}
@end
