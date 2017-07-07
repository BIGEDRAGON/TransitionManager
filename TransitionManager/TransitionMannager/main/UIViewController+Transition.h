//
//  UIViewController+Transition.h
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionProperty.h"
#import "CustomDelegate.h"

@interface UIViewController (Transition)

- (void)lj_presentViewController:(UIViewController *)viewController animationType:(TransitionAnimationType)animationType completion:(void (^)(void))completion;
- (void)lj_presentViewController:(UIViewController *)viewController transition:(TransitionBlock)transitionBlock completion:(void (^)(void))completion;

@end

