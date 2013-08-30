//
//  SKKnobControl.m
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKKnobControl.h"
#import "SKAnnulusSegmentLayerRenderer.h"

@interface SKKnobControl () <UIGestureRecognizerDelegate> {
    SKAnnulusSegmentLayerRenderer *_annulusRenderer;
    UIPanGestureRecognizer *_gestureRecognizer;
    CGPoint lastTouchPoint;
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
        _mininumValue = 0.0;
        _maximumValue = 1.0;
        _continuous = YES;
        self.value = 0.0;
        
        // Create the UI
        [self createKnobImage];
        
        // Create the gesture recognizer
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(knobDidPan:)];
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
        CGFloat valueRange = self.maximumValue - self.mininumValue;
        CGFloat angleForValue = (value - self.mininumValue) / valueRange * angleRange + self.startAngle;
        [_annulusRenderer setPointerAngle:angleForValue animated:animated];
        [self didChangeValueForKey:@"value"];
    }
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

#pragma mark - Handle gestures
- (void)knobDidPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == _gestureRecognizer) {
        if(_gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            lastTouchPoint = [_gestureRecognizer locationInView:self];
        } else {
            CGPoint currentTouchPoint = [_gestureRecognizer locationInView:self];
            CGPoint radialToCurrent = CGPointMake(currentTouchPoint.x - CGRectGetWidth(self.bounds)/2,
                                                  currentTouchPoint.y - CGRectGetHeight(self.bounds)/2);
            CGPoint radialToPrevious = CGPointMake(lastTouchPoint.x - CGRectGetWidth(self.bounds)/2,
                                                  lastTouchPoint.y - CGRectGetHeight(self.bounds)/2);
            // What's the cross product? Only have a component in the z direction:
            CGFloat cp_k = radialToCurrent.y * radialToPrevious.x - radialToCurrent.x * radialToPrevious.y;
            // Normalise
            cp_k /= sqrt(radialToCurrent.x * radialToCurrent.x + radialToCurrent.y * radialToCurrent.y);
            cp_k /= sqrt(radialToPrevious.x * radialToPrevious.x + radialToPrevious.y * radialToPrevious.y);
            CGFloat changeInAngle = asin(cp_k);
            
            // Convert to a change in value
            CGFloat changeInValue = changeInAngle / (self.endAngle - self.startAngle) * (self.maximumValue - self.mininumValue);
            self.value += changeInValue;
            lastTouchPoint = currentTouchPoint;
            
            // Notify of value change
            if (self.continuous) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            } else {
                // Only send an update if the gesture has completed
                if(_gestureRecognizer.state == UIGestureRecognizerStateEnded
                   || _gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
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
    value = MAX(value, self.mininumValue);
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
