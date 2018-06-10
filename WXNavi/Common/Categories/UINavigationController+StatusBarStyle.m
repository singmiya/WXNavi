//
// Created by Somiya on 08/06/2018.
// Copyright (c) 2018 Somiya. All rights reserved.
//

#import "UINavigationController+StatusBarStyle.h"


@implementation UINavigationController (StatusBarStyle)
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end