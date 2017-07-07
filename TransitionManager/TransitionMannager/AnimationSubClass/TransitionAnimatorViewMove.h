//
//  TransitionAnimatorViewMove.h
//  TransitionManager
//
//  Created by long on 2017/7/7.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator.h"

typedef NS_ENUM(NSUInteger, ViewMoveType) {
    ViewMoveTypeViewNormalMove = 0,
    ViewMoveTypeViewSpringMove,
};

@interface TransitionAnimatorViewMove : TransitionAnimator

/**
 * ViewMove的转场动画类型，默认ViewMoveTypeViewNormalMove
 */
@property (nonatomic, assign) ViewMoveType viewMoveType;

/**
 * 起始视图
 */
@property (nonatomic, strong) UIView *startView;
/**
 * 结束视图
 */
@property (nonatomic, strong) UIView *endView;

@end
