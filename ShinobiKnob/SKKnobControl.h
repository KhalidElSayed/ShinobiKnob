//
//  SKKnobControl.h
//  ShinobiKnob
//
//  Created by Sam Davies on 28/08/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKKnobControl : UIControl

#pragma mark - Knob value
/**
 @name Knob Value
 */

/**
 Contains the current value
 
 Setting this value will redraw the knob with the correct specified value. To
 animate to the new value use `setValue:animated:` method instead.
 
 If you set the value outside of the allowed range then it will be clipped to
 the appropriate extremum.
 */
@property (nonatomic, assign) CGFloat value;


/**
 Sets the value the knob should represented, with optional animation of the change.
 
 @param value The new value assigned to the `value` property.
 @param animated Specifyn `YES` to animate the change to the new value. Animations
 are performed asynchronously and do not block the calling thread.
 */
- (void)setValue:(CGFloat)value animated:(BOOL)animated;


#pragma mark - Value Limits
/**
 @name Value limits
 */
/**
 The minimum value of the knob
 
 Changing this property will clip the current value if it is below the new
 minimum. Defaults to 0.
 */
@property (nonatomic, assign) CGFloat mininumValue;

/**
 The maximum value of the knob
 
 Changing this property will clip the current value if it is above the new
 maximum. Defaults to 1.
 */
@property (nonatomic, assign) CGFloat maximumValue;


#pragma mark - Knob Behavior
/**
 @name Knob Behavior
 */

/**
 Contains a Boolean value indicating whether changes in the value of the knob
 generate continuous update events.
 
 If `YES`, the knob sends update events continuously to the associated target's
 action method. If `NO`, the slider only sends an action event when the user
 releases the touch to set the final value.
 
 The default value is `YES`.
 */
@property (nonatomic, assign, getter = isContinuous) BOOL continuous;


#pragma mark - Knob Appearance
/**
 @name Knob Appearance
 */
/**
 Specifies the angle of the start of the knob control track
 
 Defaults to -11π/8
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 Specifies the end angle of the knob control track
 
 Defaults to 3π/8
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 Specifies the width in points of the knob control track
 
 Defaults to 2.0
 */
@property (nonatomic, assign) CGFloat lineWidth;

@end
