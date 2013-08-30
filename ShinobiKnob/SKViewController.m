//
//  SKViewController.m
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKViewController.h"
#import "SKKnobControl.h"

@implementation SKViewController {
    SKKnobControl *_knobControl;
    UISlider *_slider;
    UILabel *_valueLabel;
    UISwitch *_animateSwitch;
    UIButton *_changeValueButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _knobControl = [[SKKnobControl alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [self.view addSubview:_knobControl];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 200, 200, 20)];
    [self.view addSubview:_slider];
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 100, 100)];
    _valueLabel.text = @"0.00";
    _valueLabel.font = [UIFont systemFontOfSize:50];
    [self.view addSubview:_valueLabel];
    
    _animateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, 250, 50, 20)];
    [self.view addSubview:_animateSwitch];
    
    _changeValueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_changeValueButton setTitle:@"Random Value" forState:UIControlStateNormal];
    [_changeValueButton sizeToFit];
    _changeValueButton.center = CGPointMake(180, _animateSwitch.center.y);
    [_changeValueButton addTarget:self action:@selector(handleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeValueButton];
    
    /*
     Demonstrates Target-Action binding
     */
    [_slider addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_knobControl addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    /*
     Demonstrates KVO
     */
    [_knobControl addObserver:self forKeyPath:@"value" options:0 context:NULL];
}

#pragma mark - Value changed methods
- (void)handleValueChanged:(id)sender
{
    if (sender == _knobControl) {
        // Update the slider value to match the knob
        _slider.value = _knobControl.value;
    } else {
        // Update the knob to match the slider
        _knobControl.value = _slider.value;
    }
}

- (void)handleButtonPressed:(id)sender
{
    // Generate random value
    CGFloat randomValue = (arc4random() % 101) / 100.f;
    // Then set it on the two controls
    [_knobControl setValue:randomValue animated:_animateSwitch.on];
    [_slider setValue:randomValue animated:_animateSwitch.on];
}

#pragma mark - KVO methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Demos KVO binding with the knob control
    if(object == _knobControl && [keyPath isEqualToString:@"value"]) {
        // Update the value in the label
        _valueLabel.text = [NSString stringWithFormat:@"%0.2f", _knobControl.value];
    }
}

@end
