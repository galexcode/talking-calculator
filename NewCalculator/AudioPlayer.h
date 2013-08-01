//
//  AudioPlayer.h
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-23.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RepeatedStrings;
@class StringRepeated;

@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>

@property (atomic) BOOL isPlaying;

- (void)addAudioFile:(NSString *)audioFile withKey:(NSString *)key;
- (void)playAudioWithKeyAsync:(StringRepeated *)key;
- (void)playAudioWithKey:(StringRepeated *)key;
- (void)playAudioQueueWithKeys:(RepeatedStrings *)keys inBackground:(BOOL)async;
- (void)playAudio:(id)player;
- (void)abortQueue;
- (void)stop;

@end

@interface MissingAudioFileException : NSException @end
@interface IncorrectFileNameException : NSException @end
@interface MissingAudioKeyException : NSException @end

@interface AsyncAudioPlayer : NSOperation

@property (strong) AudioPlayer *audioPlayer;
@property (strong) RepeatedStrings *keys;
-(id)initWithAudioPlayer:(AudioPlayer *)player andKeys:(RepeatedStrings *)keys;

@end

@interface AsyncPlay : NSOperation

-(id)initWithAudioPlayer:(AudioPlayer *)player andRepeatedKey:(StringRepeated *)repeatedString;
@end
