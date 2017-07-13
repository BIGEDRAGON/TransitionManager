//
//  TransitionAnimatorCircleSpread.h
//  TransitionManager
//
//  Created by long on 2017/7/13.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator.h"

@interface TransitionAnimatorCircleSpread : TransitionAnimator

/**
 * 起始Point，当其x或者y有值时，就是触摸点圆形扩展；否则是屏幕中心圆形扩散
 */
@property (nonatomic, assign) CGPoint startPoint;

@end
