//
//  MathGrammarTests.m
//  Leo Calc
//
//  Created by Olof Hellquist on 2013-08-17.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "MathGrammarTests.h"
#import "MathGrammar.h"

@interface MathGrammarTests ()
@property (strong, nonatomic) MathGrammar *grammar;
@end

@implementation MathGrammarTests

- (void)setUp
{
    self.grammar = [MathGrammar grammarWithInt:435];
}

- (void)testAThreeDigitIntShouldBeDividedInHundredTensAndSingles
{
    int powerOfTen = [self.grammar powerOfTen];
    STAssertEquals(powerOfTen, 2, @"");
}

- (void)testForAGivenPowerOfTenTheCorrespondingValueShouldBeRetrieved
{
    int value = [self.grammar valueOfPowerOfTen:1];
    STAssertEquals(value, 3, @"");
}

- (void)testForAGivenPowerOfTenTheCorrespondingValueShouldBeRetrieved2
{
    int value = [self.grammar valueOfPowerOfTen:2];
    STAssertEquals(value, 4, @"");
}

- (void)testForAGivenPowerOfTenTheCorrespondingValueShouldBeRetrieved3
{
    int value = [self.grammar valueOfPowerOfTen:0];
    STAssertEquals(value, 5, @"");
}

- (void)testIfAGivenPowerIsGreaterThanTheNumberZeroShuoldBeReturned
{
    int value = [self.grammar valueOfPowerOfTen:3];
    STAssertEquals(value, 0, @"");
}

- (void)testSpeechRepresentationUpToTwentyShouldBeUniques
{
    NSArray *expected = [NSArray arrayWithObjects:@"18", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:18];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
}

- (void)testANumberShouldBeRepresentedAsAnArrayOfKeys
{
    NSArray *expected = [NSArray arrayWithObjects:@"4", @"1000", @"2", @"100", @"40", @"3", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:4243];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
}

- (void)testANumberShouldBeRepresentedAsAnArrayOfKeysHundred
{
    NSArray *expected = [NSArray arrayWithObjects:@"4", @"100", @"2", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:402];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
}

- (void)testANumberShouldBeRepresentedAsAnArrayOfKeysThousand
{
    NSArray *expected = [NSArray arrayWithObjects:@"4", @"1000", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:4000];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
}

- (void)testSpeechRepresentationOfTenThousandWithTip
{
    NSArray *expected = [NSArray arrayWithObjects:@"50", @"8", @"1000", @"3", @"100", @"20", @"6", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:58326];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
    
}

- (void)testSpeechRepresentationOfHundredThousandWithTip
{
    NSArray *expected = [NSArray arrayWithObjects:@"5", @"100", @"20",@"3", @"1000", @"3", @"100", @"20", @"6", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:523326];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
    
}

- (void)testSpeechRepresentationOfMillion
{
    NSArray *expected = [NSArray arrayWithObjects:@"5", @"1000000", @"3", @"100",@"1000", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:5300000];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
    
}

- (void)testSpeechRepresentationOfMillionWithTip
{
    NSArray *expected = [NSArray arrayWithObjects:@"5", @"1000000", @"3", @"100",@"20", @"6", @"1000", @"80", @"2",nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:5326082];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
    
}

- (void)testSpeechRepresentationOfHundredMillionWithTip
{
    NSArray *expected = [NSArray arrayWithObjects:@"7", @"100", @"90", @"2", @"1000000", @"3", @"100",@"20", @"6", @"1000", @"80", @"2",nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:792326082];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
    
}

- (void)testSpeechRepresentationOfBillion
{
    NSArray *expected = [NSArray arrayWithObjects:@"2", @"1000000000", nil];
    
    MathGrammar *g = [MathGrammar grammarWithInt:2000000000];
    NSArray *result = [g getSpeechRepresentation];
    STAssertEqualObjects(result, expected, @"");
    
}
@end
