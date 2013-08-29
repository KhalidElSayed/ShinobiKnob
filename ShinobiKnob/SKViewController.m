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
    _knobControl = [[SKKnobControl alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [self performSelector:@selector(changeValue) withObject:nil afterDelay:1];
    [self.view addSubview:_knobControl];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 200, 200, 20)];
    [self.view addSubview:slider];
}

- (void)changeValue
{
    [_knobControl setValue:0.5 animated:YES];
}

@end
