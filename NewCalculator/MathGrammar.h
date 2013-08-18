//
//  MathGrammar.h
//  Leo Calc
//
//  Created by Olof Hellquist on 2013-08-17.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathGrammar : NSObject

+ (MathGrammar *)grammarWithInt:(int)number;

- (int)powerOfTen;
- (int)valueOfPowerOfTen:(int)powerOfTen;
- (NSArray *)getSpeechRepresentation;

@end
