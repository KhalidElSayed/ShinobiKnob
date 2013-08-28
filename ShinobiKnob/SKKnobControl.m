//
//  SKKnobControl.m
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKKnobControl.h"

@implementation SKKnobControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        // Setup defaults
        _value = 0.0;
        _mininumValue = 0.0;
        _maximumValue = 1.0;
    }
    return self;
}



#pragma mark - API Methods
- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    // Save the value to the backing ivar
    // Make sure we limit it to the requested bounds
    _value = [self clipToBounds:value];
}

- (void)setValue:(CGFloat)value
{
    // Chain with the animation method version
    [self setValue:value animated:NO];
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
    // Need to check the bounds of the value
    if(self.value > maximumValue) {
        self.value = self.maximumValue;
    }
}

- (void)setMininumValue:(CGFloat)mininumValue
{
    _mininumValue = mininumValue;
    // Need to check the bounds of the value
    if(self.value < mininumValue) {
        self.value = self.mininumValue;
    }
}


#pragma mark - Utility methods

- (CGFloat)clipToBounds:(CGFloat)value
{
    value = MIN(value, self.maximumValue);
    value = MAX(value, self.mininumValue);
    return value;
}


@end
