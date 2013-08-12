//
//  AudioPlayerTests.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-23.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "AudioPlayerTests.h"
#import "AudioPlayerMock.h"
#import "AudioPlayer.h"
#import "RepeatedStrings.h"

@interface AudioPlayerTests ()

@property (strong, nonatomic) AudioPlayerMock* player;
@end

@implementation AudioPlayerTests

@synthesize player = _player;

AudioPlayerMock *player;

- (void)setUp
{
    _player = [[AudioPlayerMock alloc] init];
}

- (void)tearDown
{
    _player = nil;
}

- (void)testAddingAFileThatIsIncludedInTheProjectShouldNotThrow
{
    STAssertNoThrow([self.player addAudioFile:@"two_swe.m4a" withKey:@"two"], @"");
}

- (void)testAddingAFileThatIsNotIncludedInTheProjectShouldThrow
{
    STAssertThrowsSpecific([self.player addAudioFile:@"asdfa.m4a" withKey:nil], MissingAudioFileException, @"");
}

- (void)testAddingAFileThatIsIncludedButHasIncorrectFormatShouldThrow
{
    STAssertThrowsSpecific([self.player addAudioFile:@"a.b.mp3" withKey:nil],  IncorrectFileNameException, @"");
}

- (void)testAddingAnAudioFileWithoutAKeyShouldThrow
{
    STAssertThrows([self.player addAudioFile:@"two_swe.m4a" withKey:nil], @"");
}

- (void)testPlayingAKeyThatDoesNotExistShouldReturnNil
{
    StringRepeated *sr = [[StringRepeated alloc] initWithString:@"incorrect_key"];
    STAssertThrowsSpecific([self.player playAudioWithKey:sr], MissingAudioKeyException, @"");
}

- (void)testWhenPlayingAKeyTheCorrespondingFileShouldBePlayed
{
    NSString *filename = @"two_swe.m4a";
    [self.player addAudioFile:filename withKey:@"two"];
    
    StringRepeated *key = [[StringRepeated alloc] initWithString:@"two"];
    [self.player playAudioWithKey:key];
    
    NSString *filePlayed = self.player.playedFiles[0];
    STAssertTrue(filePlayed != nil, @"");
    BOOL found = [filePlayed rangeOfString:filename].location != NSNotFound;
    
    STAssertTrue(found, @"");
}

- (void)testPlayQueueShouldPlayAllTheFilesAssociatedWithTheKeys
{
    RepeatedStrings *keys = [[RepeatedStrings alloc] init];
    [keys addString:@"a"];
    [keys addString:@"b"];
    [keys addString:@"c"];
    
    [self.player addAudioFile:@"testa.m4a" withKey:@"a"];
    [self.player addAudioFile:@"testb.m4a" withKey:@"b"];
    [self.player addAudioFile:@"testc.m4a" withKey:@"c"];
    
    [self.player playAudioQueueWithKeys:keys inBackground:NO];
    NSArray *playedFiles = [self.player playedFiles];
    
    STAssertTrue([playedFiles count] != 0, @"");
    for (NSString *filename in playedFiles) {
        BOOL found = NO;
        
        if ([filename rangeOfString:@"testa.m4a"].location != NSNotFound) {
            found = YES;
        } else if ([filename rangeOfString:@"testb.m4a"].location != NSNotFound) {
            found = YES;
        } else if ([filename rangeOfString:@"testc.m4a"].location != NSNotFound) {
            found = YES;
        }

        STAssertTrue(found, @"");
    }
}

@end
