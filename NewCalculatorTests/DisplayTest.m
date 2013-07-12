//
//  DisplayTest.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-11.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "DisplayTest.h"
#import "Display.h"

@implementation DisplayTest

- (void)testItShouldBePossibleToGetTheValueAsANumber
{
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:534]];
    
    STAssertEqualObjects([display valueAsNumber], [NSNumber numberWithInt:534], @"");
}

- (void)testItShouldBePossibleToGetTheValueAsAString
{
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:534]];
    
    STAssertEqualObjects([display valueAsString], @"534", @"");
    
}

- (void)testWhenAValueContains4DigitsTheSecondCharacterShouldBeASpace
{
    
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:5342]];
    
    STAssertEqualObjects([display valueAsString], @"5 342", @"");
}

- (void)testAValueThatContainsASpaceShouldBeRepresentedAsANormalNumber
{
    
    Display *display = [[Display alloc] init];
    [display addDigitWithInt:5];
    [display addDigitWithInt:3];
    [display addDigitWithInt:4];
    [display addDigitWithInt:2];
    
    STAssertEqualObjects([display valueAsNumber], [NSNumber numberWithInt:5342], @"");
}

- (void)testWhenAValueContains7DigitsThe2ndAnd5thCharacterShouldBeASpace
{
    
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:5342123]];
    
    STAssertEqualObjects([display valueAsString], @"5 342 123", @"");
}

- (void)testAValueOf1BillionShouldInclude3Spaces
{
    
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:1000000000]];
    
    STAssertEqualObjects([display valueAsString], @"1 000 000 000", @"");
}

- (void)testAddingADigitShouldPutItAtTheEndOfTheCurrentValue
{
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:2]];
    
    [display addDigitWithInt:5];
    STAssertEqualObjects([display valueAsString], @"25", @"");
}

- (void)testAddingADigitShouldPutItAtTheEndOfTheCurrentValueString
{
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:2]];
    
    [display addDigitWithString:@"5"];
    STAssertEqualObjects([display valueAsString], @"25", @"");
}

- (void)testWhenAWithANewEntryThePreviousValueShouldBeDiscarded
{
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:[NSNumber numberWithInt:2]];
    [display addDigitWithString:@"5"];
    
    [display beginNewEntry];
    [display addDigitWithInt:4];
    [display addDigitWithInt:7];
    STAssertEqualObjects([display valueAsString], @"47", @"");
}

- (void)testAdding0ToA0ShouldDoNothing
{
    Display *display = [[Display alloc] init];
    [display addDigitWithInt:0];
    [display addDigitWithInt:0];
    
    STAssertEqualObjects([display valueAsString], @"0", @"");
}

- (void)testTheDefaultValueShouldBe0
{
    Display *display = [[Display alloc] init];
    
    STAssertEqualObjects([display valueAsString], @"0", @"");
}

- (void)testIfADigitIsAddedToZeroTheDigitShouldBeTheNewValue
{
    Display *display = [[Display alloc] init];
    
    [display addDigitWithInt:0];
    [display addDigitWithInt:2];
    
    STAssertEqualObjects([display valueAsString], @"2", @"");
}


@end