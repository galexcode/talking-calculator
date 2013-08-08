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
    
    MathOperator *op = nil;
    op = [MathOperator createWithString:@"-"];
    op = [MathOperator createWithString:@"+"];
    op = [MathOperator createWithString:@"*"];
    op = [MathOperator createWithString:@"/"];
    
    UnaryOperator *uOp = nil;
    uOp = [UnaryOperator createFromString:@"Tax+"];
    uOp = [UnaryOperator createFromString:@"Tax-"];
}

- (void)testCreatingAnInvalidOperatorShouldThrow
{
    
    STAssertThrowsSpecific([MathOperator createWithString:@"a"], MathOperatorException, @"");
    STAssertThrowsSpecific([UnaryOperator createFromString:@"a"], MathOperatorException, @"");
}

- (void)testATaxOperatorShouldBeInstantiatedWithARate
{
    InclusiveTaxOperator *op = [[InclusiveTaxOperator alloc] initWithInt:45];
    
    STAssertNoThrow([op performOperationWith:nil], @"");
}

- (void)testAnInclusiveTaxOperatorShouldReturnTheTermDividedByTheRate
{
    InclusiveTaxOperator *op = [[InclusiveTaxOperator alloc] initWithInt:25];
    
    NSNumber *nominal = [NSNumber numberWithDouble:2.5];
    double expected = 3.125;
    double result = [[op performOperationWith:nominal] doubleValue];
    
    STAssertEquals(result, expected, @"");
}

- (void)testAnInclusiveTaxOperatorShouldReturnTheTermDividedByTheRateSimple
{
    InclusiveTaxOperator *op = [[InclusiveTaxOperator alloc] initWithInt:20];
    
    NSNumber *nominal = [NSNumber numberWithDouble:100.0];
    double expected = 120.0;
    double result = [[op performOperationWith:nominal] doubleValue];
    
    STAssertTrue(expected = result, @"");
    STAssertEquals(result, expected, @"");
}

- (void)testAnExclusiveTaxOperatorShouldReturnTheTermMultipliedByTheRate
{
    ExclusiveTaxOperator *op = [[ExclusiveTaxOperator alloc] initWithInt:25];
    
    NSNumber *nominal = [NSNumber numberWithDouble:2.5];
    NSNumber *result = [NSNumber numberWithDouble:(2.5 / (1 +0.25))];
    
    STAssertEqualObjects([op performOperationWith:nominal], result, @"");
}

- (void)testAnExclusiveTaxOperatorShouldReturnTheTermMultipliedByTheRateSimple
{
    ExclusiveTaxOperator *op = [[ExclusiveTaxOperator alloc] initWithInt:25];
    
    NSNumber *nominal = [NSNumber numberWithDouble:100.0];
    NSNumber *expected = [NSNumber numberWithInteger:80];
    NSNumber *result = [op performOperationWith:nominal];
    
    STAssertEqualObjects(result, expected, @"");
}
@end
