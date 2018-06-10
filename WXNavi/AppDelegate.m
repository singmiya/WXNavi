//
//  AppDelegate.m
//  WXNavi
//
//  Created by Somiya on 06/06/2018.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "AppDelegate.h"
#import "DiscoverViewController.h"
#import "BaseNaviController.h"
#import <objc/runtime.h>
#import "FriendsViewController.h"
#import "CustomNaviBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    DiscoverViewController *mainView = [[DiscoverViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    BaseNaviController *navi = [[BaseNaviController alloc] initWithNavigationBarClass:[CustomNaviBar class] toolbarClass:nil];
//    navi.viewControllers = @[mainView];
    BaseNaviController *navi = [[BaseNaviController alloc] initWithRootViewController:mainView];
    [self setupNaviBar:navi.navigationBar];
    FriendsViewController *fvc = [[FriendsViewController alloc] init];
    BaseNaviController *navi1 = [[BaseNaviController alloc] initWithRootViewController:fvc];
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[navi, navi1];
    self.window.rootViewController = tab;
    return YES;
}

- (void)setupNaviBar:(UINavigationBar *)naviBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    naviBar.barStyle = UIBarStyleBlack;
    naviBar.tintColor = [UIColor whiteColor];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
