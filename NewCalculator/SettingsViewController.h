//
//  SettingsViewController.h
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-28.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController
- (IBAction)backPressed:(id)sender;
- (IBAction)buttonSpeechSwitched:(UISwitch *)sender;
- (IBAction)resultSpeechSwitched:(UISwitch *)sender;
- (IBAction)languageChanged:(UISegmentedControl *)sender;
- (IBAction)taxRateChanged:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *buttonSpeechSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *resultSpeechSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *LanguageControl;
@property (weak, nonatomic) IBOutlet UITextField *taxRateField;
@end
