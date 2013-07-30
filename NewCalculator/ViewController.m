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
#import "SettingsViewController.h"
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

#define MUL @"*"
#define DIV @"/"
#define PLUS @"+"
#define MINUS @"-"

#define EQUAL @"="

#define DOT @"."

@property (strong, nonatomic) NSNumber *previousValue;
@property (strong, nonatomic) Display *displayModel;
@property (strong, nonatomic) MathOperator *operator;
@property (strong, nonatomic) AudioPlayer *audioPlayer;
@property (nonatomic) BOOL buttonSpeechIsActivated;
@property (nonatomic) BOOL resultSpeechIsActivated;

@end

@implementation ViewController

@synthesize previousValue = _previousValue;
@synthesize display = _display;
@synthesize displayModel = _displayModel;
@synthesize operator = _operator;
@synthesize operatorButton = _operatorButton;
@synthesize isAlpha = _isAlpha;
@synthesize audioPlayer = _audioPlayer;
@synthesize buttonSpeechIsActivated = _buttonSpeechIsActivated;
@synthesize resultSpeechIsActivated = _resultSpeechIsActivated;

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
}

- (BOOL)buttonSpeechIsActivated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"buttonSpeechActivated"];
}

- (BOOL)resultSpeechIsActivated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"resultSpeechActivated"];
}

- (void)initAudioPlayer
{
    // Digits
    [_audioPlayer addAudioFile:@"one_swe.m4a" withKey:ONE];
    [_audioPlayer addAudioFile:@"two_swe.m4a" withKey:TWO];
    [_audioPlayer addAudioFile:@"three_swe.m4a" withKey:THREE];
    [_audioPlayer addAudioFile:@"four_swe.m4a" withKey:FOUR];
    [_audioPlayer addAudioFile:@"five_swe.m4a" withKey:FIVE];
    [_audioPlayer addAudioFile:@"six_swe.m4a" withKey:SIX];
    [_audioPlayer addAudioFile:@"seven_swe.m4a" withKey:SEVEN];
    [_audioPlayer addAudioFile:@"eight_swe.m4a" withKey:EIGHT];
    [_audioPlayer addAudioFile:@"nine_swe.m4a" withKey:NINE];
    [_audioPlayer addAudioFile:@"zero_swe.m4a" withKey:ZERO];
    
    // Operators
    [_audioPlayer addAudioFile:@"mul_swe.m4a" withKey:MUL];
    [_audioPlayer addAudioFile:@"div_swe.m4a" withKey:DIV];
    [_audioPlayer addAudioFile:@"plus_swe.m4a" withKey:PLUS];
    [_audioPlayer addAudioFile:@"minus_swe.m4a" withKey:MINUS];
    
    
    [_audioPlayer addAudioFile:@"equal_swe.m4a" withKey:EQUAL];
    [_audioPlayer addAudioFile:@"dot_swe.m4a" withKey:DOT];
}

- (AudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil) {
        _audioPlayer =  [[AudioPlayer alloc] init];
        [self initAudioPlayer];
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
    [self operatorPressed:sender withOperator:PLUS];
}

- (IBAction)minusPressed:(UIButton *)sender
{
    [self operatorPressed:sender withOperator:MINUS];
}

- (IBAction)multiplyPressed:(UIButton *)sender;
{
    [self operatorPressed:sender withOperator:MUL];
}

- (IBAction)dividePressed:(UIButton *)sender
{
    [self operatorPressed:sender withOperator:DIV];
}

- (void)digitPressed:(NSString *)digit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DigitPressed" object:nil];
    
    [self addDigit:digit];
    
    if (self.buttonSpeechIsActivated) {
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

- (void)operatorPressed:(UIButton *)sender withOperator:(NSString *)operator
{
    [self highlightOperatorButton:sender];
    if (self.buttonSpeechIsActivated) {
        [self.audioPlayer playAudioWithKeyAsync:[[StringRepeated alloc] initWithString:operator]];
    }

    if ([self hasOperator]) {
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
    }
    
    self.operator = [MathOperator createWithString:operator];
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
    
    if (self.resultSpeechIsActivated) {
        RepeatedStrings *resultArray = [self.displayModel valueAsArrayOfRepeatedStringsWithString:EQUAL];
        [self sayResult:resultArray];
    }
}

- (IBAction)settingsPressed {
    UIViewController * controller = [[self storyboard] instantiateViewControllerWithIdentifier: @"Apa"];
    
    [self.navigationController pushViewController:controller animated:YES];
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
        NSString *viewControllerName = nil;
        if (self.isAlpha) {
            // Uses the fact the numeric calculator is the root view.
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            int lang = [[NSUserDefaults standardUserDefaults] integerForKey:@"Language"];
            if (lang == 0) {
                viewControllerName = @"AlphabeticCalculatorSwe";
            } else {
                viewControllerName = @"AlphabeticCalculator";
            }
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerName];
            viewController.isAlpha = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
