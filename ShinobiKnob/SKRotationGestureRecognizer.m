//
//  SKRotationGestureRecognizer.m
//  ShinobiKnob
//
//  Created by Sam Davies on 09/11/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SKRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation SKRotationGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.changeInAngle = 0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPoint = [touch locationInView:self.view];
    CGPoint previousTouchPoint = [touch previousLocationInView:self.view];
    CGPoint radialToCurrent = CGPointMake(currentTouchPoint.x - CGRectGetWidth(self.view.bounds)/2,
                                          currentTouchPoint.y - CGRectGetHeight(self.view.bounds)/2);
    CGPoint radialToPrevious = CGPointMake(previousTouchPoint.x - CGRectGetWidth(self.view.bounds)/2,
                                           previousTouchPoint.y - CGRectGetHeight(self.view.bounds)/2);
    // What's the cross product? Only have a component in the z direction:
    CGFloat cp_k = radialToCurrent.y * radialToPrevious.x - radialToCurrent.x * radialToPrevious.y;
    // Normalise
    cp_k /= sqrt(radialToCurrent.x * radialToCurrent.x + radialToCurrent.y * radialToCurrent.y);
    cp_k /= sqrt(radialToPrevious.x * radialToPrevious.x + radialToPrevious.y * radialToPrevious.y);
    self.changeInAngle = asin(cp_k);
    
    // Now we can do what we normally do
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.changeInAngle = 0;
}

@end
