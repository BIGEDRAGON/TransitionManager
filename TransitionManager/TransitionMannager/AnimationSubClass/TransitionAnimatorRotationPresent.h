//
//  TransitionAnimatorRotationPresent.h
//  TransitionManager
//
//  Created by long on 2017/7/10.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator.h"

typedef NS_ENUM(NSUInteger, RotationPresentDirection) {
    RotationPresentDirectionFromLeft = 0,
    RotationPresentDirectionFromRight,
};

@interface TransitionAnimatorRotationPresent : TransitionAnimator

/**
 * ViewMove的转场动画类型，默认ViewMoveTypeViewNormalMove
 */
@property (nonatomic, assign) RotationPresentDirection direction;

@end
