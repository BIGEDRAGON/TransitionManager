//
//  UINavigationController+Transition.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import "SwizzleMethodTool.h"

@implementation UINavigationController (Transition)

#pragma mark - Hook
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        swizzleMethod(self.class,
                      @selector(popViewControllerAnimated:),
                      @selector(lj_popViewControllerAnimated:));
    });
}


#pragma mark - Swizzle Method
- (UIViewController *)lj_popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.lastObject.customDelegate.isCustomBackAnimation) {
        self.delegate = self.viewControllers.lastObject.customDelegate;
    }
    return [self lj_popViewControllerAnimated:animated];
}


#pragma mark - Method
- (void)lj_pushViewController:(UIViewController *)viewController animationType:(TransitionAnimationType)animationType
{
    [self lj_pushViewController:viewController transition:^(TransitionProperty *transition) {
        transition.animationType = animationType;
    }];
}

- (void)lj_pushViewController:(UIViewController *)viewController transition:(TransitionBlock)transitionBlock
{
    viewController.customDelegate = [[CustomDelegate alloc] init];
    viewController.customDelegate.transitionBlcok = transitionBlock;
    self.delegate = viewController.customDelegate;
    
    [self pushViewController:viewController animated:YES];
}


@end


