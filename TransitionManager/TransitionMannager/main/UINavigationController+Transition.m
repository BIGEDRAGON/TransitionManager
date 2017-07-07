//
//  UINavigationController+Transition.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import "SwizzleMethodTool.h"
#import <objc/runtime.h>

static NSString * const customDelegateKey = @"customDelegate";

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
    CustomDelegate *customDelegate = objc_getAssociatedObject(self.viewControllers.lastObject, &customDelegateKey);
    if (customDelegate.isCustomBackAnimation) {
        self.delegate = customDelegate;
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
    objc_setAssociatedObject(viewController, &customDelegateKey, [[CustomDelegate alloc] init], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CustomDelegate *customDelegate = objc_getAssociatedObject(viewController, &customDelegateKey);
    
    if (customDelegate) {
        customDelegate.transitionBlcok = transitionBlock;
        self.delegate = customDelegate;
    }
    
    [self pushViewController:viewController animated:YES];
}


@end


