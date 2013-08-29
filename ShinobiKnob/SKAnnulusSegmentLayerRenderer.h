//
//  SKAnnulusLayerRenderer.h
//  ShinobiKnob
//
//  Created by Sam Davies on 29/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SKAnnulusSegmentLayerRenderer : NSObject

#pragma mark - Properties associated with the background annulus
@property (nonatomic, readonly, strong) CALayer *annulusLayer;
@property (nonatomic, strong) UIColor *annulusColor;
@property (nonatomic, assign) CGFloat annulusLineWidth;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

#pragma mark - Properties associated with the pointer element
@property (nonatomic, readonly, strong) CALayer *pointerLayer;
@property (nonatomic, strong) UIColor *pointerColor;
@property (nonatomic, assign) CGFloat pointerAngle;
@property (nonatomic, assign) CGFloat pointerLength;


#pragma mark - Animation Control Updates
- (void)setPointerAngle:(CGFloat)pointerAngle animated:(BOOL)animated;

- (void)updateWithBounds:(CGRect)bounds;

@end
