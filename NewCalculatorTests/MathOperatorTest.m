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

- (void)testCreatingAnInvalidOperatorShouldThroe
{
    
    STAssertThrowsSpecific([MathOperator createWithString:@"a"], MathOperatorException, @"");
}
@end
