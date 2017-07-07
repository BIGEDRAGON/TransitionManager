//
//  TransitionAnimation+SystemType.h
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator.h"

@interface TransitionAnimator (SystemType)

- (CATransition *)getSystemTransition;
- (CATransition *)getSystemBackTransition;

- (CATransition *)getSystemTransitionFromAnimationType:(TransitionAnimationType)animationType;

@end
