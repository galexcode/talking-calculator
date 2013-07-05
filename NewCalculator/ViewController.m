//
//  ViewController.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-01.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "ViewController.h"
#import "MathOperator.h"

@interface ViewController ()

@property double currentValue;
@property BOOL newEntry;
@property (strong, nonatomic) MathOperator *operator;

@end

@implementation ViewController

@synthesize currentValue = _currentValue;
@synthesize newEntry = _newEntry;
@synthesize operator = _operator;
@synthesize display = _display;
@synthesize operatorButton = _operatorButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newEntry = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableOperator:) name:@"DigitPressed" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDigitToCurrentValue:(NSString *)digit
{
    NSString *currentValue = self.display.text;
    NSString *result = NULL;
    
    if ([currentValue isEqualToString:@"0"]) {
        result = digit;
    } else {
        result = [self.display.text stringByAppendingString:digit];
    }
    
    self.display.text = result;
}

- (void)addDigit:(NSString *)digit
{
    if (self.newEntry) {
        self.display.text = digit;
        self.newEntry = NO;
    } else {
        [self addDigitToCurrentValue:digit];
    }
}

- (double)getDisplayValue
{
    return [self.display.text doubleValue];
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

- (BOOL)shouldPerformCalculation:(MathOperator *)oldOperator
{
    return [oldOperator class] == [self.operator class];
}

- (IBAction)operatorPressed:(UIButton *)sender
{
    [self highlightOperatorButton:sender];
    MathOperator *oldOperator = self.operator;
    self.operator = [MathOperator createWithString:[self.operatorButton  currentTitle]];
    
    if ([self shouldPerformCalculation:oldOperator]) {
        [self performOperation:self.currentValue withRhs:[self getDisplayValue]];
    }
    
    self.currentValue = [self getDisplayValue];
    self.newEntry = YES;
}

- (void)performOperation:(double)lhs
                 withRhs:(double)rhs
{
    NSNumber *result = [self.operator performOperation:[NSNumber numberWithDouble:lhs]
                                                  with:[NSNumber numberWithDouble:rhs]];
    [self displayResult:result];
}

- (BOOL)hasOperator
{
    return !(_operator == NULL);
}

- (void)displayResult:(NSNumber *)result
{
    self.display.text = [result stringValue];
}

- (IBAction)eqaulsPressed:(UIButton *)sender
{
    [self turnOffHighlightButton:nil];
    double rhs = [self.display.text doubleValue];
    if ([self hasOperator]) {
        [self performOperation:self.currentValue withRhs:rhs];
    }
    self.operator = NULL;
    self.newEntry = YES;
}

@end
