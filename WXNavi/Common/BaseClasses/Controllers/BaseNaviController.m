//
//  BaseNaviController.m
//  WXNavi
//
//  Created by Somiya on 06/06/2018.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "BaseNaviController.h"
#import "UINavigationController+StatusBarStyle.h"

@interface BaseNaviController ()<UINavigationControllerDelegate>

@end

@implementation BaseNaviController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark ---------------- Methods ----------------
- (NSArray<UIView *> *)allSubviews:(UIView *)view {
    NSMutableArray *subs = [view.subviews mutableCopy];
    if (subs.count == 0) {
        return [@[view] mutableCopy];
    } else {
        NSMutableArray *all = [NSMutableArray array];
        for (UIView *subview in subs) {
            [all addObjectsFromArray:[self allSubviews:subview]];
        }
        return all;
    }
}

#pragma mark ---------------- UINavigationControllerDelegate ----------------
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
