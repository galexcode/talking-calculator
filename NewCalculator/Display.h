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

- (void)setValueWithNumber:(NSNumber *)number;

- (NSNumber *)valueAsNumber;
- (NSString *)valueAsString;
- (NSArray *)valueAsArrayOfStrings;
- (RepeatedStrings *)valueAsArrayOfRepeatedStrings;

- (void)addDigitWithString:(NSString *)digit;
- (void)addDigitWithInt:(int)digit;
- (void)beginNewEntry;

@end
