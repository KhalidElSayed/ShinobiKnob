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
    [self.view addSubview:_knobControl];
}

@end
