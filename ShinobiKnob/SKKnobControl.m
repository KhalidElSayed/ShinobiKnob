//
//  SKKnobControl.m
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKKnobControl.h"
#import "SKAnnulusSegmentLayerRenderer.h"
#import "SKRotationGestureRecognizer.h"

@interface SKKnobControl () <UIGestureRecognizerDelegate> {
    SKAnnulusSegmentLayerRenderer *_annulusRenderer;
    SKRotationGestureRecognizer *_gestureRecognizer;
}
@end

@implementation SKKnobControl

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
        _minimumValue = 0.0;
        _maximumValue = 1.0;
        _continuous = YES;
        self.value = 0.0;
        
        // Create the UI
        [self createKnobImage];
        
        // Create the gesture recognizer
        _gestureRecognizer = [[SKRotationGestureRecognizer alloc] initWithTarget:self action:@selector(knobDidPan:)];
        _gestureRecognizer.delegate = self;
        [self addGestureRecognizer:_gestureRecognizer];
    }
    return self;
}



#pragma mark - API Methods
- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    if(value != _value) {
        // Send KVO notification
        [self willChangeValueForKey:@"value"];
        // Save the value to the backing ivar
        // Make sure we limit it to the requested bounds
        _value = [self clipToBounds:value];
        // Now let's update the knob with the correct angle
        CGFloat angleRange = self.endAngle - self.startAngle;
        CGFloat valueRange = self.maximumValue - self.minimumValue;
        CGFloat angleForValue = (_value - self.minimumValue) / valueRange * angleRange + self.startAngle;
        [_annulusRenderer setPointerAngle:angleForValue animated:animated];
        [self didChangeValueForKey:@"value"];
    }
}

#pragma mark - Property overrides
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

- (void)setMinimumValue:(CGFloat)mininumValue
{
    _minimumValue = mininumValue;
    // Need to check the bounds of the value
    if(self.value < mininumValue) {
        self.value = self.minimumValue;
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

#pragma mark - Handle gestures
- (void)knobDidPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == _gestureRecognizer) {
        if(_gestureRecognizer.state == UIGestureRecognizerStateChanged) {            
            // Convert to a change in value
            CGFloat changeInValue = _gestureRecognizer.changeInAngle /
                                    (self.endAngle - self.startAngle) *
                                    (self.maximumValue - self.minimumValue);
            self.value += changeInValue;
            
            // Notify of value change
            if (self.continuous) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        } else if(_gestureRecognizer.state == UIGestureRecognizerStateEnded
                  || _gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [_annulusRenderer pointerHitTest:[touch locationInView:self]];
}


#pragma mark - Utility methods

- (CGFloat)clipToBounds:(CGFloat)value
{
    value = MIN(value, self.maximumValue);
    value = MAX(value, self.minimumValue);
    return value;
}

#pragma mark - Advanced KVO
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    // We'll handle KVO notifications for the value property ourselves, since
    // we're proxying with the setValue:animated: method.
    if ([key isEqualToString:@"value"]) {
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

@end
