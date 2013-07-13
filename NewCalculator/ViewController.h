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

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operatorPressed:(UIButton *)sender;
- (IBAction)equalsPressed:(UIButton *)sender;

@end
