//
//  AudioPlayerMock.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-24.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "AudioPlayerMock.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioPlayerMock

@synthesize playedFiles = _playedFiles;

- (NSArray *)playedFiles
{
    if (_playedFiles == nil) {
        _playedFiles = [[NSMutableArray alloc] init];
    }
    return _playedFiles;
}
- (void)playAudio:(id)player numberOfTimes:(int)n
{
    AVAudioPlayer *audioPlayer = player;
    [self.playedFiles addObject:[audioPlayer.url relativeString]];
}

@end
