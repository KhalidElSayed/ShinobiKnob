//
//  ShinobiKnobTests.m
//  ShinobiKnobTests
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "ShinobiKnobTests.h"
#import "SKKnobControl.h"

@implementation ShinobiKnobTests {
    SKKnobControl *_knobControl;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _knobControl = [[SKKnobControl alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_setValueAnimated_setsValueCorrectly
{
    [_knobControl setValue:0.5 animated:YES];
    STAssertEquals(_knobControl.value, 0.5, @"Value should be set correctly");
    [_knobControl setValue:0.75 animated:NO];
    STAssertEquals(_knobControl.value, 0.75, @"Value should be set correctly");
}

- (void)test_valueShouldBeClippedToBounds
{
    _knobControl.maximumValue = 5;
    _knobControl.mininumValue = -5;
    
    _knobControl.value = -10;
    STAssertEquals(_knobControl.value, -5.f, @"Value should be clipped at the min value");
    
    _knobControl.value = 10;
    STAssertEquals(_knobControl.value, 5.f, @"Value should be clipped at the max value");
}

- (void)test_valueShouldBeClippedWhenNewExtremaProvided
{
    _knobControl.value = 10;
    
    _knobControl.maximumValue = 5;
    STAssertEquals(_knobControl.value, 5.f, @"New max should clip the value");
    
    _knobControl.value = 0;
    _knobControl.mininumValue = 2;
    STAssertEquals(_knobControl.value, 2.f, @"New min should clip the value");
}


@end
