//
//  DiscoverViewController.m
//  WXNavi
//
//  Created by Somiya on 06/06/2018.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FriendsViewController.h"
#import <objc/runtime.h>

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;



//    unsigned int count = 0;
//    unsigned int count1 = 0;
//    objc_property_t *properties = class_copyPropertyList(NSClassFromString(@"UINavigationBar"), &count1);
//    Ivar *vars = class_copyIvarList(NSClassFromString(@"UINavigationBar"), &count);
//    for (int i = 0; i < count; i++) {
//        Ivar var = vars[i];
//        NSString *name = [NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding];
//        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(var) encoding:NSUTF8StringEncoding];
//        NSLog(@"Name >>>>> %@ ===== Type >>>>> %@", name, type);
//    }
//    
//    for (int i = 0; i < count1; i++) {
//        objc_property_t property = properties[i];
//        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        NSString *attr = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//    
//        NSLog(@"Property Name >>>>> %@ ===== Attribute >>>>> %@", name, attr);
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]}];
}

- (void)doSomething {
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        
        if ([subview isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            CGRect frame = subview.frame;
            NSLog(@"%f", frame.origin.y);
            CGRect frame1 = (CGRect) {{frame.origin.x, frame.origin.y + 20}, frame.size};
            NSLog(@"%f", frame1.origin.y);
            subview.frame = frame1;
//            [UIView animateWithDuration:2 animations:^{
//                CGRect frame1 = (CGRect) {{frame.origin.x, frame.origin.y + 20}, frame.size};
//                subview.frame = frame1;
//            } completion:nil];
            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = @"朋友圈";
    UIImage *image = [[UIImage imageNamed:@"span.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    cell.imageView.image = image;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"span.png"]];
    imageView.frame = (CGRect) {{20, 5}, {34, 34}};
    [cell.contentView addSubview:imageView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 1) {
        [self doSomething];
        return;
    }
    FriendsViewController *friendVC = [[FriendsViewController alloc] init];
    friendVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:friendVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
