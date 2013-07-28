//
//  RepeatedStrings.h
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-27.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringRepeated : NSObject

@property (strong, nonatomic) NSString *value;
@property int repeated;

- (id)initWithString:(NSString *)string;
- (void)increment;
@end

@interface RepeatedStrings : NSObject;

- (void)addString:(NSString *)string;
- (BOOL)hasNext;
- (StringRepeated *)nextString;

@end
