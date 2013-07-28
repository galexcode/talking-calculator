//
//  RepeatedStrings.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-27.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "RepeatedStrings.h"

@implementation StringRepeated

@synthesize value = _value;
@synthesize repeated = _repeated;

- (id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        self.value = string;
        self.repeated = 0;
    }
    return self;
}

- (id)init
{
    return [self initWithString:@""];
}

- (void)increment
{
    self.repeated++;
}

@end

@interface RepeatedStrings()
@property (strong, nonatomic) NSMutableArray* repeatedStrings;
@property int index;
@end


@implementation RepeatedStrings

@synthesize repeatedStrings = _repeatedStrings;
@synthesize index = _index;

- (NSMutableArray *)repeatedStrings
{
    if (_repeatedStrings == nil) {
        _repeatedStrings = [[NSMutableArray alloc] init];
    }
    return _repeatedStrings;
}

- (BOOL)hasNext
{
    return self.index < [self.repeatedStrings count];
}

- (StringRepeated *)nextString
{
    return self.repeatedStrings[self.index++];
}

- (void)addString:(NSString *)string
{
    int size = [self.repeatedStrings count];
    if (size > 0) {
        StringRepeated *sr = [self.repeatedStrings objectAtIndex:(size - 1)];
        if ([sr.value isEqualToString:string]) {
            [sr increment];
            return;
        }
    }
    
    [self.repeatedStrings addObject:[[StringRepeated alloc] initWithString:string]];
}

@end