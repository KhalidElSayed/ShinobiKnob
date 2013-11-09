//
//  SKAnnulusLayerRenderer.m
//  ShinobiKnob
//
//  Created by Sam Davies on 29/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKAnnulusSegmentLayerRenderer.h"

@implementation SKAnnulusSegmentLayerRenderer

- (id)init
{
    self = [super init];
    if (self) {
        _annulusLayer = [CAShapeLayer layer];
        _annulusLayer.fillColor = [UIColor clearColor].CGColor;
        _pointerLayer = [CAShapeLayer layer];
        _pointerLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)updateWithBounds:(CGRect)bounds
{
    _annulusLayer.bounds = bounds;
    _annulusLayer.position = CGPointMake(CGRectGetWidth(bounds)/2.f, CGRectGetHeight(bounds)/2.f);
    [self updateAnnulusSegmentShape];
    
    _pointerLayer.bounds = bounds;
    _pointerLayer.position = _annulusLayer.position;
    [self updatePointerShape];
}

#pragma mark - Property overrides
/*
 We override some property setters to ensure that we trigger redrawing of the
 layers
 */
- (void)setAnnulusColor:(UIColor *)annulusColor
{
    if(annulusColor != _annulusColor) {
        _annulusColor = annulusColor;
        _annulusLayer.strokeColor = annulusColor.CGColor;
    }
}

- (void)setAnnulusLineWidth:(CGFloat)annulusLineWidth
{
    if(annulusLineWidth != _annulusLineWidth) {
        _annulusLineWidth = annulusLineWidth;
        _annulusLayer.lineWidth = annulusLineWidth;
        _pointerLayer.lineWidth = annulusLineWidth;
        [self updateAnnulusSegmentShape];
        [self updatePointerShape];
    }
}

- (void)setStartAngle:(CGFloat)startAngle
{
    if(startAngle != _startAngle) {
        _startAngle = startAngle;
        [self updateAnnulusSegmentShape];
    }
}

- (void)setEndAngle:(CGFloat)endAngle
{
    if(endAngle != _endAngle) {
        _endAngle = endAngle;
        [self updateAnnulusSegmentShape];
    }
}

- (void)setPointerColor:(UIColor *)pointerColor
{
    if (pointerColor != _pointerColor) {
        _pointerColor = pointerColor;
        _pointerLayer.strokeColor = pointerColor.CGColor;
    }
}

- (void)setPointerLength:(CGFloat)pointerLength
{
    if(pointerLength != _pointerLength) {
        _pointerLength = pointerLength;
        [self updateAnnulusSegmentShape];
        [self updatePointerShape];
    }
}

- (void)setPointerAngle:(CGFloat)pointerAngle
{
    [self setPointerAngle:pointerAngle animated:NO];
}

- (void)setPointerAngle:(CGFloat)pointerAngle animated:(BOOL)animated
{
    if(pointerAngle != _pointerAngle) {
        
        [CATransaction begin];
        // Disable implicit animations
        [CATransaction setDisableActions:YES];
        self.pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0, 0, 1);
        if(animated) {
            // Key-frame animation to ensure rotates in correct direction
            CGFloat midAngle = (MAX(pointerAngle, _pointerAngle) -
                                MIN(pointerAngle, _pointerAngle) ) / 2.f +
                                MIN(pointerAngle, _pointerAngle);
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.duration = 3.f;
            animation.values = @[@(_pointerAngle), @(midAngle), @(pointerAngle)];
            animation.keyTimes = @[@(0), @(0.5), @(1.0)];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.pointerLayer addAnimation:animation forKey:nil];
        }
        [CATransaction commit];
        _pointerAngle = pointerAngle;
    }
}

#pragma mark - Utility methods
- (BOOL)pointerHitTest:(CGPoint)touchPoint
{
    CGPoint pointerLocation = [self positionOfCurrentValue];
    // Let's make a box around it
    CGRect boundingBox = CGRectMake(pointerLocation.x - 22, pointerLocation.y - 22,
                                    44, 44);
    return CGRectContainsPoint(boundingBox, touchPoint);
}

- (CGPoint)positionOfCurrentValue
{
    CGFloat radius = MIN(CGRectGetHeight(self.annulusLayer.bounds),
                         CGRectGetWidth(self.annulusLayer.bounds)) / 2;
    CGPoint pointerLocation = CGPointMake(radius + radius * cos(self.pointerAngle),
                                          radius + radius * sin(self.pointerAngle));
    return pointerLocation;
}

#pragma mark - Drawing Methods
- (void)updateAnnulusSegmentShape
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.annulusLayer.bounds)/2,
                                 CGRectGetHeight(self.annulusLayer.bounds)/2);
    CGFloat offset = MAX(self.pointerLength, self.annulusLineWidth / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(self.annulusLayer.bounds),
                         CGRectGetWidth(self.annulusLayer.bounds)) / 2 - offset;
    UIBezierPath *ring = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:self.startAngle
                                                      endAngle:self.endAngle
                                                     clockwise:YES];
    _annulusLayer.path = [ring CGPath];
}

- (void)updatePointerShape
{
    UIBezierPath *pointer = [UIBezierPath bezierPath];
    [pointer moveToPoint:CGPointMake(CGRectGetWidth(self.pointerLayer.bounds) - self.pointerLength - self.annulusLineWidth/2.f,
                                     CGRectGetHeight(self.pointerLayer.bounds) / 2.f)];
    [pointer addLineToPoint:CGPointMake(CGRectGetWidth(self.pointerLayer.bounds),
                                        CGRectGetHeight(self.pointerLayer.bounds) / 2.f)];
    _pointerLayer.path = [pointer CGPath];
}

@end
