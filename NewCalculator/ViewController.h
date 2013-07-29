//
//  ViewController.h
//  NewCalculator
//
//  Created by Olof Hellquist on 2013-07-01.
//  Copyright (c) 2013 Olof Hellquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UIButton *operatorButton;

- (IBAction)equalsPressed:(UIButton *)sender;
- (IBAction)settingsPressed;

- (IBAction)onePressed:(UIButton *)sender;
- (IBAction)twoPressed:(UIButton *)sender;
- (IBAction)threePressed:(UIButton *)sender;
- (IBAction)fourPressed:(UIButton *)sender;
- (IBAction)fivePressed:(UIButton *)sender;
- (IBAction)sixPressed:(UIButton *)sender;
- (IBAction)sevenPressed:(UIButton *)sender;
- (IBAction)eightPressed:(UIButton *)sender;
- (IBAction)ninePressed:(UIButton *)sender;
- (IBAction)zeroPressed:(UIButton *)sender;

- (IBAction)plusPressed:(UIButton *)sender;
- (IBAction)minusPressed:(UIButton *)sender;
- (IBAction)multiplyPressed:(UIButton *)sender;
- (IBAction)dividePressed:(UIButton *)sender;
@end
