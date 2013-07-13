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

@interface ViewController ()

@property (strong, nonatomic) NSNumber *previousValue;
@property (strong, nonatomic) Display *displayModel;
@property (strong, nonatomic) MathOperator *operator;

@end

@implementation ViewController

@synthesize previousValue = _previousValue;
@synthesize display = _display;
@synthesize displayModel = _displayModel;
@synthesize operator = _operator;
@synthesize operatorButton = _operatorButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableOperator:) name:@"DigitPressed" object:nil];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(undoEntry)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
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
    return [NSNumber numberWithDouble:[self.display.text doubleValue]];
}

- (void)disableOperator:(NSNotification *)notification
{ 
    [self performSelector:@selector(turnOffHighlightButton:) withObject:nil afterDelay:0.0];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DigitPressed" object:nil];
    
    NSString *digit = [sender currentTitle];
    [self addDigit:digit];
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

- (IBAction)operatorPressed:(UIButton *)sender
{
    [self highlightOperatorButton:sender];

    if ([self hasOperator]) {
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
    }
    
    self.operator = [MathOperator createWithString:[self.operatorButton  currentTitle]];
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

- (IBAction)eqaulsPressed:(UIButton *)sender
{
    [self turnOffHighlightButton:nil];
    if ([self hasOperator]) {
        [self performOperation:self.previousValue withRhs:[self getDisplayValue]];
    }
    self.operator = NULL;
    [self.displayModel beginNewEntry];
}

- (void)undoEntry
{
    self.operator = NULL;
    [self.displayModel setValueWithNumber:self.previousValue];
    [self updateDisplay];
}

@end
