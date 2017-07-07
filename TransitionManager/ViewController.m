//
//  ViewController.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)systemPushClick:(id)sender {
    
    TableViewController *systemVC = [[TableViewController alloc] init];
    systemVC.isPush = YES;
    systemVC.type = TypeSystem;
    [self.navigationController pushViewController:systemVC animated:YES];
}
- (IBAction)systemPresentClick:(id)sender {
    
    TableViewController *systemVC = [[TableViewController alloc] init];
    systemVC.isPush = NO;
    systemVC.type = TypeSystem;
    [self.navigationController pushViewController:systemVC animated:YES];
}

- (IBAction)customPushClick:(id)sender {
    
    TableViewController *customVC = [[TableViewController alloc] init];
    customVC.isPush = YES;
    customVC.type = TypeCustom_category;
    [self.navigationController pushViewController:customVC animated:YES];
}
- (IBAction)customPresentClick:(id)sender {
    
    TableViewController *customVC = [[TableViewController alloc] init];
    customVC.isPush = NO;
    customVC.type = TypeCustom_category;
    [self.navigationController pushViewController:customVC animated:YES];
}

- (IBAction)customSubClassPush:(id)sender {
    TableViewController *customVC = [[TableViewController alloc] init];
    customVC.isPush = YES;
    customVC.type = TypeCustom_subClass;
    [self.navigationController pushViewController:customVC animated:YES];
}
- (IBAction)customSubClassPresent:(id)sender {
    TableViewController *customVC = [[TableViewController alloc] init];
    customVC.isPush = NO;
    customVC.type = TypeCustom_subClass;
    [self.navigationController pushViewController:customVC animated:YES];
}


@end
