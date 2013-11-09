//
//  SKViewController.h
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;

- (IBAction)handleButtonPressed:(id)sender;
- (IBAction)handleValueChanged:(id)sender;

@end
