//
//  SettingsViewController.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-28.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize buttonSpeechSwitch = _buttonSpeechSwitch;
@synthesize resultSpeechSwitch = _resultSpeechSwitch;
@synthesize LanguageControl = _languageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttonSpeechSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"buttonSpeechActivated"];
    self.resultSpeechSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"resultSpeechActivated"];
    self.LanguageControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"Language"];
    
    UIImage *img = [UIImage imageNamed:@"leopardskin.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    [self.tableView setBackgroundView:imageView];
    
    self.buttonSpeechSwitch.onTintColor = [UIColor blackColor];
    self.resultSpeechSwitch.onTintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonSpeechSwitched:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"buttonSpeechActivated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)resultSpeechSwitched:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"resultSpeechActivated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)previousControllerIsTextual
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    ViewController *previousController = [viewControllers objectAtIndex:(viewControllers.count - 2)];
    return previousController.isAlpha == YES;
}

- (void)replaceStackWithCorrectLanguageCalculatorWithIndex:(int)index
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSMutableArray *vcnew = [[NSMutableArray alloc] initWithArray:viewControllers];
    
    UIViewController *settingsController = vcnew[(vcnew.count - 1)];
    [vcnew removeLastObject];
    [vcnew removeLastObject];
    
    NSString *viewControllerName = nil;
    if (index == 0) {
        viewControllerName = @"AlphabeticCalculatorSwe";
    } else {
        viewControllerName = @"AlphabeticCalculator";
    }
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerName];
    viewController.isAlpha = YES;
    
    [vcnew addObject:viewController];
    [vcnew addObject:settingsController];
    
    [self.navigationController setViewControllers:vcnew animated:NO];
}

- (IBAction)languageChanged:(UISegmentedControl *)sender {
    int selectedIndex = [sender selectedSegmentIndex];
    if (selectedIndex != 0 && selectedIndex != 1) {
        [NSException raise:nil format:@"Language button error"];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"Language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self previousControllerIsTextual]) {
        [self replaceStackWithCorrectLanguageCalculatorWithIndex:selectedIndex];
    }
}
@end
