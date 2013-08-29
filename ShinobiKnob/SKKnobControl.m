//
//  SKKnobControl.m
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKKnobControl.h"
#import "SKAnnulusSegmentLayerRenderer.h"

@implementation SKKnobControl {
    SKAnnulusSegmentLayerRenderer *_annulusRenderer;
}

@dynamic lineWidth;
@dynamic startAngle;
@dynamic endAngle;
@dynamic pointerLength;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Create the renderer
        _annulusRenderer = [[SKAnnulusSegmentLayerRenderer alloc] init];
        self.startAngle = - M_PI * 11 / 8.f;
        self.endAngle   = M_PI * 3 / 8.f;
        self.lineWidth  = 2.f;
        self.pointerLength = 6.f;
        _annulusRenderer.pointerAngle = self.startAngle;
        _annulusRenderer.annulusColor = self.tintColor;
        _annulusRenderer.pointerColor = self.tintColor;
        
        // Setup defaults
        _mininumValue = 0.0;
        _maximumValue = 1.0;
        self.value = 0.0;
        
        // Create the
        [self createKnobImage];
    }
    return self;
}



#pragma mark - API Methods
- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    // Save the value to the backing ivar
    // Make sure we limit it to the requested bounds
    _value = [self clipToBounds:value];
    // Now let's update the knob with the correct angle
    CGFloat angleRange = self.endAngle - self.startAngle;
    CGFloat valueRange = self.maximumValue - self.mininumValue;
    CGFloat angleForValue = (value - self.mininumValue) / valueRange * angleRange + self.startAngle;
    [_annulusRenderer setPointerAngle:angleForValue animated:animated];
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

#pragma mark - Proxy methods for the _annulusRenderer
- (CGFloat)lineWidth
{
    return _annulusRenderer.annulusLineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _annulusRenderer.annulusLineWidth = lineWidth;
}

- (CGFloat)startAngle
{
    return _annulusRenderer.startAngle;
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _annulusRenderer.startAngle = startAngle;
}

- (CGFloat)endAngle
{
    return _annulusRenderer.endAngle;
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _annulusRenderer.endAngle = endAngle;
}

- (CGFloat)pointerLength
{
    return _annulusRenderer.pointerLength;
}

- (void)setPointerLength:(CGFloat)pointerLength
{
    _annulusRenderer.pointerLength = pointerLength;
}

#pragma mark - Layout methods
- (void)createKnobImage
{
    // Set the layer's size
    [_annulusRenderer updateWithBounds:self.bounds];
    
    // And add it to us
    if(_annulusRenderer.annulusLayer.superlayer) {
        [_annulusRenderer.annulusLayer removeFromSuperlayer];
    }
    [self.layer addSublayer:_annulusRenderer.annulusLayer];
    
    if(_annulusRenderer.pointerLayer.superlayer) {
        [_annulusRenderer.pointerLayer removeFromSuperlayer];
    }
    [self.layer addSublayer:_annulusRenderer.pointerLayer];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    // Need to update the annulus color
    _annulusRenderer.annulusColor = self.tintColor;
    _annulusRenderer.pointerColor = self.tintColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Do we need to update the size of the layer
    if(!CGSizeEqualToSize(_annulusRenderer.annulusLayer.bounds.size, self.bounds.size)) {
        [_annulusRenderer updateWithBounds:self.bounds];
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
