//
//  UINavigationController+Transition.h
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Transition.h"

@interface UINavigationController (Transition)

- (void)lj_pushViewController:(UIViewController *)viewController animationType:(TransitionAnimationType)animationType;
- (void)lj_pushViewController:(UIViewController *)viewController transition:(TransitionBlock)transitionBlock;

@end
