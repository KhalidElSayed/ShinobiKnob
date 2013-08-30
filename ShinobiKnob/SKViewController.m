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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _knobControl = [[SKKnobControl alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [_knobControl addTarget:self action:@selector(knobValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_knobControl];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 200, 200, 20)];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

- (void)knobValueChanged:(id)sender
{
    // Update the slider value to match the knob
    _slider.value = _knobControl.value;
}

- (void)sliderValueChanged:(id)sender
{
    // Update the knob to match the slider
    _knobControl.value = _slider.value;
}

@end
