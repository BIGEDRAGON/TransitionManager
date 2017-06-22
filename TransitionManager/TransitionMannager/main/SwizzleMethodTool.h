//
//  SwizzleMethodTool.h
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwizzleMethodTool : NSObject

void swizzleMethod(Class cls, SEL originalSEL, SEL swizzledSEL);

@end
