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
    XCTAssertEqualWithAccuracy(_knobControl.value, 0.5, 1e-6, @"Value should be set correctly");
    [_knobControl setValue:0.75 animated:NO];
    XCTAssertEqualWithAccuracy(_knobControl.value, 0.75, 1e-6, @"Value should be set correctly");
}

- (void)test_valueShouldBeClippedToBounds
{
    _knobControl.maximumValue = 5;
    _knobControl.mininumValue = -5;
    
    _knobControl.value = -10;
    XCTAssertEqualWithAccuracy(_knobControl.value, -5.f, 1e-6, @"Value should be clipped at the min value");
    
    _knobControl.value = 10;
    XCTAssertEqualWithAccuracy(_knobControl.value, 5.f, 1e-6, @"Value should be clipped at the max value");
}

- (void)test_valueShouldBeClippedWhenNewExtremaProvided
{
    // Need to set the initial maximum
    _knobControl.maximumValue = 100;
    // Now let's set the value
    _knobControl.value = 10;
    
    // And change the max value
    _knobControl.maximumValue = 5;
    XCTAssertEqualWithAccuracy(_knobControl.value, 5.f, 1e-6, @"New max should clip the value");
    
    _knobControl.value = 0;
    _knobControl.mininumValue = 2;
    XCTAssertEqualWithAccuracy(_knobControl.value, 2.f, 1e-6, @"New min should clip the value");
}


@end
