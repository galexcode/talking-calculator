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
    [self.audioPlayerDict setObject:audioPlayer forKey:key];
}

- (void)resetPlayer:(AVAudioPlayer *)player
{
    [player stop];
    [player setCurrentTime:0.0];
    [player prepareToPlay];
}

- (NSString *)playAudio:(id)player
{
    AVAudioPlayer *audioPlayer = player;
    [self resetPlayer:player];
    [audioPlayer play];
    return nil;
}

- (NSString *)playAudioAndWait:(AVAudioPlayer *)player
{
    [self playAudio:player];
    while ([player isPlaying]) {
        sleep(0.1);
    }
    return nil;
}

- (AVAudioPlayer *)getPlayerForKey:(NSString *)key
{
    AVAudioPlayer *player = [self.audioPlayerDict objectForKey:key];
    if (player == nil) {
        [MissingAudioKeyException raise:key format:@"Key does not exist"];
    }
    
    return player;
}

- (NSString *)playAudioWithKey:(StringRepeated *)key
{
    [self abortQueue];
    //NSArray *keys = [NSArray arrayWithObject:key];
    
    AsyncPlay *play = [[AsyncPlay alloc] initWithAudioPlayer:self andRepeatedKey:key];
    [self.queue addOperation:play];
    return nil;
}

- (NSString *)playAudioWithRepeatedKey:(StringRepeated *)key
{
    AVAudioPlayer *player = [self getPlayerForKey:key.value];
    //[player stop];
    // Ugly hack to in order for audioplayer to always play
    // the correct number of times
    [player setCurrentTime:(player.duration + player.duration)];
    [player setNumberOfLoops:(key.repeated + 1)];
    [player prepareToPlay];
    [player play];
    while ([player isPlaying]) {
        sleep(0.1);
    }
    return nil;
}
- (NSString *)playAudioWithKeyAndWait:(NSString *)key
{
    return [self playAudioAndWait:[self getPlayerForKey:key]];
}

- (NSArray *)playAudioQueueWithKeysImpl:(NSArray *)keys
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSString *key in keys) {
        NSString *result = [self playAudioWithKeyAndWait:key];
        if (result != nil) {
            [array addObject:result];
        }
    }
    
    [self abortQueue];
    return array;
}

- (NSArray *)playAudioQueueWithKeys2:(RepeatedStrings *)keys inBackground:(BOOL)async
{
    if (async) {
        AsyncAudioPlayer *ap = [[AsyncAudioPlayer alloc] initWithAudioPlayer:self andKeys2:keys];
        
        [self.queue addOperation:ap];
        return nil;
    } else {
        //return [self playAudioQueueWithKeysImpl:keys];
        return nil;
    }
}

- (NSArray *)playAudioQueueWithKeys:(NSArray *)keys inBackground:(BOOL)async
{
    if (async) {
        AsyncAudioPlayer *ap = [[AsyncAudioPlayer alloc] initWithAudioPlayer:self andKeys:keys];
        
        [self.queue addOperation:ap];
        return nil;
    } else {
        return [self playAudioQueueWithKeysImpl:keys];
    }
}

- (void)abortQueue
{
    [self.queue cancelAllOperations];
}

@end

@implementation MissingAudioFileException @end
@implementation IncorrectFileNameException @end
@implementation MissingAudioKeyException @end


@implementation AsyncAudioPlayer

@synthesize audioPlayer = _audioPlayer;
@synthesize keys = _keys;
@synthesize keys2 = _keys2;

- (id)initWithAudioPlayer:(AudioPlayer *)audioPlayer andKeys:(NSArray *)keys {
    if (self = [super init]) {
        self.audioPlayer = audioPlayer;
        self.keys = keys;
    }
    return self;
}

- (id)initWithAudioPlayer:(AudioPlayer *)audioPlayer andKeys2:(RepeatedStrings *)keys {
    if (self = [super init]) {
        self.audioPlayer = audioPlayer;
        self.keys2 = keys;
    }
    return self;
}
-(void)main {
    @try {
        /*for (NSString *key in self.keys) {
            BOOL isDone = NO;
            while (![self isCancelled] && !isDone) {
                [self.audioPlayer playAudioWithKeyAndWait:key];
                isDone = YES;
            }
        }*/
        while ([self.keys2 hasNext]) {
            BOOL isDone = NO;
            while (![self isCancelled] && !isDone) {
                StringRepeated *sr = [self.keys2 nextString];
                [self.audioPlayer playAudioWithRepeatedKey:sr];
                isDone = YES;
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

@end

@implementation AsyncPlay

@synthesize repeatedString = _repeatedString;


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
        /*BOOL isDone = NO;
        while (![self isCancelled] && !isDone) {
            [self.audioPlayer playAudio:[self.audioPlayer getPlayerForKey:self.keys[0]]];
            isDone = YES;
        }*/
        BOOL isDone = NO;
        while (![self isCancelled] && !isDone) {
            [self.audioPlayer playAudioWithRepeatedKey:self.repeatedString];
            isDone = YES;
        }
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}
@end