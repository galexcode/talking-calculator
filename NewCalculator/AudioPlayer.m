//
//  AudioPlayer.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-23.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "AudioPlayer.h"
#import "RepeatedStrings.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer()

@property (strong, nonatomic) NSMutableDictionary *audioPlayerDict;
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation AudioPlayer

@synthesize audioPlayerDict = _audioPlayerDict;
@synthesize queue = _queue;

- (NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)audioPlayerDict
{
    if (_audioPlayerDict == nil) {
        _audioPlayerDict = [[NSMutableDictionary alloc] init];
    }
    
    return _audioPlayerDict;
}

+ (NSArray *)splitAudioFile:(NSString *)audioFile
{
    NSArray *result = [audioFile componentsSeparatedByString:@"."];
    
    if ([result count] != 2) {
        [IncorrectFileNameException raise:audioFile format:@"Format should be 'name.type'"];
    }
    
    return result;
}

+ (NSString *)getFileName:(NSString *)audioFile
{
    return [self splitAudioFile:audioFile][0];
}

+ (NSString *)getFileExtension:(NSString *)audioFile
{
    return [self splitAudioFile:audioFile][1];
}

- (void)addAudioFile:(NSString *)audioFile withKey:(NSString *)key
{
    NSString *filename = [AudioPlayer getFileName:audioFile];
    NSString *extension = [AudioPlayer getFileExtension:audioFile];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    if (soundFilePath == nil) {
        [MissingAudioFileException raise:key format:@"File does not exist"];
    }
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    [audioPlayer setDelegate:self];
    [self.audioPlayerDict setObject:audioPlayer forKey:key];
}

- (void)resetPlayer:(AVAudioPlayer *)player withNumberOfLoops:(int)nbrOfLoops
{
    // Ugly hack to in order for audioplayer to always play
    // the correct number of times
    [player stop];
    [player setCurrentTime:(player.duration + player.duration)];
    [player setNumberOfLoops:(nbrOfLoops + 1)];
    [player prepareToPlay];
    [player setDelegate:self];
}

- (void)playAudio:(id)player
{
    [self playAudio:player numberOfTimes:1];
}

- (void)playAudio:(id)player numberOfTimes:(int)nbrTimes
{
    AVAudioPlayer *audioPlayer = player;
    [self resetPlayer:player withNumberOfLoops:nbrTimes];
    [audioPlayer play];
    self.isPlaying = YES;
}

- (AVAudioPlayer *)getPlayerForKey:(NSString *)key
{
    AVAudioPlayer *player = [self.audioPlayerDict objectForKey:key];
    if (player == nil) {
        [MissingAudioKeyException raise:key format:@"Key does not exist"];
    }
    
    return player;
}

- (void)playAudioWithKeyAsync:(StringRepeated *)key
{
    [self abortQueue];
    
    AsyncPlay *play = [[AsyncPlay alloc] initWithAudioPlayer:self andRepeatedKey:key];
    [self.queue addOperation:play];
}

- (void)playAudioWithKey:(StringRepeated *)key
{
    AVAudioPlayer *player = [self getPlayerForKey:key.value];
    [self playAudio:player numberOfTimes:key.repeated];
}

- (void)playAudioQueueWithKeys:(RepeatedStrings *)keys inBackground:(BOOL)async
{
    AsyncAudioPlayer *ap = [[AsyncAudioPlayer alloc] initWithAudioPlayer:self andKeys:keys];
    if (async) {
        [self.queue addOperation:ap];
    } else {
        NSArray *array = [[NSArray alloc] initWithObjects:ap, nil];
        [self.queue addOperations:array waitUntilFinished:YES];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.isPlaying = NO;
}

- (void)abortQueue
{
    [self.queue cancelAllOperations];
}

- (void)stopPlayerWithKey:(NSString *)key
{
    AVAudioPlayer *player = [self getPlayerForKey:key];
    [player stop];
}


@end

@implementation MissingAudioFileException @end
@implementation IncorrectFileNameException @end
@implementation MissingAudioKeyException @end


@implementation AsyncAudioPlayer

@synthesize audioPlayer = _audioPlayer;
@synthesize keys = _keys;

- (id)initWithAudioPlayer:(AudioPlayer *)audioPlayer andKeys:(RepeatedStrings *)keys {
    if (self = [super init]) {
        self.audioPlayer = audioPlayer;
        self.keys = keys;
    }
    return self;
}
-(void)main {
    @try {
        while ([self.keys hasNext]) {
            BOOL isDone = NO;
            StringRepeated *key = [self.keys nextString];
            while (![self isCancelled] && !isDone) {
                [self.audioPlayer playAudioWithKey:key];
                while (!self.isCancelled && self.audioPlayer.isPlaying) {
                    sleep(0.05);
                }
                isDone = YES;
            }
            
            if (self.isCancelled) {
                [self.audioPlayer stopPlayerWithKey:key.value];
            }
        }
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}
@end

@interface AsyncPlay()

@property (strong, nonatomic) StringRepeated *repeatedString;
@property (strong, nonatomic) AudioPlayer *audioPlayer;

@end

@implementation AsyncPlay

@synthesize repeatedString = _repeatedString;
@synthesize audioPlayer = _audioPlayer;


-(id)initWithAudioPlayer:(AudioPlayer *)player andRepeatedKey:(StringRepeated *)repeatedString
{
    if (self = [super init]) {
        self.audioPlayer = player;
        self.repeatedString = repeatedString;
    }
    return self;
}

-(void)main {
    @try {
        BOOL isDone = NO;
        while (![self isCancelled] && !isDone) {
            [self.audioPlayer playAudioWithKey:self.repeatedString];
            isDone = YES;
        }
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}
@end