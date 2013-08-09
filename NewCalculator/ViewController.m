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
#define INCL_TAX @"Tax+"
#define EXCL_TAX @"Tax-"

#define DOT @"."

@property (strong, nonatomic) NSNumber *previousValue;
@property (strong, nonatomic) Display *displayModel;
@property (strong, nonatomic) MathOperator *operator;
@property (strong, nonatomic) AudioPlayer *audioPlayer;
@property (nonatomic) BOOL buttonSpeechIsActivated;
@property (nonatomic) BOOL resultSpeechIsActivated;
@property (nonatomic) int language;

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
@synthesize language = _language;

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
    int lang = [[NSUserDefaults standardUserDefaults] integerForKey:@"Language"];
    self.language = lang;
    
    if (lang == 0) {
        [self initAudioPlayerSwe];
    } else if (lang == 1) {
        [self initAudioPlayerEn];
    }
}

- (void)initAudioPlayerWithFileNames:(NSArray *)filenames
{
    _audioPlayer =  [[AudioPlayer alloc] init];
    
    [_audioPlayer addAudioFile:filenames[0] withKey:ONE];
    [_audioPlayer addAudioFile:filenames[1] withKey:TWO];
    [_audioPlayer addAudioFile:filenames[2] withKey:THREE];
    [_audioPlayer addAudioFile:filenames[3] withKey:FOUR];
    [_audioPlayer addAudioFile:filenames[4] withKey:FIVE];
    [_audioPlayer addAudioFile:filenames[5] withKey:SIX];
    [_audioPlayer addAudioFile:filenames[6] withKey:SEVEN];
    [_audioPlayer addAudioFile:filenames[7] withKey:EIGHT];
    [_audioPlayer addAudioFile:filenames[8] withKey:NINE];
    [_audioPlayer addAudioFile:filenames[9] withKey:ZERO];
    
    // Operators
    [_audioPlayer addAudioFile:filenames[10] withKey:MUL];
    [_audioPlayer addAudioFile:filenames[11] withKey:DIV];
    [_audioPlayer addAudioFile:filenames[12] withKey:PLUS];
    [_audioPlayer addAudioFile:filenames[13] withKey:MINUS];
    
    
    [_audioPlayer addAudioFile:filenames[14] withKey:EQUAL];
    [_audioPlayer addAudioFile:filenames[15] withKey:DOT];
}

- (void)initAudioPlayerSwe
{
    NSArray *files = [[NSArray alloc] initWithObjects:@"one_swe.m4a", @"two_swe.m4a", @"three_swe.m4a", @"four_swe.m4a", @"five_swe.m4a", @"six_swe.m4a", @"seven_swe.m4a", @"eight_swe.m4a", @"nine_swe.m4a", @"zero_swe.m4a", @"mul_swe.m4a", @"div_swe.m4a", @"plus_swe.m4a", @"minus_swe.m4a", @"equal_swe.m4a", @"dot_swe.m4a", nil];
    [self initAudioPlayerWithFileNames:files];
}

- (void)initAudioPlayerEn
{
    NSArray *files = [[NSArray alloc] initWithObjects:@"one_en.m4a", @"two_en.m4a", @"three_en.m4a", @"four_en.m4a", @"five_en.m4a", @"six_en.m4a", @"seven_en.m4a", @"eight_en.m4a", @"nine_en.m4a", @"zero_en.m4a", @"mul_en.m4a", @"div_en.m4a", @"plus_en.m4a", @"minus_en.m4a", @"equal_en.m4a", @"dot_en.m4a", nil];
    [self initAudioPlayerWithFileNames:files];
}

- (AudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil) {
        [self initAudioPlayer];
    } else if (self.language != [[NSUserDefaults standardUserDefaults] integerForKey:@"Language"]) {
        _audioPlayer = [[AudioPlayer alloc] init];
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
    // TODO refactor!!
    if (!(self.displayModel.newEntry) && [self hasOperator]) {
        [self highlightOperatorButton:sender];
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
        self.operator = [MathOperator createWithString:operator];
        self.previousValue = [self getDisplayValue];
        [self.displayModel beginNewEntry];
    } else if (self.operatorButton == sender) {
        self.displayModel.newEntry = NO;
        [self.operatorButton setHighlighted:NO];
        self.operatorButton = nil;
        self.operator = nil;
    } else {
        [self highlightOperatorButton:sender];
        
        if (self.buttonSpeechIsActivated) {
            [self.audioPlayer playAudioWithKeyAsync:[[StringRepeated alloc] initWithString:operator]];
        }
        
        self.operator = [MathOperator createWithString:operator];
        self.previousValue = [self getDisplayValue];
        [self.displayModel beginNewEntry];
    }
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

- (void)sayResultWithPrefix:(NSString *)prefix
{
    if (self.resultSpeechIsActivated) {
        RepeatedStrings *resultArray = [self.displayModel valueAsArrayOfRepeatedStringsWithString:prefix];
        [self.audioPlayer playAudioQueueWithKeys:resultArray inBackground:YES];
    }
}

- (IBAction)equalsPressed:(UIButton *)sender
{
    [self turnOffHighlightButton:nil];
    if ([self hasOperator]) {
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
    }
    self.operator = nil;
    self.operatorButton = nil;
    
    [self.displayModel beginNewEntry];
    [self sayResultWithPrefix:EQUAL];
}

- (IBAction)settingsPressed
{
    UIViewController * controller = [[self storyboard] instantiateViewControllerWithIdentifier: @"Apa"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)performTaxCalculation:(NSString *)taxOperator
{
    // TODO refactor
    self.previousValue = [self getDisplayValue];
    int taxRateTimesHundred = [[NSUserDefaults standardUserDefaults] integerForKey:@"TaxRate"];
    UnaryOperator *operator = [UnaryOperator createFromString:taxOperator];
    operator.intNumber = taxRateTimesHundred;
    NSNumber *currentValue = [self getDisplayValue];
    NSNumber *result = [operator performOperationWith:currentValue];
    [self displayResult:result];
    [self sayResultWithPrefix:taxOperator];
    [self.displayModel beginNewEntry];
}

- (IBAction)inclTaxPressed
{
    [self performTaxCalculation:INCL_TAX];
}

- (IBAction)exclTaxPressed
{
    [self performTaxCalculation:EXCL_TAX];
}

- (void)undoEntry
{
    self.operator = NULL;
    [self.displayModel setValueWithNumber:self.previousValue];
    [self addDisplayLabelAnimation];
    [self updateDisplay];
}

- (void)addDisplayLabelAnimation
{
    [self addFlashAnimationToLayer:self.display.layer withDuration:0.2 andStartValue:0.1];
}

- (void)removeDisplayLabelAnimation
{
    [[self.display layer] removeAnimationForKey:@"flash"];
}

- (void)addFlashAnimationToLayer:(CALayer *)layer withDuration:(float)duration andStartValue:(float)startValue
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [anim setFromValue:[NSNumber numberWithFloat:startValue]];
    [anim setToValue:[NSNumber numberWithFloat:1.0]];
    [anim setDuration:duration];
    [layer addAnimation:anim forKey:@"flash"];
}

- (void)clear
{
    self.operator = NULL;
    self.displayModel = [[Display alloc] init];
    [self turnOffHighlightButton:self.operatorButton];
    self.operatorButton = nil;
    [self addFlashAnimationToLayer:self.view.layer withDuration:0.5 andStartValue:0.0];
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
