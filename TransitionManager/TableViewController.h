//
//  systemTableViewController.h
//  TransitionManager
//
//  Created by long on 2017/6/16.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, type) {
    TypeSystem,
    TypeCustom_category,
    TypeCustom_subClass,
};

@interface TableViewController : UIViewController
@property (nonatomic, assign) type type;
@property (nonatomic, assign) BOOL isPush;
@end
