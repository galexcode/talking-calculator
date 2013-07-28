//
//  ViewController.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-01.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "ViewController.h"
#import "MathOperator.h"
#import "Display.h"
#import "AudioPlayer.h"
#import "RepeatedStrings.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

#define ONE @"1"
#define TWO @"2"
#define THREE @"3"
#define FOUR @"4"
#define FIVE @"5"
#define SIX @"6"
#define SEVEN @"7"
#define EIGHT @"8"
#define NINE @"9"
#define ZERO @"0"

@property (strong, nonatomic) NSNumber *previousValue;
@property (strong, nonatomic) Display *displayModel;
@property (strong, nonatomic) MathOperator *operator;
@property (nonatomic) BOOL isAlpha;
@property (strong, nonatomic) AudioPlayer *audioPlayer;
@property (nonatomic) BOOL speechIsActivated;

@end

@implementation ViewController

@synthesize previousValue = _previousValue;
@synthesize display = _display;
@synthesize displayModel = _displayModel;
@synthesize operator = _operator;
@synthesize operatorButton = _operatorButton;
@synthesize isAlpha = _isAlpha;
@synthesize audioPlayer = _audioPlayer;
@synthesize speechIsActivated = _speechIsActivated;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableOperator:) name:@"DigitPressed" object:nil];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(undoEntry)];
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(clear)];
    
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    
    self.speechIsActivated = YES;
    
    [self initAudioPlayer];
}

- (void)initAudioPlayer
{
    if (self.speechIsActivated) {
        [self.audioPlayer addAudioFile:@"one_swe.m4a" withKey:ONE];
        [self.audioPlayer addAudioFile:@"two_swe.m4a" withKey:TWO];
    }
}

- (AudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil) {
        _audioPlayer =  [[AudioPlayer alloc] init];
    }
    
    return _audioPlayer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Display *)displayModel
{
    if (_displayModel == nil) {
        _displayModel = [[Display alloc] init];
    }
    return _displayModel;
}

- (void)updateDisplay
{
    self.display.text = [self.displayModel valueAsString];
}

- (void)addDigit:(NSString *)digit
{
    [self.displayModel addDigitWithString:digit];
    [self updateDisplay];
}

- (NSNumber *)getDisplayValue
{
    return [self.displayModel valueAsNumber];
}

- (void)disableOperator:(NSNotification *)notification
{ 
    [self performSelector:@selector(turnOffHighlightButton:) withObject:nil afterDelay:0.0];
}

- (IBAction)onePressed:(UIButton *)sender
{
    [self digitPressed:ONE];
}

- (IBAction)twoPressed:(UIButton *)sender
{
    [self digitPressed:TWO];
}

- (IBAction)threePressed:(UIButton *)sender
{
    [self digitPressed:THREE];
}

- (IBAction)fourPressed:(UIButton *)sender
{
    [self digitPressed:FOUR];
}
- (IBAction)fivePressed:(UIButton *)sender
{
    [self digitPressed:FIVE];
}
- (IBAction)sixPressed:(UIButton *)sender
{
    [self digitPressed:SIX];
}
- (IBAction)sevenPressed:(UIButton *)sender
{
    [self digitPressed:SEVEN];
}
- (IBAction)eightPressed:(UIButton *)sender
{
    [self digitPressed:EIGHT];
}
- (IBAction)ninePressed:(UIButton *)sender
{
    [self digitPressed:NINE];
}
- (IBAction)zeroPressed:(UIButton *)sender
{
    [self digitPressed:ZERO];
}

- (IBAction)plusPressed:(UIButton *)sender
{
    [self operatorPressed:sender withOperator:[[AddOperator alloc] init]];
}

- (IBAction)minusPressed:(UIButton *)sender
{
    [self operatorPressed:sender withOperator:[[SubOperator alloc] init]];
}

- (IBAction)multiplyPressed:(UIButton *)sender;
{
    [self operatorPressed:sender withOperator:[[MulOperator alloc] init]];
}

- (IBAction)dividePressed:(UIButton *)sender
{
    [self operatorPressed:sender withOperator:[[DivOperator alloc] init]];
}

- (void)digitPressed:(NSString *)digit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DigitPressed" object:nil];
    
    [self addDigit:digit];
    
    if (self.speechIsActivated) {
        [self.audioPlayer abortQueue];
        [self.audioPlayer playAudioWithKeyAsync:[[StringRepeated alloc] initWithString:digit]];
    }
}

- (void)turnOffHighlightButton:(id)dummy
{
    [self.operatorButton setHighlighted:NO];
}

- (void)highlightButton:(id)dummy
{
    [self.operatorButton setHighlighted:YES];
}

- (void)highlightOperatorButton:(UIButton *)sender
{
    [self.operatorButton setHighlighted:NO];
    self.operatorButton = sender;
    
    [self performSelector:@selector(highlightButton:) withObject:nil afterDelay:0.0];
}

- (void)operatorPressed:(UIButton *)sender withOperator:(MathOperator *)operator
{
    [self highlightOperatorButton:sender];

    if ([self hasOperator]) {
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
    }
    
    self.operator = operator;
    self.previousValue = [self getDisplayValue];
    [self.displayModel beginNewEntry];
}

- (void)performOperation:(NSNumber *)lhs
                 withRhs:(NSNumber *)rhs
{
    NSNumber *result = [self.operator performOperation:lhs
                                                  with:rhs];
    [self displayResult:result];
}

- (BOOL)hasOperator
{
    return !(_operator == NULL);
}

- (void)displayResult:(NSNumber *)result
{
    [self.displayModel setValueWithNumber:result];
    [self updateDisplay];
}

- (void)sayResult:(RepeatedStrings *)result
{
    [self.audioPlayer playAudioQueueWithKeys:result inBackground:YES];
}

- (IBAction)equalsPressed:(UIButton *)sender
{
    [self turnOffHighlightButton:nil];
    if ([self hasOperator]) {
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
    }
    self.operator = NULL;
    
    [self.displayModel beginNewEntry];
    
    //NSArray *resultArray = [self.displayModel valueAsArrayOfStrings];
    RepeatedStrings *resultArray = [self.displayModel valueAsArrayOfRepeatedStrings];
    [self sayResult:resultArray];
}

- (void)undoEntry
{
    self.operator = NULL;
    [self.displayModel setValueWithNumber:self.previousValue];
    [self updateDisplay];
}

- (void)clear
{
    self.operator = NULL;
    self.displayModel = [[Display alloc] init];
    [self turnOffHighlightButton:self.operatorButton];
    self.operatorButton = nil;
    [self updateDisplay];
}

// For shake recognizer
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSString *selector = nil;
        if (self.isAlpha) {
            selector = @"Numeric";
        } else {
            selector = @"Alpha";
        }
        [self performSegueWithIdentifier:selector sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Alpha"]) {
        ViewController *vc = [segue destinationViewController];
        vc.isAlpha = YES;
    } else if ([[segue identifier] isEqualToString:@"Numeric"]) {
        ViewController *vc = [segue destinationViewController];
        vc.isAlpha = NO;
    }
}

@end
