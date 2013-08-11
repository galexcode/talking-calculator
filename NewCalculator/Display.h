//
//  Display.h
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-11.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RepeatedStrings;

@interface Display : NSObject

@property BOOL newEntry;
@property (nonatomic) BOOL containsComma;

- (void)setValueWithNumber:(NSNumber *)number;

- (NSNumber *)valueAsNumber;
- (NSString *)valueAsString;
- (NSArray *)valueAsArrayOfStrings;
- (RepeatedStrings *)valueAsArrayOfRepeatedStrings;
- (RepeatedStrings *)valueAsArrayOfRepeatedStringsWithString:(NSString *)preString;

- (void)addDigitWithString:(NSString *)digit;
- (void)addDigitWithInt:(int)digit;
- (void)addComma;
- (void)beginNewEntry;

@end
