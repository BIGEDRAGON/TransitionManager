//
//  SwizzleMethodTool.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "SwizzleMethodTool.h"
#import <objc/runtime.h>

@implementation SwizzleMethodTool

void swizzleMethod(Class cls, SEL originalSEL, SEL swizzledSEL)
{
    //    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    //    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
    //    method_exchangeImplementations(swizzledMethod, originalMethod);
    
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    BOOL success = class_addMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
