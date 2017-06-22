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

@property (nonatomic, strong) CustomDelegate * _Nullable customDelegate;

- (void)lj_presentViewController:(UIViewController *_Nullable)vc animationType:(TransitionAnimationType)animationType completion:(void (^ __nullable)(void))completion;
- (void)lj_presentViewController:(UIViewController *_Nullable)vc transition:(TransitionBlock _Nullable)transitionBlock completion:(void (^ __nullable)(void))completion;

@end

