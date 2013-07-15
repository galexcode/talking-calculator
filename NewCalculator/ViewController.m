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
@property (nonatomic) BOOL isAlpha;

@end

@implementation ViewController

@synthesize previousValue = _previousValue;
@synthesize display = _display;
@synthesize displayModel = _displayModel;
@synthesize operator = _operator;
@synthesize operatorButton = _operatorButton;
@synthesize isAlpha = _isAlpha;

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
    [self digitPressed:@"1"];
}

- (IBAction)twoPressed:(UIButton *)sender
{
    [self digitPressed:@"2"];
}

- (IBAction)threePressed:(UIButton *)sender
{
    [self digitPressed:@"3"];
}

- (IBAction)fourPressed:(UIButton *)sender
{
    [self digitPressed:@"4"];
}
- (IBAction)fivePressed:(UIButton *)sender
{
    [self digitPressed:@"5"];
}
- (IBAction)sixPressed:(UIButton *)sender
{
    [self digitPressed:@"6"];
}
- (IBAction)sevenPressed:(UIButton *)sender
{
    [self digitPressed:@"7"];
}
- (IBAction)eightPressed:(UIButton *)sender
{
    [self digitPressed:@"8"];
}
- (IBAction)ninePressed:(UIButton *)sender
{
    [self digitPressed:@"9"];
}
- (IBAction)zeroPressed:(UIButton *)sender
{
    [self digitPressed:@"0"];
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

- (IBAction)equalsPressed:(UIButton *)sender
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
