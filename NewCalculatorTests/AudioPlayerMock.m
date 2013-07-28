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

- (NSString *)playAudio:(id)player
{
    AVAudioPlayer *audioPlayer = player;
    return [audioPlayer.url relativeString];
}

@end
