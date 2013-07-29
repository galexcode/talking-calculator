//
//  SettingsViewController.m
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-28.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import "SettingsViewController.h"

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

- (IBAction)languageChanged:(UISegmentedControl *)sender {
    int selectedIndex = [sender selectedSegmentIndex];
    if (selectedIndex != 0 && selectedIndex != 1) {
        [NSException raise:nil format:@"Language button error"];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"Language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
