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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newEntry = YES;
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

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    [self addDigit:digit];
}

- (IBAction)operatorPressed:(UIButton *)sender
{
    BOOL performCalculation = [self hasOperator];
    self.operator = [MathOperator createWithString:[sender currentTitle]];
    
    if (performCalculation) {
        double result = [self performOperation:self.currentValue :[self getDisplayValue]];
        [self displayResult:result];
    }
    
    self.currentValue = [self getDisplayValue];
    self.newEntry = YES;
}

- (double)performOperation:(double)lhs :(double)rhs
{
    return [self.operator calculate:lhs with:rhs];
}

- (BOOL)hasOperator
{
    return !(_operator == NULL);
}

- (void)displayResult:(double)result
{
    self.display.text = [NSString stringWithFormat:@"%d", (int)result];
}

- (IBAction)eqaulsPressed:(UIButton *)sender
{
    double rhs = [self.display.text doubleValue];
    if ([self hasOperator]) {
        double result = [self performOperation:self.currentValue :rhs];
        [self displayResult:result];
    }
    self.operator = NULL;
    self.newEntry = YES;
}

@end
