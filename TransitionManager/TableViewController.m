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
#import "PartViewViewController.h"

static NSString *identifier = @"SystemTableViewController";

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *systemArr;
@property (nonatomic, strong) NSArray *customArr;
@property (nonatomic, strong) NSArray *subclassArr;
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
- (NSArray *)systemArr
{
    if (!_systemArr) {
        _systemArr = @[@"Fade",
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
    return _systemArr;
}

- (NSArray *)customArr
{
    if (!_customArr) {
        _customArr = @[@"PageToLeft",@"PageToRight",@"PageToTop",@"PageToBottom",
                       @"NormalOpenPortalVertical",@"NormalOpenPortalHorizontal",
                       @"NormalClosePortalVertical",@"NormalClosePortalHorizontal",
                       @"SolidOpenPortalVertical",@"SolidOpenPortalHorizontal",
                       @"SolidClosePortalVertical",@"SolidClosePortalHorizontal",
                       @"RotationPresentLeft",@"RotationPresentRight"
                       ];
    }
    return _customArr;
}

- (NSArray *)subclassArr
{
    if (!_subclassArr) {
        _subclassArr = @[@"ViewNormalMove",@"ViewSpringMove",
                         ];
    }
    return _subclassArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_type) {
        case TypeSystem:
            self.title = @"system";
            break;
        case TypeCustom_category:
            self.title = @"custom(category)";
            break;
        case TypeCustom_subClass:
            self.title = @"custom(subClass)";
            break;
    }
    
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
    switch (_type) {
        case TypeSystem:
            return self.systemArr.count;
            break;
        case TypeCustom_category:
            return self.customArr.count;
            break;
        case TypeCustom_subClass:
            return self.subclassArr.count;
            break;
    }
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
    
    NSArray *tempArr;
    switch (_type) {
        case TypeSystem:
            tempArr = _systemArr;
            break;
        case TypeCustom_category:
            tempArr = _customArr;
            break;
        case TypeCustom_subClass:
            tempArr = _subclassArr;
            break;
    }
    NSString *str = tempArr[indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NextViewController *vc = [[NextViewController alloc] init];
    
    if (_type == TypeCustom_subClass) {
        if (indexPath.row <= 1) {
            PartViewViewController *vc = [[PartViewViewController alloc] init];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            vc.titleStr = cell.textLabel.text;
            vc.isPush = _isPush;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    if (_isPush) {
        
        [self.navigationController lj_pushViewController:vc transition:^(TransitionProperty *property) {
            TransitionAnimationType animationType = _type == TypeSystem ? indexPath.row + 1 : indexPath.row + TransitionAnimationTypeDefault + 1;
            property.animationType = animationType;
            property.backGestureType = BackGestureTypeLeft | BackGestureTypeRight;
        }];
    }else {
        
        [self.navigationController lj_presentViewController:vc transition:^(TransitionProperty *property) {
            TransitionAnimationType animationType = _type == TypeSystem ? indexPath.row + 1 : indexPath.row + TransitionAnimationTypeDefault + 1;
            property.animationType = animationType;
            property.backAnimationType = animationType;
            property.backGestureType = BackGestureTypeDown;
        } completion:^{
             self.title = @"present后变化标题";
         }];
    }
}


//- (id)customSubClassAnimatorRow:(NSInteger)row
//{
//    id animator = nil;
//    switch (row) {
//        case 2:
//        case 3:{
//            TransitionAnimatorRotationPresent *rotation = [[TransitionAnimatorRotationPresent alloc] init];
//            rotation.direction = row-2;
//            return rotation;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return animator;
//}

@end
