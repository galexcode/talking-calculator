//
//  StringRepeatedTest.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-27.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "RepeatedStringsTest.h"
#import "RepeatedStrings.h"

@implementation RepeatedStringsTest

- (void)testAfterIncrementingTheRepeatedValueShouldIncreaseByOne
{
    StringRepeated *sr = [[StringRepeated alloc] init];
    [sr increment];
    
    STAssertTrue(sr.repeated == 1, @"");
    [sr increment];
    STAssertTrue(sr.repeated == 2, @"");
}

- (void)testItShouldBePossibleInitWithAString
{
    StringRepeated *sr = [[StringRepeated alloc] initWithString:@"asdf"];
    
    STAssertEqualObjects(sr.value, @"asdf", @"");
    STAssertTrue(sr.repeated == 0, @"");
}

- (void)testAfterAddingAStringToRepeatedStringsItShouldBeRepeatedZeroTimes
{
    RepeatedStrings *repeatedStrings = [[RepeatedStrings alloc] init];
    [repeatedStrings addString:@"apa"];
    
    StringRepeated *s = [repeatedStrings nextString];
    STAssertTrue(s.repeated == 0, @"");
    STAssertEqualObjects(s.value, @"apa", @"");
}

- (void)testAfterAddingTwoDifferentStringsItShouldContainTwoStringsRepeatedZeroTimes
{
    RepeatedStrings *repeatedStrings = [[RepeatedStrings alloc] init];
    [repeatedStrings addString:@"apa"];
    [repeatedStrings addString:@"paj"];
    
    StringRepeated *s = [repeatedStrings nextString];
    STAssertTrue(s.repeated == 0, @"");
    STAssertEqualObjects(s.value, @"apa", @"");
    
    StringRepeated *s2 = [repeatedStrings nextString];
    STAssertTrue(s2.repeated == 0, @"");
    STAssertEqualObjects(s2.value, @"paj", @"");
}

- (void)testAfterAddingTwoDifferentStringsItShouldContainTwoStrings
{
    RepeatedStrings *repeatedStrings = [[RepeatedStrings alloc] init];
    [repeatedStrings addString:@"apa"];
    [repeatedStrings addString:@"paj"];
    
    int size = 0;
    while ([repeatedStrings hasNext]) {
        (void)[repeatedStrings nextString];
        size++;
    }
    
    STAssertTrue(size == 2, @"");
}

- (void)testAfterAddingTwoIdenticalStringsItShouldContainOneStringRepeatedOnce
{
    RepeatedStrings *repeatedStrings = [[RepeatedStrings alloc] init];
    [repeatedStrings addString:@"apa"];
    [repeatedStrings addString:@"apa"];
    
    int size = 0;
    while ([repeatedStrings hasNext]) {
        StringRepeated *sr = [repeatedStrings nextString];
        STAssertTrue(sr.repeated == 1, @"");
        size++;
    }
    
    STAssertTrue(size == 1, @"");
}


@end
