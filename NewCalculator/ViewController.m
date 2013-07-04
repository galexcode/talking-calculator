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
@property (strong, nonatomic) NSMutableArray *operatorButtons;

@end

@implementation ViewController

@synthesize currentValue = _currentValue;
@synthesize newEntry = _newEntry;
@synthesize operator = _operator;
@synthesize display = _display;
@synthesize operatorButton = _operatorButton;
@synthesize minusButton = _minusButton;
@synthesize operatorButtons = _operatorButtons;

- (NSMutableArray *)operatorButtons
{
    if (_operatorButtons == NULL) {
        _operatorButtons = [[NSMutableArray alloc] initWithCapacity:2];
        [_operatorButtons addObject:self.operatorButton];
        [_operatorButtons addObject:self.minusButton];
    }
    return _operatorButtons;
}

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
    //[operator setHighlighted:NO];
    for (int i = 0; i < [self.operatorButtons count]; i++) {
        UIButton *button = [self.operatorButtons objectAtIndex:i];
        
        [self performSelector:@selector(turnOffHighlightButton:) withObject:button afterDelay:0.0];
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DigitPressed" object:nil];
    
    NSString *digit = [sender currentTitle];
    [self addDigit:digit];
}

- (void)highlightButton:(UIButton *)button
{
    [button setHighlighted:YES];
}

- (void)turnOffHighlightButton:(UIButton *)button
{
    [button setHighlighted:NO];
}

- (IBAction)operatorPressed:(UIButton *)sender
{
    [self disableOperator:nil];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    
    MathOperator *oldOperator = self.operator;
    self.operator = [MathOperator createWithString:[sender currentTitle]];
    
    if ([oldOperator class] == [self.operator class]) {
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
