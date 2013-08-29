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
        _annulusLayer = [CALayer layer];
        self.annulusLayer.delegate = self;
        // Adapt for retina scale
        self.annulusLayer.contentsScale = [UIScreen mainScreen].scale;
        
        _pointerLayer = [CALayer layer];
        self.pointerLayer.delegate = self;
        self.pointerLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)updateWithBounds:(CGRect)bounds
{
    _annulusLayer.bounds = bounds;
    _annulusLayer.position = CGPointMake(CGRectGetWidth(bounds)/2.f, CGRectGetHeight(bounds)/2.f);
    [_annulusLayer setNeedsDisplay];
    
    _pointerLayer.bounds = bounds;
    _pointerLayer.position = _annulusLayer.position;
    [_pointerLayer setNeedsDisplay];
}

#pragma mark - CALayer Delegate method
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(layer == self.annulusLayer) {
        [self drawAnnulusSegmentInContext:ctx];
    } else if (layer == self.pointerLayer) {
        [self drawPointerLayerInContext:ctx];
    }
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
        [self.annulusLayer setNeedsDisplay];
    }
}

- (void)setAnnulusLineWidth:(CGFloat)annulusLineWidth
{
    if(annulusLineWidth != _annulusLineWidth) {
        _annulusLineWidth = annulusLineWidth;
        [self.annulusLayer setNeedsDisplay];
        [self.pointerLayer setNeedsDisplay];
    }
}

- (void)setStartAngle:(CGFloat)startAngle
{
    if(startAngle != _startAngle) {
        _startAngle = startAngle;
        [self.annulusLayer setNeedsDisplay];
    }
}

- (void)setEndAngle:(CGFloat)endAngle
{
    if(endAngle != _endAngle) {
        _endAngle = endAngle;
        [self.annulusLayer setNeedsDisplay];
    }
}

- (void)setPointerColor:(UIColor *)pointerColor
{
    if (pointerColor != _pointerColor) {
        _pointerColor = pointerColor;
        [self.pointerLayer setNeedsDisplay];
    }
}

- (void)setPointerLength:(CGFloat)pointerLength
{
    if(pointerLength != _pointerLength) {
        _pointerLength = pointerLength;
        [self.pointerLayer setNeedsDisplay];
        [self.annulusLayer setNeedsDisplay];
    }
}

- (void)setPointerAngle:(CGFloat)pointerAngle
{
    if(pointerAngle != _pointerAngle) {
        _pointerAngle = pointerAngle;
        self.pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0, 0, 1);
    }
}

#pragma mark - Drawing Code
- (void)drawAnnulusSegmentInContext:(CGContextRef)layerContext
{
    CGContextSaveGState(layerContext);
    {
        CGPoint center = CGPointMake(CGRectGetWidth(self.annulusLayer.bounds)/2,
                                     CGRectGetHeight(self.annulusLayer.bounds)/2);
        CGFloat offset = MAX(self.pointerLength, self.annulusLineWidth / 2.f);
        CGFloat radius = MIN(CGRectGetHeight(self.annulusLayer.bounds),
                             CGRectGetWidth(self.annulusLayer.bounds)) / 2
                         - offset;
        UIBezierPath *ring = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:self.startAngle
                                                          endAngle:self.endAngle
                                                         clockwise:YES];
        
        // And now stroke the ring
        CGContextSaveGState(layerContext);
        CGContextSetShouldAntialias(layerContext, YES);
        CGContextSetStrokeColorWithColor(layerContext, self.annulusColor.CGColor);
        CGContextAddPath(layerContext, ring.CGPath);
        CGContextSetLineWidth(layerContext, self.annulusLineWidth);
        CGContextStrokePath(layerContext);
        CGContextRestoreGState(layerContext);
    }
    CGContextRestoreGState(layerContext);
}

- (void)drawPointerLayerInContext:(CGContextRef)layerContext
{
    CGContextSaveGState(layerContext);
    {
        UIBezierPath *pointer = [UIBezierPath bezierPath];
        [pointer moveToPoint:CGPointMake(CGRectGetWidth(self.pointerLayer.bounds) - self.pointerLength - self.annulusLineWidth/2.f,
                                         CGRectGetHeight(self.pointerLayer.bounds) / 2.f)];
        [pointer addLineToPoint:CGPointMake(CGRectGetWidth(self.pointerLayer.bounds),
                                            CGRectGetHeight(self.pointerLayer.bounds) / 2.f)];
        
        // Let's stroke it
        CGContextSaveGState(layerContext);
        CGContextSetShouldAntialias(layerContext, YES);
        CGContextSetStrokeColorWithColor(layerContext, self.pointerColor.CGColor);
        CGContextAddPath(layerContext, pointer.CGPath);
        CGContextSetLineWidth(layerContext, self.annulusLineWidth);
        CGContextStrokePath(layerContext);
        CGContextRestoreGState(layerContext);
    }
    CGContextRestoreGState(layerContext);
}

@end
