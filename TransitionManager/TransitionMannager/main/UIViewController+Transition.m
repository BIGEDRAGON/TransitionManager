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

- (void)setCustomDelegate:(CustomDelegate *)customDelegate
{
    objc_setAssociatedObject(self, &customDelegateKey, customDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CustomDelegate *)customDelegate
{
    return objc_getAssociatedObject(self, &customDelegateKey);
}

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
    if (self.customDelegate.isCustomBackAnimation) {
        self.transitioningDelegate = self.customDelegate;
    }
    [self lj_dismissViewControllerAnimated:animated completion:completion];
}
- (void)lj_viewDidAppear:(BOOL)animated {
    [self lj_viewDidAppear:animated];
    if (self.customDelegate.backGestureEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)lj_viewWillDisappear:(BOOL)animated {
    [self lj_viewWillDisappear:animated];
    if (self.customDelegate.backGestureEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - Method
- (void)lj_presentViewController:(UIViewController *_Nullable)vc animationType:(TransitionAnimationType)animationType completion:(void (^ __nullable)(void))completion
{
    [self lj_presentViewController:vc transition:^(TransitionProperty *property) {
        property.animationType = animationType;
    } completion:completion];
}
- (void)lj_presentViewController:(UIViewController *_Nullable)vc transition:(TransitionBlock _Nullable)transitionBlock completion:(void (^ __nullable)(void))completion
{
    self.customDelegate = [[CustomDelegate alloc] init];
    self.customDelegate.transitionBlcok = transitionBlock;
    vc.transitioningDelegate = self.customDelegate;
    
    [self presentViewController:vc animated:YES completion:completion];
}



@end


