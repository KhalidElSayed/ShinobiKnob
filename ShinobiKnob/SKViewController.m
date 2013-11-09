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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _knobControl = [[SKKnobControl alloc] initWithFrame:self.knobPlaceholder.bounds];
    [self.knobPlaceholder addSubview:_knobControl];
    
    /*
     Demonstrates Target-Action binding
     */
    [_knobControl addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    /*
     Demonstrates KVO
     */
    [_knobControl addObserver:self forKeyPath:@"value" options:0 context:NULL];
}

#pragma mark - Value changed methods
- (IBAction)handleValueChanged:(id)sender
{
    if (sender == _knobControl) {
        // Update the slider value to match the knob
        self.valueSlider.value = _knobControl.value;
    } else {
        // Update the knob to match the slider
        _knobControl.value = self.valueSlider.value;
    }
}

- (IBAction)handleButtonPressed:(id)sender
{
    // Generate random value
    CGFloat randomValue = (arc4random() % 101) / 100.f;
    // Then set it on the two controls
    [_knobControl setValue:randomValue animated:self.animateSwitch.on];
    [self.valueSlider setValue:randomValue animated:self.animateSwitch.on];
}

#pragma mark - KVO methods
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // Demos KVO binding with the knob control
    if(object == _knobControl && [keyPath isEqualToString:@"value"]) {
        // Update the value in the label
        self.valueLabel.text = [NSString stringWithFormat:@"%0.2f", _knobControl.value];
    }
}

@end
