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
    STAssertEqualObjects([display valueAsNumber], [NSNumber numberWithInt:1000000000], @"");
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

- (void)testValuAsArrayOfStringsShouldReturnEachDigitAsAString
{
    Display *display = [[Display alloc] init];
    [display addDigitWithInt:5];
    [display addDigitWithInt:3];
    [display addDigitWithInt:4];
    
    NSArray *stringArray = [display valueAsArrayOfStrings];
    
    STAssertTrue([stringArray count] == 3, @"");
    STAssertEqualObjects(stringArray[0], @"5", @"");
    STAssertEqualObjects(stringArray[1], @"3", @"");
    STAssertEqualObjects(stringArray[2], @"4", @"");
}

- (void)testAddingACommaShouldPlaceACommaAsTheLastCharacter
{
    Display *display = [[Display alloc] init];
    [display addDigitWithInt:3];
    [display addComma];
    [display addDigitWithInt:4];
    
    STAssertEqualObjects([display valueAsString], @"3.4", @"");

}

- (void)testIfTheDisplayContainsACommaTryingToAddAnotherOneShouldBeIgnored
{
    Display *display = [[Display alloc] init];
    [display addDigitWithInt:3];
    [display addComma];
    [display addDigitWithInt:4];
    [display addComma];
    
    STAssertEqualObjects([display valueAsString], @"3.4", @"");
}

- (void)testAfterACommaNoSpacesShouldBeAdded
{
    Display *display = [[Display alloc] init];
    [display addDigitWithInt:3];
    [display addComma];
    [display addDigitWithInt:4];
    [display addDigitWithInt:2];
    [display addDigitWithInt:4];
    [display addDigitWithInt:1];
    [display addDigitWithInt:7];
    
    STAssertEqualObjects([display valueAsString], @"3.42417", @"");
}

- (void)testADecimalNumberShouldCorrectlyHaveAdditionalSpaces
{
    NSNumber *decimalNumber = [NSNumber numberWithDouble:1234.6789];
    
    Display *display = [[Display alloc] init];
    [display setValueWithNumber:decimalNumber];
    
    STAssertEqualObjects([display valueAsString], @"1 234.6789", @"");
}

- (void)testWhenBeginningANewEntryContainsCommaShouldBeFalse
{
    
    Display *display = [[Display alloc] init];
    [display addComma];
    STAssertTrue(display.containsComma, @"");
    [display beginNewEntry];
    STAssertFalse(display.containsComma, @"");
}

@end