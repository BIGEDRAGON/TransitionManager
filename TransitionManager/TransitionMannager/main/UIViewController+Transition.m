//
//  UIViewController+Transition.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "UIViewController+Transition.h"
#import "SwizzleMethodTool.h"
#import "TransitionAnimator.h"
#import <objc/runtime.h>

static NSString * const customDelegateKey = @"customDelegate";

@implementation UIViewController (Transition)

#pragma mark - Hook
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        swizzleMethod(self.class,
                      @selector(dismissViewControllerAnimated:completion:),
                      @selector(lj_dismissViewControllerAnimated:completion:));
        
        swizzleMethod(self.class,
                      @selector(viewDidAppear:),
                      @selector(lj_viewDidAppear:));
        
        swizzleMethod(self.class,
                      @selector(viewWillDisappear:),
                      @selector(lj_viewWillDisappear:));
    });
}


#pragma mark - Swizzle Method
- (void)lj_dismissViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    CustomDelegate *customDelegate = objc_getAssociatedObject(self, &customDelegateKey);
    if (customDelegate.isCustomBackAnimation) {
        self.transitioningDelegate = customDelegate;
    }
    [self lj_dismissViewControllerAnimated:animated completion:completion];
}
- (void)lj_viewDidAppear:(BOOL)animated {
    [self lj_viewDidAppear:animated];
    
    CustomDelegate *customDelegate = objc_getAssociatedObject(self, &customDelegateKey);
    if (customDelegate.backGestureEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)lj_viewWillDisappear:(BOOL)animated {
    [self lj_viewWillDisappear:animated];
    
    CustomDelegate *customDelegate = objc_getAssociatedObject(self, &customDelegateKey);
    if (customDelegate.backGestureEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - Method
- (void)lj_presentViewController:(UIViewController *)viewController animationType:(TransitionAnimationType)animationType completion:(void (^)(void))completion
{
    [self lj_presentViewController:viewController transition:^(TransitionProperty *property) {
        property.animationType = animationType;
    } completion:completion];
}
- (void)lj_presentViewController:(UIViewController *)viewController transition:(TransitionBlock)transitionBlock completion:(void (^)(void))completion
{
    objc_setAssociatedObject(viewController, &customDelegateKey, [[CustomDelegate alloc] init], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CustomDelegate *customDelegate = objc_getAssociatedObject(viewController, &customDelegateKey);
    
    if (customDelegate) {
        customDelegate.transitionBlcok = transitionBlock;
        viewController.transitioningDelegate = customDelegate;
    }
    
    [self presentViewController:viewController animated:YES completion:completion];
}



@end


