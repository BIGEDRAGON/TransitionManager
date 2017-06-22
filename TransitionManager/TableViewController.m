//
//  systemTableViewController.m
//  TransitionManager
//
//  Created by long on 2017/6/16.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TableViewController.h"
#import "TransitionManager.h"
#import "NextViewController.h"

static NSString *identifier = @"SystemTableViewController";

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation TableViewController

- (UITableView *)myTableView
{
    if (!_myTableView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _myTableView;
}
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"Fade",
                      @"Push",@"Push",@"Push",@"Push",
                      @"Reveal",@"Reveal",@"Reveal",@"Reveal",
                      @"MoveIn",@"MoveIn",@"MoveIn",@"MoveIn",
                      @"Cube",@"Cube",@"Cube",@"Cube",
                      @"suckEffect",
                      @"oglFlip",@"oglFlip",@"oglFlip",@"oglFlip",
                      @"rippleEffect",
                      @"pageCurl",@"pageCurl",@"pageCurl",@"pageCurl",
                      @"pageUnCurl",@"pageUnCurl",@"pageUnCurl",@"pageUnCurl",
                      @"CameraIrisHollowOpen",
                      @"CameraIrisHollowClose"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _isSystem ? @"system" : @"custom";
    [self.view addSubview:self.myTableView];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _isPush ? @"push" : @"present";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isPush) {
        
        NextViewController *vc = [[NextViewController alloc] init];
        [self.navigationController lj_pushViewController:vc transition:^(TransitionProperty *property) {
            TransitionAnimationType animationType = _isSystem ? indexPath.row + 1 : indexPath.row + TransitionAnimationTypeDefault;
            property.animationType = animationType;
            property.backGestureType = BackGestureTypeLeft;
        }];
    }else {
        
        NextViewController *vc = [[NextViewController alloc] init];
        [self.navigationController lj_presentViewController:vc transition:^(TransitionProperty *property) {
            TransitionAnimationType animationType = _isSystem ? indexPath.row + 1 : indexPath.row + TransitionAnimationTypeDefault;
            property.animationType = animationType;
            property.backAnimationType = animationType;
            property.backGestureType = BackGestureTypeDown;
        } completion:^{
             self.title = @"present后变化标题";
         }];
    }
}

@end
