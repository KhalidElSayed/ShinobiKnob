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

@property (nonatomic, strong) UIColor *annulusColor;
@property (nonatomic, assign) CGFloat annulusLineWidth;
@property (nonatomic, readonly, strong) CALayer *annulusLayer;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

- (void)updateWithBounds:(CGRect)bounds;

@end
